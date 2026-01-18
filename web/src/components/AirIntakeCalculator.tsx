import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Calculator, AlertCircle } from "lucide-react";

interface CalculationResult {
  section: number;
  isValid: boolean;
  message: string;
  method: string;
}

export default function AirIntakeCalculator() {
  const [power, setPower] = useState<string>("");
  const [method, setMethod] = useState<string>("conduit");
  const [result, setResult] = useState<CalculationResult | null>(null);

  const calculateAirIntake = () => {
    const powerValue = parseFloat(power);
    if (!powerValue || powerValue <= 0) {
      setResult({
        section: 0,
        isValid: false,
        message: "Veuillez entrer une puissance valide",
        method: ""
      });
      return;
    }

    let section: number;
    let message: string;
    let isValid: boolean;

    if (method === "conduit") {
      // Calcul pour amenée par conduit (P5 §9)
      // Section minimale = Puissance × 2 (règle simplifiée)
      section = Math.max(powerValue * 2, 100);
      isValid = section >= 100;
      message = isValid
        ? `Section requise: ${section} cm² (minimum 100 cm²)`
        : "Section insuffisante";
    } else {
      // Calcul pour amenée par ouverture (P11 §11)
      // Section minimale = Puissance × 3 (règle simplifiée)
      section = Math.max(powerValue * 3, 100);
      isValid = section >= 100;
      message = isValid
        ? `Section requise: ${section} cm² (minimum 100 cm²)`
        : "Section insuffisante";
    }

    setResult({
      section,
      isValid,
      message,
      method
    });
  };

  const resetCalculator = () => {
    setPower("");
    setMethod("conduit");
    setResult(null);
  };

  return (
    <div className="space-y-6">
      <div className="space-y-4">
        <div>
          <Label htmlFor="power">Puissance de l'appareil (kW)</Label>
          <Input
            id="power"
            type="number"
            placeholder="Ex: 24"
            value={power}
            onChange={(e) => setPower(e.target.value)}
            className="mt-1"
          />
        </div>

        <div>
          <Label htmlFor="method">Méthode d'amenée d'air</Label>
          <Select value={method} onValueChange={setMethod}>
            <SelectTrigger className="mt-1">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="conduit">Par conduit (P5 §9)</SelectItem>
              <SelectItem value="ouverture">Par ouverture (P11 §11)</SelectItem>
            </SelectContent>
          </Select>
        </div>

        <div className="flex gap-2">
          <Button onClick={calculateAirIntake} className="flex-1">
            <Calculator className="w-4 h-4 mr-2" />
            Calculer
          </Button>
          <Button variant="outline" onClick={resetCalculator}>
            Réinitialiser
          </Button>
        </div>
      </div>

      {result && (
        <Card className={`border-2 ${result.isValid ? 'border-green-500' : 'border-red-500'}`}>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              {result.isValid ? (
                <Badge variant="secondary" className="bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200">
                  Valide
                </Badge>
              ) : (
                <Badge variant="destructive">
                  Invalide
                </Badge>
              )}
              Résultat du calcul
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="text-center">
              <div className="text-3xl font-bold text-blue-600 dark:text-blue-400">
                {result.section} cm²
              </div>
              <p className="text-sm text-foreground/70 mt-1">
                Section minimale requise
              </p>
            </div>

            <div className="bg-muted p-4 rounded-lg">
              <p className="text-sm">{result.message}</p>
            </div>

            <div className="flex items-start gap-3 p-3 bg-yellow-50 dark:bg-yellow-950/20 rounded-lg">
              <AlertCircle className="w-5 h-5 text-yellow-600 dark:text-yellow-400 mt-0.5 flex-shrink-0" />
              <div className="text-sm">
                <p className="font-medium text-yellow-800 dark:text-yellow-200 mb-1">
                  Important
                </p>
                <p className="text-yellow-700 dark:text-yellow-300">
                  Ce calcul est une estimation simplifiée. Consultez un professionnel qualifié
                  pour un calcul précis selon les normes en vigueur.
                </p>
              </div>
            </div>

            <div className="text-xs text-foreground/60 space-y-1">
              <p><strong>Méthode:</strong> {result.method === "conduit" ? "Amenée par conduit" : "Amenée par ouverture"}</p>
              <p><strong>Norme:</strong> {result.method === "conduit" ? "NF DTU 61.1 P5 §9" : "NF DTU 61.1 P11 §11"}</p>
            </div>
          </CardContent>
        </Card>
      )}

      <div className="bg-muted p-4 rounded-lg">
        <h4 className="font-semibold mb-2">Formules de calcul</h4>
        <div className="space-y-2 text-sm">
          <div>
            <strong>Par conduit:</strong> Section ≥ Puissance × 2 cm² (minimum 100 cm²)
          </div>
          <div>
            <strong>Par ouverture:</strong> Section ≥ Puissance × 3 cm² (minimum 100 cm²)
          </div>
        </div>
      </div>
    </div>
  );
}
