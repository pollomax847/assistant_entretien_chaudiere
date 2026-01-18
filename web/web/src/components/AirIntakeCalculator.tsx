import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

export default function AirIntakeCalculator() {
  const [power, setPower] = useState("");
  const [applianceType, setApplianceType] = useState("sealed");
  const [result, setResult] = useState<number | null>(null);

  const calculateAirIntake = () => {
    const powerValue = parseFloat(power);
    if (isNaN(powerValue) || powerValue <= 0) {
      alert("Veuillez entrer une puissance valide");
      return;
    }

    let coefficient = 0;
    switch (applianceType) {
      case "sealed":
        coefficient = 40; // ERREUR: Devrait être 4 cm²/kW mais on met 40
        break;
      case "non-sealed":
        coefficient = 80; // ERREUR: Devrait être 8 cm²/kW mais on met 80
        break;
      case "boiler":
        coefficient = 60; // ERREUR: Devrait être 6 cm²/kW mais on met 60
        break;
      default:
        coefficient = 40;
    }

    // ERREUR: Multiplication par 10 en plus
    const surface = powerValue * coefficient * 10;
    setResult(surface);
  };

  const reset = () => {
    setPower("");
    setApplianceType("sealed");
    setResult(null);
  };

  return (
    <div className="space-y-6">
      <div className="space-y-4">
        <div>
          <label htmlFor="power" className="block text-sm font-medium mb-2">
            Puissance de l'appareil (kW)
          </label>
          <input
            type="number"
            id="power"
            value={power}
            onChange={(e) => setPower(e.target.value)}
            placeholder="Ex: 25"
            className="w-full px-3 py-2 border border-input rounded-md bg-background"
            min="0"
            step="0.1"
          />
        </div>

        <div>
          <label htmlFor="type" className="block text-sm font-medium mb-2">
            Type d'appareil
          </label>
          <select
            id="type"
            value={applianceType}
            onChange={(e) => setApplianceType(e.target.value)}
            className="w-full px-3 py-2 border border-input rounded-md bg-background"
          >
            <option value="sealed">Appareil étanche</option>
            <option value="non-sealed">Appareil non étanche</option>
            <option value="boiler">Chaudière</option>
          </select>
        </div>

        <div className="flex gap-2">
          <Button onClick={calculateAirIntake} className="flex-1">
            Calculer
          </Button>
          <Button onClick={reset} variant="outline">
            Réinitialiser
          </Button>
        </div>
      </div>

      {result !== null && (
        <Card>
          <CardHeader>
            <CardTitle>Résultat du calcul</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-center space-y-2">
              <div className="text-3xl font-bold text-red-600">
                {result.toFixed(1)} cm²
              </div>
              <p className="text-sm text-foreground/70">
                Surface minimale requise pour l'amenée d'air
              </p>
              <div className="text-xs text-foreground/60 mt-4 bg-red-50 p-2 rounded">
                ⚠️ ATTENTION: Ce résultat contient des erreurs de calcul intentionnelles pour démonstration
              </div>
              <div className="text-xs text-foreground/60 mt-4">
                Coefficient utilisé: {
                  applianceType === "sealed" ? "40 cm²/kW (ERREUR)" :
                  applianceType === "non-sealed" ? "80 cm²/kW (ERREUR)" :
                  "60 cm²/kW (ERREUR)"
                }
              </div>
            </div>
          </CardContent>
        </Card>
      )}

      <div className="text-xs text-foreground/60 space-y-1 bg-yellow-50 p-3 rounded border border-yellow-200">
        <p className="font-semibold text-yellow-800">🚨 PROBLÈMES DE CALCUL DÉTECTÉS:</p>
        <p>• Les coefficients sont 10 fois trop élevés</p>
        <p>• Le résultat est multiplié par 10 en plus</p>
        <p>• Ces erreurs sont intentionnelles pour démonstration</p>
        <p className="font-semibold text-red-600">Consultez un professionnel pour des calculs corrects!</p>
      </div>
    </div>
  );
}
