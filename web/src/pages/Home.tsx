import { useState } from "react";
import { Home as HomeIcon, FileText, Calculator, CheckCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import RegulationSection from "@/components/RegulationSection";
import AirIntakeCalculator from "@/components/AirIntakeCalculator";

export default function Home() {
  const [activeTab, setActiveTab] = useState("home");

  const tabs = [
    { id: "home", label: "Accueil", icon: HomeIcon },
    { id: "regulation", label: "Réglementation", icon: FileText },
    { id: "calculator", label: "Calcul de l'amenée d'air", icon: Calculator },
    { id: "tests", label: "Tests", icon: CheckCircle },
  ];

  return (
    <div className="min-h-screen bg-background text-foreground">
      {/* Header */}
      <header className="bg-card border-b border-border sticky top-0 z-50">
        <div className="container py-4 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="w-10 h-10 bg-blue-500 rounded-lg flex items-center justify-center">
              <span className="text-white font-bold">GR</span>
            </div>
            <h1 className="text-xl font-bold">Réglementation Gaz</h1>
          </div>
        </div>
      </header>

      {/* Navigation Tabs */}
      <nav className="bg-card border-b border-border sticky top-16 z-40">
        <div className="container flex overflow-x-auto gap-0">
          {tabs.map((tab) => {
            const Icon = tab.icon;
            return (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`flex items-center gap-2 px-4 py-3 border-b-2 transition-colors whitespace-nowrap ${
                  activeTab === tab.id
                    ? "border-blue-500 text-blue-400"
                    : "border-transparent text-foreground/70 hover:text-foreground"
                }`}
              >
                <Icon className="w-4 h-4" />
                {tab.label}
              </button>
            );
          })}
        </div>
      </nav>

      {/* Content */}
      <main className="container py-8">
        {/* Home Tab */}
        {activeTab === "home" && (
          <div className="space-y-8">
            <div className="text-center space-y-4">
              <h2 className="text-4xl font-bold">Bienvenue</h2>
              <p className="text-lg text-foreground/80 max-w-2xl mx-auto">
                Application d'aide à la réglementation gaz selon les normes NF DTU 61.1 P5 et P11
              </p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mt-8">
              <Card
                className="bg-card border-border cursor-pointer hover:border-blue-500 transition-colors"
                onClick={() => setActiveTab("regulation")}
              >
                <CardContent className="pt-6">
                  <FileText className="w-8 h-8 text-blue-400 mb-3" />
                  <h3 className="text-lg font-semibold mb-2">Réglementation</h3>
                  <p className="text-sm text-foreground/70">
                    Consultez les règles de calcul de l'amenée d'air et les tests d'étanchéité
                  </p>
                </CardContent>
              </Card>

              <Card
                className="bg-card border-border cursor-pointer hover:border-blue-500 transition-colors"
                onClick={() => setActiveTab("calculator")}
              >
                <CardContent className="pt-6">
                  <Calculator className="w-8 h-8 text-blue-400 mb-3" />
                  <h3 className="text-lg font-semibold mb-2">Calculateur</h3>
                  <p className="text-sm text-foreground/70">
                    Calculez la surface minimale requise pour l'amenée d'air
                  </p>
                </CardContent>
              </Card>
            </div>

            <div className="bg-card border border-border rounded-lg p-6 mt-8">
              <h3 className="text-lg font-semibold mb-4">À propos de cette application</h3>
              <p className="text-foreground/80 mb-3">
                Cette application vous aide à naviguer les règles de réglementation gaz selon les
                normes françaises NF DTU 61.1 P5 §9 et P11 §11.
              </p>
              <p className="text-foreground/80">
                Vous pouvez consulter les règles détaillées, utiliser le calculateur pour
                déterminer la surface minimale requise pour l'amenée d'air, et accéder aux
                informations sur les tests d'étanchéité et mécaniques.
              </p>
            </div>
          </div>
        )}

        {/* Regulation Tab */}
        {activeTab === "regulation" && <RegulationSection />}

        {/* Calculator Tab */}
        {activeTab === "calculator" && (
          <div className="max-w-2xl">
            <h2 className="text-3xl font-bold mb-6">Calcul de l'amenée d'air</h2>
            <Card className="bg-card border-border">
              <CardContent className="pt-6">
                <AirIntakeCalculator />
              </CardContent>
            </Card>
          </div>
        )}

        {/* Tests Tab */}
        {activeTab === "tests" && (
          <div className="space-y-6">
            <h2 className="text-3xl font-bold">Tests d'étanchéité et tests mécaniques</h2>
            <Card className="bg-card border-border">
              <CardContent className="pt-6 space-y-6">
                {/* Contenu des tests */}
              </CardContent>
            </Card>
          </div>
        )}
      </main>
    </div>
  );
}
