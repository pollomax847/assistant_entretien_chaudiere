export class PreferencesManager {
    constructor() {
        this.prefs = {
            technicien: '',
            theme: 'light',
            logo: null,
            temperatureUnit: '°C'
        };
        this.loadPreferences();
    }

    loadPreferences() {
        const savedPrefs = localStorage.getItem('chauffageExpertPrefs');
        if (savedPrefs) {
            this.prefs = { ...this.prefs, ...JSON.parse(savedPrefs) };
        }
    }

    savePreferences() {
        localStorage.setItem('chauffageExpertPrefs', JSON.stringify(this.prefs));
    }

    setPreference(key, value) {
        this.prefs[key] = value;
        this.savePreferences();
        this.applyPreference(key, value);
    }

    getPreference(key) {
        return this.prefs[key];
    }

    applyPreference(key, value) {
        switch (key) {
            case 'theme':
                document.body.setAttribute('data-theme', value);
                break;
            case 'logo':
                const logoElement = document.getElementById('companyLogo');
                if (logoElement && value) {
                    logoElement.src = value;
                }
                break;
            case 'temperatureUnit':
                // Mettre à jour l'affichage des températures dans l'application
                this.updateTemperatureDisplays();
                break;
        }
    }

    updateTemperatureDisplays() {
        const unit = this.prefs.temperatureUnit;
        const displays = document.querySelectorAll('[data-temperature]');
        displays.forEach(display => {
            const value = display.getAttribute('data-temperature');
            if (unit === '°F') {
                display.textContent = `${(value * 9/5 + 32).toFixed(1)}°F`;
            } else {
                display.textContent = `${value}°C`;
            }
        });
    }

    // Conversion de température
    convertTemperature(value, fromUnit, toUnit) {
        if (fromUnit === toUnit) return value;
        if (fromUnit === '°C' && toUnit === '°F') {
            return (value * 9/5 + 32);
        }
        if (fromUnit === '°F' && toUnit === '°C') {
            return ((value - 32) * 5/9);
        }
        return value;
    }
} 