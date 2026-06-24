# CamerHealth Backend API

Backend REST API + WebSocket server for the CamerHealth patient monitoring application.

**Stack**: Node.js · TypeScript · Express · Prisma · PostgreSQL · Socket.io

---

## Project Structure

```
src/
├── app.ts                        # Entry point, Express + Socket.io setup
├── config/
│   ├── database.ts               # Prisma client singleton
│   └── jwt.ts                    # JWT config
├── middleware/
│   ├── auth.middleware.ts         # JWT authentication + role guard
│   └── upload.middleware.ts       # Multer file upload
├── modules/
│   ├── auth/                     # Register, login, change password
│   ├── admin/                    # Super admin: validate doctors, manage users
│   ├── patients/                 # Patient profile + medical history
│   ├── doctors/                  # Doctor profile + patient list
│   ├── vital-signs/              # Physiological data CRUD + stats
│   ├── alerts/                   # Anomaly alerts
│   ├── messages/                 # Doctor ↔ patient messaging
│   ├── appointments/             # Appointment requests
│   └── watch/                    # Smartwatch sync + simulation
├── socket/
│   └── socket.ts                 # Socket.io real-time events
├── utils/
│   ├── response.ts               # Unified JSON response helpers
│   ├── vitals.ts                 # Vital sign anomaly detection thresholds
│   ├── prisma-select.ts          # Shared Prisma select constants
│   └── strip-password.ts         # Post-query password removal helpers
└── prisma/
    └── seed.ts                   # Demo data seeder
```

---

## Quick Start

### 1. Prerequisites
- Node.js >= 18
- PostgreSQL running locally (or update `DATABASE_URL` for a remote DB)

### 2. Configure environment
```bash
cp .env.example .env
# Edit .env and set your DATABASE_URL and JWT_SECRET
```

### 3. Install dependencies
```bash
npm install
```

### 4. Create the database and run migrations
```bash
npx prisma migrate dev --name init
```

### 5. Seed demo data
```bash
npm run prisma:seed
```

### 6. Start the dev server
```bash
npm run dev
# Server: http://localhost:3000
```

---

## Demo Accounts (after seed)

| Role        | Email                             | Password       |
|-------------|-----------------------------------|----------------|
| Super Admin | superadmin@camerhealth.cm         | superadmin123  |
| Doctor      | dr.mbetsi@camerhealth.cm          | doctor123      |
| Patient     | patient.demo@camerhealth.cm       | patient123     |
| Pending Doc | dr.pending@camerhealth.cm         | doctor123      |

---

## API Reference

All endpoints return `{ success, message, data }`.  
Authenticated endpoints require: `Authorization: Bearer <token>`

### Auth
| Method | Endpoint                         | Auth | Description |
|--------|----------------------------------|------|-------------|
| POST   | /api/auth/register/patient       | No   | Register patient (auto-validated) |
| POST   | /api/auth/register/doctor        | No   | Register doctor (awaits admin approval) |
| POST   | /api/auth/login                  | No   | Login (all roles) |
| GET    | /api/auth/me                     | Yes  | Current user profile |
| POST   | /api/auth/change-password        | Yes  | Change password |

### Admin (SUPER_ADMIN / ADMIN only)
| Method | Endpoint                         | Description |
|--------|----------------------------------|-------------|
| GET    | /api/admin/stats                 | Dashboard counts |
| GET    | /api/admin/users?role=DOCTOR     | List users |
| DELETE | /api/admin/users/:userId         | Delete user |
| GET    | /api/admin/doctors/pending       | Doctors awaiting validation |
| PATCH  | /api/admin/doctors/:userId/validate | ✅ Validate doctor account |
| DELETE | /api/admin/doctors/:userId/reject   | ❌ Reject & delete doctor |
| POST   | /api/admin/assign-patient        | `{ patientId, doctorId }` |

### Patients
| Method | Endpoint                         | Description |
|--------|----------------------------------|-------------|
| GET    | /api/patients/me                 | Own profile |
| PUT    | /api/patients/me                 | Update profile (multipart/form-data, field: `photo`) |
| GET    | /api/patients/me/medical-history | Own medical history |
| PUT    | /api/patients/me/medical-history | Update medical history |
| GET    | /api/patients                    | All patients (doctor/admin) |
| GET    | /api/patients/:patientId         | Patient detail (doctor/admin) |

### Doctors
| Method | Endpoint                         | Description |
|--------|----------------------------------|-------------|
| GET    | /api/doctors/me                  | Own profile |
| PUT    | /api/doctors/me                  | Update profile |
| GET    | /api/doctors/me/patients         | Assigned patients |
| GET    | /api/doctors?specialization=X    | List validated doctors |
| GET    | /api/doctors/:doctorId           | Doctor detail |

### Vital Signs
| Method | Endpoint                           | Description |
|--------|------------------------------------|-------------|
| POST   | /api/vitals/me                     | Submit own vitals (auto-creates alerts) |
| GET    | /api/vitals/me                     | History (`?limit=50&offset=0`) |
| GET    | /api/vitals/me/latest              | Latest reading |
| GET    | /api/vitals/me/stats?days=7        | Aggregated stats |
| POST   | /api/vitals/:patientId             | Doctor submits for patient |
| GET    | /api/vitals/:patientId             | Doctor reads patient history |

**Vital Sign Body:**
```json
{ "heartRate": 90, "temperature": 37.2, "spO2": 98, "steps": 500 }
```

**Alert thresholds (auto-applied):**
- Heart rate: < 50 or > 120 bpm
- Temperature: > 38.5 °C
- SpO2: < 94%

### Alerts
| Method | Endpoint                  | Description |
|--------|---------------------------|-------------|
| GET    | /api/alerts?unread=true   | My alerts |
| PATCH  | /api/alerts/:id/read      | Mark one as read |
| PATCH  | /api/alerts/read-all      | Mark all as read (patient) |

### Messages
Rules: doctor → any assigned patient; patient → assigned doctor only.

| Method | Endpoint                      | Description |
|--------|-------------------------------|-------------|
| GET    | /api/messages                 | Conversation list |
| GET    | /api/messages/unread          | Unread count |
| GET    | /api/messages/:partnerId      | Full conversation |
| POST   | /api/messages/:receiverId     | Send message (multipart for media) |

**Message Body:** `{ content: "text", type: "TEXT" }` — type: TEXT / IMAGE / AUDIO / FILE

### Appointments
| Method | Endpoint                                  | Description |
|--------|-------------------------------------------|-------------|
| POST   | /api/appointments                         | Request appointment (patient) |
| GET    | /api/appointments                         | My appointments |
| PATCH  | /api/appointments/:id/status              | Update status (doctor) |

### Smartwatch
| Method | Endpoint              | Description |
|--------|-----------------------|-------------|
| POST   | /api/watch/sync       | Receive real watch data |
| POST   | /api/watch/simulate?count=5 | Generate demo readings |
| GET    | /api/watch/status     | Last sync info |

---

## Real-time (Socket.io)

Connect with: `{ auth: { token: "<JWT>" } }`

| Event (client → server) | Payload            | Description |
|-------------------------|--------------------|-------------|
| `join_conversation`     | `partnerId: string`| Join a chat room |

| Event (server → client) | Payload    | Description |
|-------------------------|------------|-------------|
| `new_message`           | message    | Incoming message |
| `new_alert`             | alert      | New vital sign alert |
