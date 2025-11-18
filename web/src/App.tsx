import { useState } from 'react'
import './styles/globals.css'

function App() {
  const [compteur, setCompteur] = useState('')

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    console.log('Valeur du compteur:', compteur)
    // Ici, nous ajouterons la logique pour sauvegarder les données
    alert(`Valeur enregistrée: ${compteur}`)
  }

  return (
    <div className="app-wrapper">
      <header className="app-header">
        <h1>Assistant Entretien Chaudière</h1>
        <p className="app-subtitle">Suivez et gérez l'entretien de votre chaudière</p>
      </header>
      
      <main className="app-main">
        <div className="form-card">
          <div className="form-header">
            <h2>Saisie du compteur</h2>
            <p>Entrez la valeur actuelle de votre compteur de chaudière</p>
          </div>
          
          <form onSubmit={handleSubmit} className="form-content">
            <div className="form-group">
              <label htmlFor="compteur">Valeur du compteur</label>
              <input
                type="number"
                id="compteur"
                value={compteur}
                onChange={(e) => setCompteur(e.target.value)}
                placeholder="Ex: 12345"
                required
                min="0"
                step="1"
              />
            </div>
            <button type="submit" className="btn-primary">
              Enregistrer la valeur
            </button>
          </form>
        </div>
      </main>
      
      <footer className="app-footer">
        <p>&copy; 2023 Assistant d'entretien de chaudière - Tous droits réservés</p>
      </footer>
    </div>
  )
}

export default App
