import React, { useState } from 'react';

interface BoilerControlsProps {
  isEditing: boolean;
  onEditToggle: () => void;
  onUpdate: (settings: BoilerSettings) => void;
  currentSettings: BoilerSettings;
}

interface BoilerSettings {
  mode: 'auto' | 'manual' | 'eco';
  targetTemperature: number;
  schedule: {
    start: string;
    end: string;
    weekDays: number[];
  };
  ecoSettings: {
    nightTemperature: number;
    dayTemperature: number;
  };
}

export const BoilerControls: React.FC<BoilerControlsProps> = ({
  isEditing,
  onEditToggle,
  onUpdate,
  currentSettings,
}) => {
  const [settings, setSettings] = useState<BoilerSettings>(currentSettings);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onUpdate(settings);
    onEditToggle();
  };

  const weekDays = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
    'Dimanche',
  ];

  return (
    <div className="boiler-controls">
      <h2>Contrôles</h2>
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="mode">Mode</label>
          <select
            id="mode"
            value={settings.mode}
            onChange={(e) => setSettings({ ...settings, mode: e.target.value as BoilerSettings['mode'] })}
            disabled={!isEditing}
          >
            <option value="auto">Automatique</option>
            <option value="manual">Manuel</option>
            <option value="eco">Économique</option>
          </select>
        </div>

        <div className="form-group">
          <label htmlFor="targetTemperature">Température cible</label>
          <input
            type="number"
            id="targetTemperature"
            min="15"
            max="30"
            value={settings.targetTemperature}
            onChange={(e) => setSettings({ ...settings, targetTemperature: parseInt(e.target.value) })}
            disabled={!isEditing}
          />
          <span className="unit">°C</span>
        </div>

        {settings.mode === 'eco' && (
          <>
            <div className="form-group">
              <label htmlFor="nightTemperature">Température nuit</label>
              <input
                type="number"
                id="nightTemperature"
                min="15"
                max="25"
                value={settings.ecoSettings.nightTemperature}
                onChange={(e) =>
                  setSettings({
                    ...settings,
                    ecoSettings: {
                      ...settings.ecoSettings,
                      nightTemperature: parseInt(e.target.value),
                    },
                  })
                }
                disabled={!isEditing}
              />
              <span className="unit">°C</span>
            </div>

            <div className="form-group">
              <label htmlFor="dayTemperature">Température jour</label>
              <input
                type="number"
                id="dayTemperature"
                min="15"
                max="25"
                value={settings.ecoSettings.dayTemperature}
                onChange={(e) =>
                  setSettings({
                    ...settings,
                    ecoSettings: {
                      ...settings.ecoSettings,
                      dayTemperature: parseInt(e.target.value),
                    },
                  })
                }
                disabled={!isEditing}
              />
              <span className="unit">°C</span>
            </div>
          </>
        )}

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

        <div className="form-group">
          <label>Jours de la semaine</label>
          <div className="weekdays-grid">
            {weekDays.map((day, index) => (
              <label key={day} className="weekday-checkbox">
                <input
                  type="checkbox"
                  checked={settings.schedule.weekDays.includes(index)}
                  onChange={(e) => {
                    const newWeekDays = e.target.checked
                      ? [...settings.schedule.weekDays, index]
                      : settings.schedule.weekDays.filter((d) => d !== index);
                    setSettings({
                      ...settings,
                      schedule: { ...settings.schedule, weekDays: newWeekDays },
                    });
                  }}
                  disabled={!isEditing}
                />
                {day}
              </label>
            ))}
          </div>
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

export default BoilerControls; 