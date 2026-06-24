import prisma from '../../config/database';

export interface MedicalHistoryDto {
  allergies?: string;
  chronicDiseases?: string;
  medications?: string;
  surgeries?: string;
  familyHistory?: string;
  notes?: string;
}

export class MedicalHistoryService {
  async upsert(patientUserId: string, dto: MedicalHistoryDto) {
    const patient = await prisma.patient.findFirst({ where: { userId: patientUserId } });
    if (!patient) throw new Error('Patient introuvable');

    return prisma.medicalHistory.upsert({
      where: { patientId: patient.id },
      create: { patientId: patient.id, ...dto },
      update: dto,
    });
  }

  async get(patientId: string) {
    return prisma.medicalHistory.findUnique({ where: { patientId } });
  }
}
