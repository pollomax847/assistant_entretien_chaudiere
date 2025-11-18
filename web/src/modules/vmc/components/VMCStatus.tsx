import React from 'react';

interface VMCStatusProps {
  status: {
    isRunning: boolean;
    mode: 'auto' | 'manual';
    speed: number;
    lastMaintenance: string;
    nextMaintenance: string;
  };
}

export const VMCStatus: React.FC<VMCStatusProps> = ({ status }) => {
  return (
    <div className="vmc-status">
      <h2>État de la VMC</h2>
      <div className="status-grid">
        <div className="status-item">
          <span className="label">État</span>
          <span className={`value ${status.isRunning ? 'running' : 'stopped'}`}>
            {status.isRunning ? 'En marche' : 'Arrêtée'}
          </span>
        </div>
        <div className="status-item">
          <span className="label">Mode</span>
          <span className="value">{status.mode === 'auto' ? 'Automatique' : 'Manuel'}</span>
        </div>
        <div className="status-item">
          <span className="label">Vitesse</span>
          <span className="value">{status.speed}</span>
        </div>
        <div className="status-item">
          <span className="label">Dernier entretien</span>
          <span className="value">{new Date(status.lastMaintenance).toLocaleDateString()}</span>
        </div>
        <div className="status-item">
          <span className="label">Prochain entretien</span>
          <span className="value">{new Date(status.nextMaintenance).toLocaleDateString()}</span>
        </div>
      </div>
    </div>
  );
};

export default VMCStatus; 