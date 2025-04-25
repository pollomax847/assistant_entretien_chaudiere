import { useState } from 'react'

function App() {
  const [compteur, setCompteur] = useState('')

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    // Ici, nous ajouterons la logique pour sauvegarder les données
    console.log('Valeur du compteur:', compteur)
  }

  return (
    <div className="container">
      <h1>Assistant Entretien Chaudière</h1>
      <form onSubmit={handleSubmit} className="form-compteur">
        <div className="form-group">
          <label htmlFor="compteur">Valeur du compteur :</label>
          <input
            type="number"
            id="compteur"
            value={compteur}
            onChange={(e) => setCompteur(e.target.value)}
            placeholder="Entrez la valeur du compteur"
            required
          />
        </div>
        <button type="submit">Enregistrer</button>
      </form>
    </div>
  )
}

export default App 