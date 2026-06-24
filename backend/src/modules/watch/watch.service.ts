import prisma from '../../config/database';
import { VitalSignsService } from '../vital-signs/vital-signs.service';

const vitalSignsService = new VitalSignsService();

export interface WatchPayload {
  deviceId: string;
  heartRate?: number;
  temperature?: number;
  spO2?: number;
  steps?: number;
  timestamp?: string;
}

export class WatchService {
  /**
   * Receives data from a connected smartwatch (real or simulated).
   * The watch authenticates via the patient's JWT token.
   */
  async receiveFromWatch(patientUserId: string, payload: WatchPayload) {
    const patient = await prisma.patient.findFirst({ where: { userId: patientUserId } });
    if (!patient) throw new Error('Patient introuvable');

    return vitalSignsService.create(patient.id, {
      ...payload,
      source: 'watch',
    });
  }

  /**
   * Simulates a batch of realistic vital sign readings for a patient.
   * Used for development/demo when no real watch is available.
   */
  async simulateWatchData(patientUserId: string, count = 5) {
    const patient = await prisma.patient.findFirst({ where: { userId: patientUserId } });
    if (!patient) throw new Error('Patient introuvable');

    const results = [];
    const now = Date.now();

    for (let i = 0; i < count; i++) {
      // Generate realistic vitals with slight random variation
      const heartRate = 70 + Math.floor(Math.random() * 30); // 70-100
      const temperature = 36.5 + parseFloat((Math.random() * 1.5).toFixed(1)); // 36.5-38.0
      const spO2 = 95 + Math.floor(Math.random() * 5); // 95-99
      const steps = Math.floor(Math.random() * 200);

      const result = await vitalSignsService.create(patient.id, {
        heartRate,
        temperature,
        spO2,
        steps,
        source: 'watch_simulated',
        deviceId: 'SIMULATED_DEVICE_001',
        timestamp: new Date(now - i * 5 * 60 * 1000).toISOString(), // every 5 min
      });
      results.push(result);
    }

    return results;
  }

  async getWatchStatus(patientUserId: string) {
    const patient = await prisma.patient.findFirst({ where: { userId: patientUserId } });
    if (!patient) throw new Error('Patient introuvable');

    const latest = await prisma.vitalSign.findFirst({
      where: { patientId: patient.id, source: { in: ['watch', 'watch_simulated'] } },
      orderBy: { timestamp: 'desc' },
    });

    return {
      connected: !!latest,
      lastSyncAt: latest?.timestamp ?? null,
      deviceId: latest?.deviceId ?? null,
    };
  }
}
