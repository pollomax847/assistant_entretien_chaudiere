import React, { useState } from 'react';

interface VMCControlsProps {
  isEditing: boolean;
  onEditToggle: () => void;
  onUpdate: (settings: VMCSettings) => void;
  currentSettings: VMCSettings;
}

interface VMCSettings {
  mode: 'auto' | 'manual';
  speed: number;
  schedule: {
    start: string;
    end: string;
  };
}

export const VMCControls: React.FC<VMCControlsProps> = ({
  isEditing,
  onEditToggle,
  onUpdate,
  currentSettings,
}) => {
  const [settings, setSettings] = useState<VMCSettings>(currentSettings);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onUpdate(settings);
    onEditToggle();
  };

  return (
    <div className="vmc-controls">
      <h2>Contrôles</h2>
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="mode">Mode</label>
          <select
            id="mode"
            value={settings.mode}
            onChange={(e) => setSettings({ ...settings, mode: e.target.value as 'auto' | 'manual' })}
            disabled={!isEditing}
          >
            <option value="auto">Automatique</option>
            <option value="manual">Manuel</option>
          </select>
        </div>

        <div className="form-group">
          <label htmlFor="speed">Vitesse</label>
          <input
            type="range"
            id="speed"
            min="1"
            max="3"
            value={settings.speed}
            onChange={(e) => setSettings({ ...settings, speed: parseInt(e.target.value) })}
            disabled={!isEditing}
          />
          <span className="speed-value">{settings.speed}</span>
        </div>

        <div className="form-group">
          <label htmlFor="schedule-start">Heure de début</label>
          <input
            type="time"
            id="schedule-start"
            value={settings.schedule.start}
            onChange={(e) =>
              setSettings({
                ...settings,
                schedule: { ...settings.schedule, start: e.target.value },
              })
            }
            disabled={!isEditing}
          />
        </div>

        <div className="form-group">
          <label htmlFor="schedule-end">Heure de fin</label>
          <input
            type="time"
            id="schedule-end"
            value={settings.schedule.end}
            onChange={(e) =>
              setSettings({
                ...settings,
                schedule: { ...settings.schedule, end: e.target.value },
              })
            }
            disabled={!isEditing}
          />
        </div>

        <div className="controls-actions">
          {isEditing ? (
            <>
              <button type="submit" className="btn-primary">
                Enregistrer
              </button>
              <button type="button" className="btn-secondary" onClick={onEditToggle}>
                Annuler
              </button>
            </>
          ) : (
            <button type="button" className="btn-primary" onClick={onEditToggle}>
              Modifier
            </button>
          )}
        </div>
      </form>
    </div>
  );
};

export default VMCControls; 