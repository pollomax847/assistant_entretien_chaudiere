import { useState, useEffect } from 'react';

interface VMCData {
  status: {
    isRunning: boolean;
    mode: 'auto' | 'manual';
    speed: number;
    lastMaintenance: string;
    nextMaintenance: string;
  };
  settings: {
    mode: 'auto' | 'manual';
    speed: number;
    schedule: {
      start: string;
      end: string;
    };
  };
  stats: {
    dailyUsage: number;
    monthlyUsage: number;
    yearlyUsage: number;
    efficiency: number;
    lastMaintenance: string;
    nextMaintenance: string;
  };
}

export const useVMCData = () => {
  const [data, setData] = useState<VMCData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        // TODO: Remplacer par un appel API réel
        const response = await fetch('/api/vmc');
        if (!response.ok) {
          throw new Error('Erreur lors de la récupération des données VMC');
        }
        const vmcData = await response.json();
        setData(vmcData);
      } catch (err) {
        setError(err instanceof Error ? err : new Error('Une erreur est survenue'));
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  const updateVMC = async (newSettings: VMCData['settings']) => {
    try {
      // TODO: Remplacer par un appel API réel
      const response = await fetch('/api/vmc', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(newSettings),
      });

      if (!response.ok) {
        throw new Error('Erreur lors de la mise à jour des paramètres VMC');
      }

      const updatedData = await response.json();
      setData(updatedData);
    } catch (err) {
      setError(err instanceof Error ? err : new Error('Une erreur est survenue'));
      throw err;
    }
  };

  return { data, loading, error, updateVMC };
}; 