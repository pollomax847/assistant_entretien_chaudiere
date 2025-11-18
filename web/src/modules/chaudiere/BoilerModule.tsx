import React, { useState } from 'react';
import ModuleTemplate from '../ModuleTemplate';
import { useBoilerData } from './hooks/useBoilerData';
import { BoilerStatus } from './components/BoilerStatus';
import { BoilerControls } from './components/BoilerControls';
import { BoilerStats } from './components/BoilerStats';

export const BoilerModule: React.FC = () => {
  const { data, loading, error, updateBoiler } = useBoilerData();
  const [isEditing, setIsEditing] = useState(false);

  if (loading) {
    return <div>Chargement...</div>;
  }

  if (error) {
    return <div>Erreur: {error.message}</div>;
  }

  return (
    <ModuleTemplate
      title="Gestion de la Chaudière"
      description="Contrôle et surveillance de la chaudière"
    >
      <div className="boiler-dashboard">
        <BoilerStatus status={data.status} />
        <BoilerControls
          isEditing={isEditing}
          onEditToggle={() => setIsEditing(!isEditing)}
          onUpdate={updateBoiler}
          currentSettings={data.settings}
        />
        <BoilerStats stats={data.stats} />
      </div>
    </ModuleTemplate>
  );
};

export default BoilerModule; 