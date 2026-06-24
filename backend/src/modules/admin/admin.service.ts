import prisma from '../../config/database';
import { USER_SELECT } from '../../utils/prisma-select';

export class AdminService {
  async getPendingDoctors() {
    return prisma.user.findMany({
      where: { role: 'DOCTOR', isValidated: false },
      select: { ...USER_SELECT, doctor: true },
      orderBy: { createdAt: 'desc' },
    });
  }

  async validateDoctor(doctorUserId: string) {
    const user = await prisma.user.findUnique({ where: { id: doctorUserId } });
    if (!user || user.role !== 'DOCTOR') throw new Error('Médecin introuvable');
    if (user.isValidated) throw new Error('Ce compte est déjà validé');

    return prisma.user.update({
      where: { id: doctorUserId },
      data: { isValidated: true },
      select: { ...USER_SELECT, doctor: true },
    });
  }

  async rejectDoctor(doctorUserId: string) {
    const user = await prisma.user.findUnique({ where: { id: doctorUserId } });
    if (!user || user.role !== 'DOCTOR') throw new Error('Médecin introuvable');
    await prisma.user.delete({ where: { id: doctorUserId } });
  }

  async getAllUsers(role?: string) {
    return prisma.user.findMany({
      where: role ? { role: role as 'PATIENT' | 'DOCTOR' | 'ADMIN' | 'SUPER_ADMIN' } : undefined,
      select: { ...USER_SELECT, patient: true, doctor: true },
      orderBy: { createdAt: 'desc' },
    });
  }

  async deleteUser(userId: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw new Error('Utilisateur introuvable');
    if (user.role === 'SUPER_ADMIN') throw new Error('Impossible de supprimer un super administrateur');
    await prisma.user.delete({ where: { id: userId } });
  }

  async getDashboardStats() {
    const [totalPatients, totalDoctors, pendingDoctors, totalAlerts, criticalAlerts] =
      await Promise.all([
        prisma.patient.count(),
        prisma.doctor.count(),
        prisma.user.count({ where: { role: 'DOCTOR', isValidated: false } }),
        prisma.alert.count(),
        prisma.alert.count({ where: { severity: 'CRITICAL', isRead: false } }),
      ]);
    return { totalPatients, totalDoctors, pendingDoctors, totalAlerts, criticalAlerts };
  }

  async assignPatientToDoctor(patientId: string, doctorId: string) {
    const patient = await prisma.patient.findUnique({ where: { id: patientId } });
    if (!patient) throw new Error('Patient introuvable');
    const doctor = await prisma.doctor.findUnique({ where: { id: doctorId } });
    if (!doctor) throw new Error('Médecin introuvable');

    return prisma.patient.update({
      where: { id: patientId },
      data: { assignedDoctorId: doctorId },
      include: { assignedDoctor: true },
    });
  }
}
