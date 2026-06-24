export interface VitalThresholds {
  heartRate: { min: number; max: number };
  temperature: { min: number; max: number };
  spO2: { min: number };
}

export const THRESHOLDS: VitalThresholds = {
  heartRate: { min: 50, max: 120 },
  temperature: { min: 36.0, max: 38.5 },
  spO2: { min: 94 },
};

export interface AnomalyResult {
  hasAnomaly: boolean;
  type?: string;
  severity?: string;
  message?: string;
}

export const checkVitalAnomalies = (
  heartRate?: number | null,
  temperature?: number | null,
  spO2?: number | null
): AnomalyResult[] => {
  const anomalies: AnomalyResult[] = [];

  if (heartRate !== undefined && heartRate !== null) {
    if (heartRate > THRESHOLDS.heartRate.max) {
      anomalies.push({
        hasAnomaly: true,
        type: 'ABNORMAL_HEART_RATE',
        severity: heartRate > 150 ? 'CRITICAL' : 'HIGH',
        message: `Fréquence cardiaque élevée : ${heartRate} bpm`,
      });
    } else if (heartRate < THRESHOLDS.heartRate.min) {
      anomalies.push({
        hasAnomaly: true,
        type: 'ABNORMAL_HEART_RATE',
        severity: heartRate < 40 ? 'CRITICAL' : 'MEDIUM',
        message: `Fréquence cardiaque basse : ${heartRate} bpm`,
      });
    }
  }

  if (temperature !== undefined && temperature !== null) {
    if (temperature > THRESHOLDS.temperature.max) {
      anomalies.push({
        hasAnomaly: true,
        type: 'HIGH_TEMPERATURE',
        severity: temperature > 40 ? 'CRITICAL' : temperature > 39 ? 'HIGH' : 'MEDIUM',
        message: `Température élevée : ${temperature}°C`,
      });
    }
  }

  if (spO2 !== undefined && spO2 !== null) {
    if (spO2 < THRESHOLDS.spO2.min) {
      anomalies.push({
        hasAnomaly: true,
        type: 'LOW_SPO2',
        severity: spO2 < 90 ? 'CRITICAL' : 'HIGH',
        message: `Saturation en oxygène basse : ${spO2}%`,
      });
    }
  }

  return anomalies;
};
