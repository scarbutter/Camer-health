import prisma from '../../config/database';
import { stripUser } from '../../utils/strip-password';

export class DoctorsService {
  async getProfile(userId: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      include: {
        doctor: {
          include: {
            patients: { include: { user: true } },
          },
        },
      },
    });
    if (!user || !user.doctor) throw new Error('Médecin introuvable');
    const { password: _pw, ...safeUser } = user;
    const safePatients = safeUser.doctor!.patients.map(p => ({
      ...p,
      user: stripUser(p.user),
    }));
    return { ...safeUser, doctor: { ...safeUser.doctor!, patients: safePatients } };
  }

  async updateProfile(
    userId: string,
    data: {
      firstName?: string;
      lastName?: string;
      specialization?: string;
      phone?: string;
      address?: string;
      yearsExperience?: number;
      description?: string;
      photoUrl?: string;
    }
  ) {
    const doctor = await prisma.doctor.findFirst({ where: { userId } });
    if (!doctor) throw new Error('Médecin introuvable');
    return prisma.doctor.update({ where: { id: doctor.id }, data });
  }

  async listDoctors(specialization?: string) {
    const doctors = await prisma.doctor.findMany({
      where: {
        user: { isValidated: true },
        ...(specialization
          ? { specialization: { contains: specialization, mode: 'insensitive' } }
          : {}),
      },
      include: { user: true },
      orderBy: { rating: 'desc' },
    });
    return doctors.map(d => ({ ...d, user: stripUser(d.user) }));
  }

  async getDoctorById(doctorId: string) {
    const doctor = await prisma.doctor.findUnique({
      where: { id: doctorId },
      include: {
        user: true,
        patients: { include: { user: true } },
      },
    });
    if (!doctor) throw new Error('Médecin introuvable');
    return {
      ...doctor,
      user: stripUser(doctor.user),
      patients: doctor.patients.map(p => ({ ...p, user: stripUser(p.user) })),
    };
  }

  async getMyPatients(userId: string) {
    const doctor = await prisma.doctor.findFirst({ where: { userId } });
    if (!doctor) throw new Error('Médecin introuvable');

    const patients = await prisma.patient.findMany({
      where: { assignedDoctorId: doctor.id },
      include: {
        user: true,
        vitalSigns: { orderBy: { timestamp: 'desc' }, take: 1 },
        alerts: { where: { isRead: false }, orderBy: { createdAt: 'desc' } },
      },
    });
    return patients.map(p => ({ ...p, user: stripUser(p.user) }));
  }
}
