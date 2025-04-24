export function applyStyles() {
    const style = document.createElement('style');
    style.textContent = `
        .vmc-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .vmc-title {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 20px;
        }

        .vmc-form {
            display: grid;
            gap: 15px;
        }

        .form-group {
            display: grid;
            gap: 5px;
        }

        .form-group label {
            font-weight: bold;
            color: #34495e;
        }

        .form-group input,
        .form-group select {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
        }

        .verifier-btn {
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
        }

        .verifier-btn:hover {
            background-color: #2980b9;
        }

        .result {
            margin-top: 20px;
            padding: 15px;
            border-radius: 4px;
            font-size: 16px;
        }

        .result.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .result.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    `;
    document.head.appendChild(style);
} 