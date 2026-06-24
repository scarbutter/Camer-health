import prisma from '../../config/database';
import { stripUser, stripNested } from '../../utils/strip-password';

export class PatientsService {
  async getProfile(userId: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      include: {
        patient: {
          include: {
            assignedDoctor: {
              include: { user: true },
            },
          },
        },
      },
    });
    if (!user || !user.patient) throw new Error('Patient introuvable');
    const { password: _pw, ...safeUser } = user;
    if (safeUser.patient?.assignedDoctor) {
      (safeUser.patient.assignedDoctor as Record<string, unknown>).user =
        stripUser(safeUser.patient.assignedDoctor.user);
    }
    return safeUser;
  }

  async updateProfile(
    userId: string,
    data: {
      firstName?: string;
      lastName?: string;
      phone?: string;
      address?: string;
      dateOfBirth?: string;
      photoUrl?: string;
    }
  ) {
    const patient = await prisma.patient.findFirst({ where: { userId } });
    if (!patient) throw new Error('Patient introuvable');
    return prisma.patient.update({
      where: { id: patient.id },
      data: {
        ...data,
        dateOfBirth: data.dateOfBirth ? new Date(data.dateOfBirth) : undefined,
      },
    });
  }

  async getPatientById(patientId: string) {
    const patient = await prisma.patient.findUnique({
      where: { id: patientId },
      include: {
        user: true,
        assignedDoctor: { include: { user: true } },
        medicalHistory: true,
      },
    });
    if (!patient) throw new Error('Patient introuvable');
    const safe = { ...patient, user: stripUser(patient.user) };
    if (safe.assignedDoctor) {
      (safe.assignedDoctor as Record<string, unknown>).user = stripUser(safe.assignedDoctor.user);
    }
    return safe;
  }

  async listPatients() {
    const patients = await prisma.patient.findMany({
      include: {
        user: true,
        assignedDoctor: { select: { firstName: true, lastName: true, specialization: true } },
      },
      orderBy: { user: { createdAt: 'desc' } },
    });
    return patients.map(p => ({ ...p, user: stripUser(p.user) }));
  }
}
