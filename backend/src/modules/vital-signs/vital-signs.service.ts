import prisma from '../../config/database';
import { checkVitalAnomalies } from '../../utils/vitals';

export interface CreateVitalSignDto {
  heartRate?: number;
  temperature?: number;
  spO2?: number;
  steps?: number;
  source?: string;
  deviceId?: string;
  timestamp?: string;
}

export class VitalSignsService {
  async create(patientId: string, dto: CreateVitalSignDto) {
    const patient = await prisma.patient.findUnique({ where: { id: patientId } });
    if (!patient) throw new Error('Patient introuvable');

    const vitalSign = await prisma.vitalSign.create({
      data: {
        patientId,
        heartRate: dto.heartRate,
        temperature: dto.temperature,
        spO2: dto.spO2,
        steps: dto.steps,
        source: dto.source || 'manual',
        deviceId: dto.deviceId,
        timestamp: dto.timestamp ? new Date(dto.timestamp) : new Date(),
      },
    });

    // Auto-create alerts for any anomalies
    const anomalies = checkVitalAnomalies(dto.heartRate, dto.temperature, dto.spO2);
    for (const anomaly of anomalies) {
      if (anomaly.hasAnomaly && anomaly.type) {
        await prisma.alert.create({
          data: {
            patientId,
            type: anomaly.type as 'HIGH_TEMPERATURE' | 'LOW_SPO2' | 'ABNORMAL_HEART_RATE' | 'GENERAL',
            message: anomaly.message!,
            severity: anomaly.severity as 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL',
          },
        });
      }
    }

    return { vitalSign, anomalies };
  }

  async getHistory(patientId: string, limit = 50, offset = 0) {
    const [data, total] = await Promise.all([
      prisma.vitalSign.findMany({
        where: { patientId },
        orderBy: { timestamp: 'desc' },
        take: limit,
        skip: offset,
      }),
      prisma.vitalSign.count({ where: { patientId } }),
    ]);
    return { data, total, limit, offset };
  }

  async getLatest(patientId: string) {
    return prisma.vitalSign.findFirst({
      where: { patientId },
      orderBy: { timestamp: 'desc' },
    });
  }

  async getStats(patientId: string, days = 7) {
    const since = new Date();
    since.setDate(since.getDate() - days);

    const signs = await prisma.vitalSign.findMany({
      where: { patientId, timestamp: { gte: since } },
      orderBy: { timestamp: 'asc' },
    });

    if (!signs.length) return null;

    const avg = (arr: number[]) => arr.length ? arr.reduce((a, b) => a + b, 0) / arr.length : null;

    return {
      heartRate: {
        avg: avg(signs.map(s => s.heartRate).filter((v): v is number => v !== null)),
        min: Math.min(...signs.map(s => s.heartRate).filter((v): v is number => v !== null)),
        max: Math.max(...signs.map(s => s.heartRate).filter((v): v is number => v !== null)),
      },
      temperature: {
        avg: avg(signs.map(s => s.temperature).filter((v): v is number => v !== null)),
      },
      spO2: {
        avg: avg(signs.map(s => s.spO2).filter((v): v is number => v !== null)),
      },
      totalSteps: signs.map(s => s.steps ?? 0).reduce((a, b) => a + b, 0),
      records: signs,
    };
  }
}
