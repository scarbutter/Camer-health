import prisma from '../../config/database';
import { stripUser } from '../../utils/strip-password';

export class MessagesService {
  async validateConversationPermission(senderId: string, receiverId: string): Promise<void> {
    const sender = await prisma.user.findUnique({
      where: { id: senderId },
      include: { patient: true, doctor: true },
    });
    if (!sender) throw new Error('Expéditeur introuvable');

    if (sender.role === 'PATIENT') {
      if (!sender.patient?.assignedDoctorId) {
        throw new Error('Aucun médecin assigné. Vous ne pouvez pas encore envoyer de messages.');
      }
      const assignedDoc = await prisma.doctor.findUnique({
        where: { id: sender.patient.assignedDoctorId },
      });
      if (!assignedDoc || assignedDoc.userId !== receiverId) {
        throw new Error('Vous pouvez uniquement discuter avec votre médecin assigné.');
      }
    } else if (sender.role === 'DOCTOR') {
      if (!sender.doctor) throw new Error('Profil médecin introuvable');
      const patient = await prisma.patient.findFirst({
        where: { userId: receiverId, assignedDoctorId: sender.doctor.id },
      });
      if (!patient) throw new Error("Ce patient n'est pas assigné à vous.");
    } else {
      throw new Error('Seuls les médecins et les patients peuvent échanger des messages.');
    }
  }

  async sendMessage(
    senderId: string,
    receiverId: string,
    content?: string,
    type = 'TEXT',
    mediaUrl?: string
  ) {
    await this.validateConversationPermission(senderId, receiverId);

    const msg = await prisma.message.create({
      data: {
        senderId,
        receiverId,
        content,
        type: type as 'TEXT' | 'IMAGE' | 'AUDIO' | 'FILE',
        mediaUrl,
      },
      include: { sender: true, receiver: true },
    });
    return {
      ...msg,
      sender: stripUser(msg.sender),
      receiver: stripUser(msg.receiver),
    };
  }

  async getConversation(userAId: string, userBId: string, limit = 50, offset = 0) {
    const [messages, total] = await Promise.all([
      prisma.message.findMany({
        where: {
          OR: [
            { senderId: userAId, receiverId: userBId },
            { senderId: userBId, receiverId: userAId },
          ],
        },
        orderBy: { createdAt: 'asc' },
        take: limit,
        skip: offset,
        include: { sender: true },
      }),
      prisma.message.count({
        where: {
          OR: [
            { senderId: userAId, receiverId: userBId },
            { senderId: userBId, receiverId: userAId },
          ],
        },
      }),
    ]);

    await prisma.message.updateMany({
      where: { senderId: userBId, receiverId: userAId, isRead: false },
      data: { isRead: true },
    });

    return {
      messages: messages.map(m => ({ ...m, sender: stripUser(m.sender) })),
      total,
      limit,
      offset,
    };
  }

  async getConversationList(userId: string) {
    const messages = await prisma.message.findMany({
      where: { OR: [{ senderId: userId }, { receiverId: userId }] },
      orderBy: { createdAt: 'desc' },
      include: {
        sender: { include: { patient: true, doctor: true } },
        receiver: { include: { patient: true, doctor: true } },
      },
    });

    const seen = new Set<string>();
    return messages
      .filter(msg => {
        const partnerId = msg.senderId === userId ? msg.receiverId : msg.senderId;
        if (seen.has(partnerId)) return false;
        seen.add(partnerId);
        return true;
      })
      .map(msg => ({
        ...msg,
        sender: stripUser(msg.sender),
        receiver: stripUser(msg.receiver),
      }));
  }

  async getUnreadCount(userId: string): Promise<number> {
    return prisma.message.count({ where: { receiverId: userId, isRead: false } });
  }
}
