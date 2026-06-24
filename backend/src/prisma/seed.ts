import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  console.log('Seeding database...');

  const hash = (pw: string) => bcrypt.hash(pw, 12);

  // Super Admin
  const superAdminPw = await hash('superadmin123');
  const superAdmin = await prisma.user.upsert({
    where: { email: 'superadmin@camerhealth.cm' },
    update: {},
    create: {
      email: 'superadmin@camerhealth.cm',
      password: superAdminPw,
      role: 'SUPER_ADMIN',
      isValidated: true,
      admin: { create: { name: 'Super Administrateur' } },
    },
  });
  console.log('✅ Super Admin:', superAdmin.email);

  // Demo Doctor (validated)
  const doctorPw = await hash('doctor123');
  const doctor1 = await prisma.user.upsert({
    where: { email: 'dr.mbetsi@camerhealth.cm' },
    update: {},
    create: {
      email: 'dr.mbetsi@camerhealth.cm',
      password: doctorPw,
      role: 'DOCTOR',
      isValidated: true,
      doctor: {
        create: {
          firstName: 'Lindsey',
          lastName: 'Mbetsi',
          specialization: 'Cardiologue',
          phone: '+237690555001',
          address: 'Yaoundé, Bastos',
          yearsExperience: 8,
          rating: 4.8,
          description: 'Cardiologue expérimenté spécialisé dans la télémédecine.',
        },
      },
    },
  });
  console.log('✅ Doctor:', doctor1.email);

  // Demo Doctor (pending validation)
  const doctor2 = await prisma.user.upsert({
    where: { email: 'dr.pending@camerhealth.cm' },
    update: {},
    create: {
      email: 'dr.pending@camerhealth.cm',
      password: doctorPw,
      role: 'DOCTOR',
      isValidated: false,
      doctor: {
        create: {
          firstName: 'Jean',
          lastName: 'Nkoa',
          specialization: 'Pneumologue',
          phone: '+237690555002',
          yearsExperience: 5,
          rating: 0,
        },
      },
    },
  });
  console.log('⏳ Pending Doctor:', doctor2.email);

  // Demo Patient
  const patientPw = await hash('patient123');
  const patient1 = await prisma.user.upsert({
    where: { email: 'patient.demo@camerhealth.cm' },
    update: {},
    create: {
      email: 'patient.demo@camerhealth.cm',
      password: patientPw,
      role: 'PATIENT',
      isValidated: true,
      patient: {
        create: {
          firstName: 'Marie',
          lastName: 'Fouda',
          phone: '+237670111222',
          address: 'Yaoundé, Melen',
          dateOfBirth: new Date('1990-05-15'),
        },
      },
    },
  });
  console.log('✅ Patient:', patient1.email);

  // Assign patient to doctor
  const doctorRecord = await prisma.doctor.findFirst({ where: { userId: doctor1.id } });
  const patientRecord = await prisma.patient.findFirst({ where: { userId: patient1.id } });
  if (doctorRecord && patientRecord) {
    await prisma.patient.update({
      where: { id: patientRecord.id },
      data: { assignedDoctorId: doctorRecord.id },
    });
    console.log('✅ Patient assigned to doctor');
  }

  console.log('\n✅ Seed complete!\n');
  console.log('Test accounts:');
  console.log('  Super Admin: superadmin@camerhealth.cm / superadmin123');
  console.log('  Doctor:      dr.mbetsi@camerhealth.cm / doctor123');
  console.log('  Patient:     patient.demo@camerhealth.cm / patient123');
  console.log('  Pending Doc: dr.pending@camerhealth.cm / doctor123 (needs validation)');
}

main().catch(console.error).finally(() => prisma.$disconnect());
