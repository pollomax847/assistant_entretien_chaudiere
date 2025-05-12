import React from 'react';

interface VMCStatsProps {
  stats: {
    dailyUsage: number;
    monthlyUsage: number;
    yearlyUsage: number;
    efficiency: number;
    lastMaintenance: string;
    nextMaintenance: string;
  };
}

export const VMCStats: React.FC<VMCStatsProps> = ({ stats }) => {
  return (
    <div className="vmc-stats">
      <h2>Statistiques</h2>
      <div className="stats-grid">
        <div className="stat-card">
          <h3>Utilisation quotidienne</h3>
          <p className="stat-value">{stats.dailyUsage} heures</p>
        </div>
        <div className="stat-card">
          <h3>Utilisation mensuelle</h3>
          <p className="stat-value">{stats.monthlyUsage} heures</p>
        </div>
        <div className="stat-card">
          <h3>Utilisation annuelle</h3>
          <p className="stat-value">{stats.yearlyUsage} heures</p>
        </div>
        <div className="stat-card">
          <h3>Efficacité</h3>
          <p className="stat-value">{stats.efficiency}%</p>
        </div>
        <div className="stat-card">
          <h3>Dernier entretien</h3>
          <p className="stat-value">{new Date(stats.lastMaintenance).toLocaleDateString()}</p>
        </div>
        <div className="stat-card">
          <h3>Prochain entretien</h3>
          <p className="stat-value">{new Date(stats.nextMaintenance).toLocaleDateString()}</p>
        </div>
      </div>
    </div>
  );
};

export default VMCStats; 