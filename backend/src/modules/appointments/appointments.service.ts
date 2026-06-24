import prisma from '../../config/database';
import { stripUser } from '../../utils/strip-password';

export class AppointmentsService {
  async createRequest(patientUserId: string, doctorId: string, reason?: string, date?: string) {
    const patient = await prisma.patient.findFirst({ where: { userId: patientUserId } });
    if (!patient) throw new Error('Patient introuvable');
    const doctor = await prisma.doctor.findUnique({ where: { id: doctorId } });
    if (!doctor) throw new Error('Médecin introuvable');

    const appt = await prisma.appointment.create({
      data: {
        patientId: patient.id,
        doctorId,
        reason,
        date: date ? new Date(date) : undefined,
        status: 'PENDING',
      },
      include: {
        patient: { include: { user: true } },
        doctor: { include: { user: true } },
      },
    });
    return {
      ...appt,
      patient: { ...appt.patient, user: stripUser(appt.patient.user) },
      doctor: { ...appt.doctor, user: stripUser(appt.doctor.user) },
    };
  }

  async getMyAppointments(userId: string, role: string) {
    if (role === 'PATIENT') {
      const patient = await prisma.patient.findFirst({ where: { userId } });
      if (!patient) throw new Error('Patient introuvable');
      const appts = await prisma.appointment.findMany({
        where: { patientId: patient.id },
        include: { doctor: { include: { user: true } } },
        orderBy: { createdAt: 'desc' },
      });
      return appts.map(a => ({ ...a, doctor: { ...a.doctor, user: stripUser(a.doctor.user) } }));
    } else {
      const doctor = await prisma.doctor.findFirst({ where: { userId } });
      if (!doctor) throw new Error('Médecin introuvable');
      const appts = await prisma.appointment.findMany({
        where: { doctorId: doctor.id },
        include: { patient: { include: { user: true } } },
        orderBy: { createdAt: 'desc' },
      });
      return appts.map(a => ({ ...a, patient: { ...a.patient, user: stripUser(a.patient.user) } }));
    }
  }

  async updateStatus(appointmentId: string, status: string, notes?: string) {
    return prisma.appointment.update({
      where: { id: appointmentId },
      data: { status: status as 'PENDING' | 'CONFIRMED' | 'CANCELLED' | 'COMPLETED', notes },
    });
  }
}
