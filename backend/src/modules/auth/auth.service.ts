import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import prisma from '../../config/database';
import { jwtConfig } from '../../config/jwt';

export interface RegisterPatientDto {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  phone?: string;
  dateOfBirth?: string;
}

export interface RegisterDoctorDto {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  specialization?: string;
  phone?: string;
  address?: string;
  yearsExperience?: number;
  description?: string;
}

export interface LoginDto {
  email: string;
  password: string;
}

export class AuthService {
  async registerPatient(dto: RegisterPatientDto) {
    const exists = await prisma.user.findUnique({ where: { email: dto.email } });
    if (exists) throw new Error('Cet email est déjà utilisé');

    const hashed = await bcrypt.hash(dto.password, 12);

    const user = await prisma.user.create({
      data: {
        email: dto.email,
        password: hashed,
        role: 'PATIENT',
        isValidated: true, // patients validate themselves immediately
        patient: {
          create: {
            firstName: dto.firstName,
            lastName: dto.lastName,
            phone: dto.phone,
            dateOfBirth: dto.dateOfBirth ? new Date(dto.dateOfBirth) : undefined,
          },
        },
      },
      include: { patient: true },
    });

    const token = this.generateToken(user.id, user.role);
    return { token, user: this.sanitizeUser(user) };
  }

  async registerDoctor(dto: RegisterDoctorDto) {
    const exists = await prisma.user.findUnique({ where: { email: dto.email } });
    if (exists) throw new Error('Cet email est déjà utilisé');

    const hashed = await bcrypt.hash(dto.password, 12);

    // Doctors are NOT validated until super admin approves
    const user = await prisma.user.create({
      data: {
        email: dto.email,
        password: hashed,
        role: 'DOCTOR',
        isValidated: false,
        doctor: {
          create: {
            firstName: dto.firstName,
            lastName: dto.lastName,
            specialization: dto.specialization,
            phone: dto.phone,
            address: dto.address,
            yearsExperience: dto.yearsExperience || 0,
            description: dto.description,
          },
        },
      },
      include: { doctor: true },
    });

    return { user: this.sanitizeUser(user), message: 'Compte créé. En attente de validation par l\'administrateur.' };
  }

  async login(dto: LoginDto) {
    const user = await prisma.user.findUnique({
      where: { email: dto.email },
      include: { patient: true, doctor: true, admin: true },
    });

    if (!user) throw new Error('Email ou mot de passe incorrect');
    const valid = await bcrypt.compare(dto.password, user.password);
    if (!valid) throw new Error('Email ou mot de passe incorrect');

    if (!user.isValidated) {
      throw new Error('Votre compte est en attente de validation par un administrateur');
    }

    const token = this.generateToken(user.id, user.role);
    return { token, user: this.sanitizeUser(user) };
  }

  async changePassword(userId: string, oldPassword: string, newPassword: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw new Error('Utilisateur introuvable');

    const valid = await bcrypt.compare(oldPassword, user.password);
    if (!valid) throw new Error('Ancien mot de passe incorrect');

    const hashed = await bcrypt.hash(newPassword, 12);
    await prisma.user.update({ where: { id: userId }, data: { password: hashed } });
  }

  private generateToken(userId: string, role: string): string {
    return jwt.sign({ userId, role }, jwtConfig.secret, {
      expiresIn: jwtConfig.expiresIn as jwt.SignOptions['expiresIn'],
    });
  }

  private sanitizeUser(user: Record<string, unknown>) {
    const { password: _pw, ...safe } = user as { password: string } & Record<string, unknown>;
    return safe;
  }
}
