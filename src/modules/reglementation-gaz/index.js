/**
 * Module de réglementation gaz - Conformité selon l'arrêté du 23 février 2018
 */

// Créer le module dans une variable pour pouvoir l'exporter correctement
const reglementationGazModule = (function() {
    // Détection de l'environnement (Node.js ou navigateur)
    const isNode = typeof window === 'undefined' && typeof global !== 'undefined';
    const globalObj = isNode ? global : window;
    
    // Déclarer le module dans l'espace global si on est dans un navigateur
    if (!isNode && !globalObj.modules) globalObj.modules = {};
    
    const modulePath = '/reglementation-gaz';
    
    // Base de données des questions selon la réglementation du 23 février 2018
    const reglementationQuestions = [
        {
            id: 'q1',
            category: 'Installation',
            question: 'L\'installation comporte-t-elle un dispositif de coupure de gaz facilement accessible?',
            reference: 'Arrêté du 23/02/2018 - Art. 9',
            info: 'Chaque installation de gaz doit comporter un dispositif de coupure manuelle, facilement accessible et bien signalé.',
            critical: true
        },
        {
            id: 'q2',
            category: 'Ventilation',
            question: 'Le local où est installé l\'appareil dispose-t-il d\'une ventilation suffisante?',
            reference: 'Arrêté du 23/02/2018 - Art. 15-16',
            info: 'Les locaux contenant des appareils à gaz doivent disposer d\'une ventilation permanente suffisante.',
            critical: true
        },
        {
            id: 'q3',
            category: 'Évacuation',
            question: 'Le système d\'évacuation des produits de combustion est-il conforme?',
            reference: 'Arrêté du 23/02/2018 - Art. 18-19',
            info: 'Les appareils à gaz doivent être raccordés à un dispositif d\'évacuation des produits de combustion adapté.',
            critical: true
        },
        {
            id: 'q4',
            category: 'Raccordement',
            question: 'Les tuyauteries fixes de l\'installation sont-elles en matériaux autorisés par la réglementation?',
            reference: 'Arrêté du 23/02/2018 - Art. 6',
            info: 'Les tuyauteries fixes doivent être en matériaux adaptés au gaz distribué et à l\'usage prévu.',
            critical: true
        },
        {
            id: 'q5',
            category: 'Étanchéité',
            question: 'L\'installation présente-t-elle une étanchéité satisfaisante?',
            reference: 'Arrêté du 23/02/2018 - Art. 22',
            info: 'L\'installation doit être étanche au gaz sous la pression de contrôle définie par la réglementation.',
            critical: true
        },
        {
            id: 'q6',
            category: 'Chaudière',
            question: 'La chaudière est-elle adaptée à la nature du gaz distribué?',
            reference: 'Arrêté du 23/02/2018 - Art. 11',
            info: 'Les appareils à gaz doivent être adaptés à la nature et à la pression du gaz distribué.',
            critical: true
        },
        {
            id: 'q7',
            category: 'Robinetterie',
            question: 'Chaque appareil est-il équipé d\'un robinet de commande?',
            reference: 'Arrêté du 23/02/2018 - Art. 10',
            info: 'Chaque appareil doit être précédé d\'un robinet de commande individuel facilement accessible.',
            critical: true
        },
        {
            id: 'q8',
            category: 'Sécurité',
            question: 'Les dispositifs de sécurité de la chaudière sont-ils opérationnels?',
            reference: 'Arrêté du 23/02/2018 - Art. 11',
            info: 'Les dispositifs de sécurité des appareils à gaz doivent être maintenus en bon état de fonctionnement.',
            critical: true
        },
        {
            id: 'q9',
            category: 'Maintenance',
            question: 'La date de la dernière maintenance de l\'installation est-elle inférieure à 1 an?',
            reference: 'Arrêté du 23/02/2018 - Art. 25',
            info: 'Les installations de gaz doivent faire l\'objet d\'un entretien annuel obligatoire.',
            critical: false
        },
        {
            id: 'q10',
            category: 'Documentation',
            question: 'Le livret d\'entretien de l\'installation est-il disponible et à jour?',
            reference: 'Arrêté du 23/02/2018 - Art. 26',
            info: 'Un livret d\'entretien doit être établi et mis à jour lors de chaque intervention.',
            critical: false
        }
    ];
    
    // Configuration du module
    const moduleExport = {
        /**
         * État du questionnaire
         */
        state: {
            answers: {},
            currentStep: 0,
            completed: false
        },
        
        /**
         * Réinitialise l'état du questionnaire
         */
        resetState: function() {
            this.state = {
                answers: {},
                currentStep: 0,
                completed: false
            };
        },
        
        /**
         * Génère le HTML pour une question
         */
        renderQuestion: function(question, index) {
            const isActive = index === this.state.currentStep;
            const isCompleted = this.state.answers[question.id] !== undefined;
            const statusClass = isCompleted ? 'completed' : (isActive ? 'active' : '');
            
            return `
                <div class="question-item ${statusClass}" data-question-id="${question.id}" data-step="${index}">
                    <div class="question-header">
                        <span class="question-number">${index + 1}</span>
                        <span class="question-category">${question.category}</span>
                        ${question.critical ? '<span class="critical-tag">Critique</span>' : ''}
                    </div>
                    <div class="question-content">
                        <h3>${question.question}</h3>
                        <div class="question-info">
                            <p>${question.info}</p>
                            <p class="question-reference">${question.reference}</p>
                        </div>
                    </div>
                    <div class="question-actions">
                        <button class="btn-yes" data-answer="yes">Conforme</button>
                        <button class="btn-no" data-answer="no">Non conforme</button>
                        <button class="btn-na" data-answer="na">Non applicable</button>
                    </div>
                    ${isCompleted ? `
                        <div class="answer-display ${this.state.answers[question.id]}">
                            <span>${this.getAnswerLabel(this.state.answers[question.id])}</span>
                            <button class="btn-modify">Modifier</button>
                        </div>
                    ` : ''}
                </div>
            `;
        },
        
        /**
         * Obtient le libellé d'une réponse
         */
        getAnswerLabel: function(answer) {
            switch(answer) {
                case 'yes': return 'Conforme';
                case 'no': return 'Non conforme';
                case 'na': return 'Non applicable';
                default: return '';
            }
        },
        
        /**
         * Enregistre une réponse et passe à la question suivante
         */
        saveAnswer: function(questionId, answer) {
            this.state.answers[questionId] = answer;
            
            // Si on n'est pas à la dernière question, passer à la suivante
            if (this.state.currentStep < reglementationQuestions.length - 1) {
                this.state.currentStep++;
                this.updateQuestionnaireUI();
            } else {
                this.state.completed = true;
                this.showResults();
            }
        },
        
        /**
         * Met à jour l'interface du questionnaire
         */
        updateQuestionnaireUI: function() {
            const questionsContainer = document.getElementById('reglementation-questions');
            questionsContainer.innerHTML = '';
            
            reglementationQuestions.forEach((question, index) => {
                questionsContainer.innerHTML += this.renderQuestion(question, index);
            });
            
            // Faire défiler jusqu'à la question active
            const activeQuestion = questionsContainer.querySelector('.active');
            if (activeQuestion) {
                activeQuestion.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
            
            // Ajouter les gestionnaires d'événements
            this.setupEventListeners();
        },
        
        /**
         * Configure les écouteurs d'événements
         */
        setupEventListeners: function() {
            const questionsContainer = document.getElementById('reglementation-questions');
            
            // Écouteurs pour les boutons de réponse
            questionsContainer.querySelectorAll('.question-actions button').forEach(button => {
                button.addEventListener('click', (event) => {
                    const questionItem = event.target.closest('.question-item');
                    const questionId = questionItem.dataset.questionId;
                    const answer = event.target.dataset.answer;
                    
                    this.saveAnswer(questionId, answer);
                });
            });
            
            // Écouteurs pour les boutons de modification
            questionsContainer.querySelectorAll('.btn-modify').forEach(button => {
                button.addEventListener('click', (event) => {
                    const questionItem = event.target.closest('.question-item');
                    const step = parseInt(questionItem.dataset.step);
                    
                    this.state.currentStep = step;
                    this.updateQuestionnaireUI();
                });
            });
        },
        
        /**
         * Affiche les résultats du questionnaire
         */
        showResults: function() {
            const container = document.getElementById('reglementation-questionnaire');
            
            // Calculer les statistiques
            const stats = this.calculateResults();
            
            // Générer le contenu HTML des résultats
            const resultsHTML = `
                <div class="results-container">
                    <h2>Résultats de l'évaluation</h2>
                    <div class="results-summary ${stats.conformity}">
                        <div class="results-score">
                            <span class="score-value">${stats.conformityScore}%</span>
                            <span class="score-label">Conformité</span>
                        </div>
                        <div class="results-status">
                            <h3>${stats.statusText}</h3>
                            <p>${stats.statusMessage}</p>
                        </div>
                    </div>
                    
                    <div class="results-details">
                        <h3>Détails de l'évaluation</h3>
                        <div class="results-stats">
                            <div class="stat-item">
                                <span class="stat-value">${stats.conformCount}</span>
                                <span class="stat-label">Conformes</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-value">${stats.nonConformCount}</span>
                                <span class="stat-label">Non conformes</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-value">${stats.naCount}</span>
                                <span class="stat-label">Non applicables</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="critical-issues">
                        <h3>Points critiques non conformes</h3>
                        ${stats.criticalIssues.length > 0 ? `
                            <ul class="issues-list">
                                ${stats.criticalIssues.map(issue => `
                                    <li>
                                        <strong>${issue.category}:</strong> ${issue.question}
                                        <span class="issue-reference">${issue.reference}</span>
                                    </li>
                                `).join('')}
                            </ul>
                        ` : '<p>Aucun point critique non conforme détecté.</p>'}
                    </div>
                    
                    <div class="results-actions">
                        <button id="generate-report" class="btn-primary">Générer le rapport</button>
                        <button id="restart-questionnaire" class="btn-secondary">Recommencer</button>
                    </div>
                </div>
            `;
            
            // Ajouter les résultats à la page
            container.innerHTML = resultsHTML;
            
            // Configurer les actions
            document.getElementById('generate-report').addEventListener('click', () => {
                this.generatePDF(stats);
            });
            
            document.getElementById('restart-questionnaire').addEventListener('click', () => {
                this.resetState();
                this.render(document.getElementById('app-container'));
            });
        },
        
        /**
         * Calcule les résultats du questionnaire
         */
        calculateResults: function() {
            let conformCount = 0;
            let nonConformCount = 0;
            let naCount = 0;
            let criticalIssues = [];
            
            reglementationQuestions.forEach(question => {
                const answer = this.state.answers[question.id];
                
                if (answer === 'yes') {
                    conformCount++;
                } else if (answer === 'no') {
                    nonConformCount++;
                    if (question.critical) {
                        criticalIssues.push(question);
                    }
                } else if (answer === 'na') {
                    naCount++;
                }
            });
            
            // Calculer le score de conformité (en excluant les N/A)
            const totalApplicable = conformCount + nonConformCount;
            const conformityScore = totalApplicable > 0 ? Math.round((conformCount / totalApplicable) * 100) : 0;
            
            // Déterminer le statut global
            let conformity, statusText, statusMessage;
            
            if (criticalIssues.length > 0) {
                conformity = 'danger';
                statusText = 'Non conforme - Points critiques';
                statusMessage = 'L\'installation présente des non-conformités sur des points critiques qui doivent être corrigées immédiatement.';
            } else if (conformityScore < 80) {
                conformity = 'warning';
                statusText = 'Partiellement conforme';
                statusMessage = 'L\'installation présente des non-conformités qui doivent être corrigées pour assurer sa sécurité.';
            } else {
                conformity = 'success';
                statusText = 'Conforme';
                statusMessage = 'L\'installation est conforme à la réglementation gaz du 23 février 2018.';
            }
            
            return {
                conformCount,
                nonConformCount,
                naCount,
                conformityScore,
                criticalIssues,
                conformity,
                statusText,
                statusMessage
            };
        },
        
        /**
         * Génère un rapport PDF
         */
        generatePDF: function(stats) {
            alert('Fonctionnalité de génération de PDF en cours de développement.\nLe rapport sera conforme à la réglementation gaz du 23 février 2018.');
            // Cette fonction serait implémentée avec une bibliothèque comme jsPDF
        },
        
        /**
         * Affiche le module dans le conteneur
         * @param {HTMLElement} container Élément conteneur
         * @returns {Promise<void>}
         */
        render: async function(container) {
            // Charger le style du module
            await this.loadStyle();
            
            // Créer la structure de base
            container.innerHTML = `
                <div class="reglementation-gaz-container">
                    <header class="module-header">
                        <h1>Conformité Réglementation Gaz</h1>
                        <p>Vérification selon l'arrêté du 23 février 2018</p>
                    </header>
                    
                    <div class="reglementation-section">
                        <div class="reglementation-date">Arrêté du 23 février 2018</div>
                        <p>Relatif aux règles techniques et de sécurité applicables aux installations de gaz combustible des bâtiments d'habitation.</p>
                        <div class="reglementation-reference">Journal Officiel de la République Française n°0045 du 23 février 2018</div>
                    </div>
                    
                    <div id="reglementation-questionnaire" class="questionnaire-container">
                        <h2>Questionnaire de vérification</h2>
                        <p>Répondez aux questions suivantes pour vérifier la conformité de l'installation.</p>
                        
                        <div id="reglementation-questions" class="questions-container">
                            <!-- Les questions seront générées ici -->
                        </div>
                    </div>
                </div>
            `;
            
            // Initialiser le questionnaire
            this.updateQuestionnaireUI();
        },
        
        /**
         * Charge le style du module
         * @returns {Promise<void>}
         */
        loadStyle: async function() {
            // Ignorer en mode Node.js
            if (isNode) return Promise.resolve();
            
            return new Promise((resolve, reject) => {
                // Vérifier si le style est déjà chargé
                if (document.getElementById('reglementation-gaz-style')) {
                    resolve();
                    return;
                }
                
                // Créer l'élément style
                const style = document.createElement('style');
                style.id = 'reglementation-gaz-style';
                style.textContent = `
                    .reglementation-gaz-container {
                        padding: 20px;
                        max-width: 1200px;
                        margin: 0 auto;
                    }
                    
                    .module-header {
                        text-align: center;
                        margin-bottom: 30px;
                    }
                    
                    .module-header h1 {
                        color: #2c3e50;
                        margin-bottom: 10px;
                    }
                    
                    .questionnaire-container {
                        background-color: #fff;
                        border-radius: 8px;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        padding: 20px;
                        margin-top: 20px;
                    }
                    
                    .questions-container {
                        margin-top: 20px;
                    }
                    
                    .question-item {
                        border: 1px solid #ddd;
                        border-radius: 6px;
                        margin-bottom: 15px;
                        padding: 15px;
                        background-color: #fff;
                        transition: all 0.3s ease;
                    }
                    
                    .question-item.active {
                        border-color: #3498db;
                        box-shadow: 0 0 10px rgba(52, 152, 219, 0.2);
                    }
                    
                    .question-item.completed {
                        border-color: #e0e0e0;
                        background-color: #f9f9f9;
                    }
                    
                    .question-header {
                        display: flex;
                        align-items: center;
                        margin-bottom: 10px;
                    }
                    
                    .question-number {
                        background-color: #3498db;
                        color: white;
                        width: 24px;
                        height: 24px;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-weight: bold;
                        margin-right: 10px;
                    }
                    
                    .question-category {
                        background-color: #f0f0f0;
                        padding: 3px 8px;
                        border-radius: 4px;
                        font-size: 0.8em;
                        color: #555;
                    }
                    
                    .critical-tag {
                        background-color: #e74c3c;
                        color: white;
                        padding: 3px 8px;
                        border-radius: 4px;
                        font-size: 0.8em;
                        margin-left: 10px;
                    }
                    
                    .question-content h3 {
                        margin-top: 0;
                        color: #333;
                        font-size: 1.1em;
                    }
                    
                    .question-info {
                        background-color: #f8f9fa;
                        padding: 10px;
                        border-left: 3px solid #3498db;
                        margin: 10px 0;
                        font-size: 0.9em;
                    }
                    
                    .question-reference {
                        color: #7f8c8d;
                        font-style: italic;
                        font-size: 0.9em;
                        margin-top: 5px;
                    }
                    
                    .question-actions {
                        display: flex;
                        gap: 10px;
                        margin-top: 15px;
                    }
                    
                    .question-actions button {
                        padding: 8px 15px;
                        border: none;
                        border-radius: 4px;
                        cursor: pointer;
                        font-weight: bold;
                        transition: background-color 0.2s;
                    }
                    
                    .btn-yes {
                        background-color: #2ecc71;
                        color: white;
                    }
                    
                    .btn-yes:hover {
                        background-color: #27ae60;
                    }
                    
                    .btn-no {
                        background-color: #e74c3c;
                        color: white;
                    }
                    
                    .btn-no:hover {
                        background-color: #c0392b;
                    }
                    
                    .btn-na {
                        background-color: #7f8c8d;
                        color: white;
                    }
                    
                    .btn-na:hover {
                        background-color: #6c7a7d;
                    }
                    
                    .answer-display {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-top: 15px;
                        padding: 10px;
                        border-radius: 4px;
                        color: white;
                        font-weight: bold;
                    }
                    
                    .answer-display.yes {
                        background-color: #2ecc71;
                    }
                    
                    .answer-display.no {
                        background-color: #e74c3c;
                    }
                    
                    .answer-display.na {
                        background-color: #7f8c8d;
                    }
                    
                    .btn-modify {
                        background-color: rgba(255,255,255,0.3);
                        border: none;
                        padding: 5px 10px;
                        border-radius: 4px;
                        color: white;
                        cursor: pointer;
                    }
                    
                    .btn-modify:hover {
                        background-color: rgba(255,255,255,0.4);
                    }
                    
                    /* Styles pour les résultats */
                    .results-container {
                        padding: 20px;
                    }
                    
                    .results-summary {
                        display: flex;
                        align-items: center;
                        padding: 20px;
                        border-radius: 8px;
                        margin-bottom: 20px;
                        color: white;
                    }
                    
                    .results-summary.success {
                        background-color: #2ecc71;
                    }
                    
                    .results-summary.warning {
                        background-color: #f39c12;
                    }
                    
                    .results-summary.danger {
                        background-color: #e74c3c;
                    }
                    
                    .results-score {
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        margin-right: 30px;
                        padding-right: 30px;
                        border-right: 1px solid rgba(255,255,255,0.3);
                    }
                    
                    .score-value {
                        font-size: 3em;
                        font-weight: bold;
                    }
                    
                    .score-label {
                        font-size: 0.9em;
                        text-transform: uppercase;
                    }
                    
                    .results-status h3 {
                        margin-top: 0;
                        margin-bottom: 10px;
                    }
                    
                    .results-details {
                        background-color: #fff;
                        border-radius: 8px;
                        padding: 20px;
                        margin-bottom: 20px;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                    }
                    
                    .results-stats {
                        display: flex;
                        justify-content: space-around;
                        margin-top: 15px;
                    }
                    
                    .stat-item {
                        text-align: center;
                    }
                    
                    .stat-value {
                        display: block;
                        font-size: 2em;
                        font-weight: bold;
                        color: #2c3e50;
                    }
                    
                    .stat-label {
                        color: #7f8c8d;
                    }
                    
                    .critical-issues {
                        background-color: #fff;
                        border-radius: 8px;
                        padding: 20px;
                        margin-bottom: 20px;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                    }
                    
                    .issues-list li {
                        margin-bottom: 10px;
                        padding: 10px;
                        background-color: #fff9f9;
                        border-left: 3px solid #e74c3c;
                    }
                    
                    .issue-reference {
                        display: block;
                        font-size: 0.85em;
                        color: #7f8c8d;
                        margin-top: 5px;
                    }
                    
                    .results-actions {
                        display: flex;
                        gap: 15px;
                        margin-top: 20px;
                    }
                    
                    .btn-primary {
                        background-color: #3498db;
                        color: white;
                        border: none;
                        padding: 10px 20px;
                        border-radius: 4px;
                        cursor: pointer;
                        font-weight: bold;
                    }
                    
                    .btn-primary:hover {
                        background-color: #2980b9;
                    }
                    
                    .btn-secondary {
                        background-color: #95a5a6;
                        color: white;
                        border: none;
                        padding: 10px 20px;
                        border-radius: 4px;
                        cursor: pointer;
                    }
                    
                    .btn-secondary:hover {
                        background-color: #7f8c8d;
                    }
                    
                    @media (max-width: 768px) {
                        .results-summary {
                            flex-direction: column;
                        }
                        
                        .results-score {
                            margin-right: 0;
                            margin-bottom: 20px;
                            padding-right: 0;
                            border-right: none;
                            border-bottom: 1px solid rgba(255,255,255,0.3);
                            padding-bottom: 20px;
                        }
                        
                        .results-stats {
                            flex-direction: column;
                            gap: 15px;
                        }
                        
                        .results-actions {
                            flex-direction: column;
                        }
                    }
                `;
                
                // Ajouter le style au document
                document.head.appendChild(style);
                resolve();
            });
        }
    };
    
    // Pour la compatibilité navigateur, attacher au global
    if (!isNode) {
        globalObj.modules[modulePath] = moduleExport;
    }
    
    return moduleExport;
})();

// Export ES standard pour utilisation dans des imports ES modules
export default reglementationGazModule;
