import React, { useState, useEffect } from 'react';
import ModuleTemplate from '../ModuleTemplate';
import { useVMCData } from './hooks/useVMCData';
import { VMCStatus } from './components/VMCStatus';
import { VMCControls } from './components/VMCControls';
import { VMCStats } from './components/VMCStats';

export const VMCModule: React.FC = () => {
  const { data, loading, error, updateVMC } = useVMCData();
  const [isEditing, setIsEditing] = useState(false);

  if (loading) {
    return <div>Chargement...</div>;
  }

  if (error) {
    return <div>Erreur: {error.message}</div>;
  }

  return (
    <ModuleTemplate
      title="Gestion de la VMC"
      description="Contrôle et surveillance de la ventilation mécanique contrôlée"
    >
      <div className="vmc-dashboard">
        <VMCStatus status={data.status} />
        <VMCControls
          isEditing={isEditing}
          onEditToggle={() => setIsEditing(!isEditing)}
          onUpdate={updateVMC}
          currentSettings={data.settings}
        />
        <VMCStats stats={data.stats} />
      </div>
    </ModuleTemplate>
  );
};

export default VMCModule; 