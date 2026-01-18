import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";

export default function RegulationSection() {
  return (
    <div className="space-y-6">
      <div className="text-center space-y-4">
        <h2 className="text-3xl font-bold">Réglementation Gaz</h2>
        <p className="text-lg text-foreground/80">
          Normes NF DTU 61.1 P5 §9 et P11 §11
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Section P5 */}
        <Card className="bg-card border-border">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Badge variant="secondary">P5 §9</Badge>
              Amenée d'air par conduit
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div>
              <h4 className="font-semibold mb-2">Règles générales</h4>
              <ul className="list-disc list-inside space-y-1 text-sm text-foreground/80">
                <li>La section minimale du conduit d'amenée d'air est de 100 cm²</li>
                <li>La section peut être réduite à 50 cm² si le conduit est vertical</li>
                <li>La longueur maximale du conduit est de 3 mètres</li>
                <li>Le conduit doit déboucher dans une pièce principale</li>
              </ul>
            </div>

            <div>
              <h4 className="font-semibold mb-2">Calcul de la section</h4>
              <p className="text-sm text-foreground/80">
                La section S (en cm²) doit être au moins égale à :
              </p>
              <div className="bg-muted p-3 rounded-md mt-2">
                <code className="text-sm">S = (Q × 100) / (3600 × v)</code>
              </div>
              <p className="text-xs text-foreground/60 mt-1">
                Où Q = débit en m³/h, v = vitesse de l'air en m/s
              </p>
            </div>
          </CardContent>
        </Card>

        {/* Section P11 */}
        <Card className="bg-card border-border">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Badge variant="secondary">P11 §11</Badge>
              Amenée d'air par ouverture
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div>
              <h4 className="font-semibold mb-2">Ouvertures permanentes</h4>
              <ul className="list-disc list-inside space-y-1 text-sm text-foreground/80">
                <li>Section minimale de 100 cm²</li>
                <li>Ouverture grillagée ou ajourée</li>
                <li>Protection contre les intempéries</li>
                <li>Positionnée en partie basse du local</li>
              </ul>
            </div>

            <div>
              <h4 className="font-semibold mb-2">Ouvertures commandées</h4>
              <ul className="list-disc list-inside space-y-1 text-sm text-foreground/80">
                <li>Section minimale de 150 cm²</li>
                <li>Ouverture automatique en cas de fonctionnement</li>
                <li>Commande électrique ou mécanique</li>
                <li>Signalisation du fonctionnement</li>
              </ul>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Tests Section */}
      <Card className="bg-card border-border">
        <CardHeader>
          <CardTitle>Tests d'étanchéité et mécaniques</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <h4 className="font-semibold mb-2">Test d'étanchéité</h4>
              <ul className="list-disc list-inside space-y-1 text-sm text-foreground/80">
                <li>Pression d'épreuve : 50 mbar</li>
                <li>Durée : 5 minutes minimum</li>
                <li>Perte de pression maximale : 2 mbar</li>
                <li>Test réalisé après montage</li>
              </ul>
            </div>

            <div>
              <h4 className="font-semibold mb-2">Test mécanique</h4>
              <ul className="list-disc list-inside space-y-1 text-sm text-foreground/80">
                <li>Vérification des fixations</li>
                <li>Contrôle des joints d'étanchéité</li>
                <li>Test de fonctionnement des vannes</li>
                <li>Vérification des dispositifs de sécurité</li>
              </ul>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Important Notes */}
      <Card className="bg-yellow-50 dark:bg-yellow-950/20 border-yellow-200 dark:border-yellow-800">
        <CardContent className="pt-6">
          <div className="flex items-start gap-3">
            <div className="w-5 h-5 text-yellow-600 dark:text-yellow-400 mt-0.5">⚠️</div>
            <div>
              <h4 className="font-semibold text-yellow-800 dark:text-yellow-200 mb-2">
                Points importants
              </h4>
              <ul className="list-disc list-inside space-y-1 text-sm text-yellow-700 dark:text-yellow-300">
                <li>Les calculs doivent être vérifiés par un professionnel qualifié</li>
                <li>Les normes peuvent évoluer, consultez toujours la version la plus récente</li>
                <li>Les installations doivent respecter les règles de l'art</li>
                <li>Un certificat de conformité doit être établi</li>
              </ul>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
