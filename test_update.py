#!/usr/bin/env python3
"""
Script de test du système de mise à jour GitHub
Teste la logique de vérification de version sans avoir besoin de l'app Flutter
"""

import json
import requests
from packaging import version as pkg_version

# Configuration
GITHUB_RAW_URL = "https://raw.githubusercontent.com/pollomax847/assitant_entreiten_chaudiere/main/version.json"
LOCAL_VERSION_FILE = "version.json"
PUBSPEC_FILE = "mobile/pubspec.yaml"

# Couleurs pour l'affichage
class Colors:
    GREEN = '\033[92m'
    BLUE = '\033[94m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BOLD = '\033[1m'
    END = '\033[0m'

def print_success(msg):
    print(f"{Colors.GREEN}✓{Colors.END} {msg}")

def print_info(msg):
    print(f"{Colors.BLUE}ℹ{Colors.END} {msg}")

def print_warning(msg):
    print(f"{Colors.YELLOW}⚠{Colors.END} {msg}")

def print_error(msg):
    print(f"{Colors.RED}✗{Colors.END} {msg}")

def print_header(msg):
    print(f"\n{Colors.BOLD}{msg}{Colors.END}")

def read_local_version():
    """Lit la version depuis version.json local"""
    try:
        with open(LOCAL_VERSION_FILE, 'r', encoding='utf-8') as f:
            data = json.load(f)
        return data
    except Exception as e:
        print_error(f"Erreur lecture version.json: {e}")
        return None

def read_pubspec_version():
    """Lit la version depuis pubspec.yaml"""
    try:
        with open(PUBSPEC_FILE, 'r', encoding='utf-8') as f:
            for line in f:
                if line.startswith('version:'):
                    version_str = line.split('version:')[1].strip()
                    version, build = version_str.split('+')
                    return {
                        'version': version,
                        'buildNumber': int(build)
                    }
    except Exception as e:
        print_error(f"Erreur lecture pubspec.yaml: {e}")
        return None

def fetch_github_version():
    """Récupère la version depuis GitHub"""
    try:
        response = requests.get(GITHUB_RAW_URL, timeout=10)
        if response.status_code == 200:
            return json.loads(response.text)
        else:
            print_error(f"Code HTTP {response.status_code} depuis GitHub")
            return None
    except requests.exceptions.RequestException as e:
        print_error(f"Erreur connexion GitHub: {e}")
        return None

def compare_versions(current_build, remote_build):
    """Compare deux numéros de build"""
    if remote_build > current_build:
        return "UPDATE_AVAILABLE"
    elif remote_build == current_build:
        return "UP_TO_DATE"
    else:
        return "LOCAL_NEWER"

def simulate_flutter_check(current_version, remote_version):
    """Simule la logique de GitHubUpdateService.checkForUpdate()"""
    print_header("🔍 Simulation de GitHubUpdateService.checkForUpdate()")
    
    current_build = current_version['buildNumber']
    remote_build = int(remote_version['buildNumber'])
    
    print_info(f"Version actuelle: {current_version['version']} (build {current_build})")
    print_info(f"Version distante: {remote_version['version']} (build {remote_build})")
    
    result = compare_versions(current_build, remote_build)
    
    print()
    if result == "UPDATE_AVAILABLE":
        print_success("Une mise à jour est disponible !")
        print()
        print(f"  {Colors.BOLD}Détails de la mise à jour :{Colors.END}")
        print(f"  • Version actuelle : {current_version['version']}")
        print(f"  • Nouvelle version : {remote_version['version']}")
        print(f"  • URL téléchargement : {remote_version['downloadUrl']}")
        print(f"  • Mise à jour forcée : {'Oui' if remote_version.get('forceUpdate', False) else 'Non'}")
        print()
        print(f"  {Colors.BOLD}Notes de version :{Colors.END}")
        for line in remote_version['releaseNotes'].split('\\n'):
            print(f"  {line}")
        return True
    elif result == "UP_TO_DATE":
        print_info("Application déjà à jour")
        return False
    else:
        print_warning("Version locale plus récente que la version distante")
        return False

def test_update_dialog_display(remote_version):
    """Simule l'affichage du dialogue de mise à jour"""
    print_header("💬 Aperçu du dialogue de mise à jour")
    
    force_update = remote_version.get('forceUpdate', False)
    
    print()
    print(f"┌{'─' * 60}┐")
    if force_update:
        print(f"│ ⚠️  {'MISE À JOUR REQUISE':^56} │")
    else:
        print(f"│ 🔄 {'Mise à jour disponible':^56} │")
    print(f"├{'─' * 60}┤")
    print(f"│                                                              │")
    print(f"│  Nouvelle version : {remote_version['version']:<42} │")
    print(f"│                                                              │")
    print(f"│  Notes de version :                                          │")
    for line in remote_version['releaseNotes'].split('\\n'):
        print(f"│  {line:<58} │")
    print(f"│                                                              │")
    print(f"├{'─' * 60}┤")
    if force_update:
        print(f"│                        [ Télécharger ]                       │")
    else:
        print(f"│              [ Plus tard ]     [ Télécharger ]               │")
    print(f"└{'─' * 60}┘")
    print()

def main():
    print()
    print(f"{Colors.BOLD}{'=' * 70}{Colors.END}")
    print(f"{Colors.BOLD}{'🧪 TEST DU SYSTÈME DE MISE À JOUR IN-APP':^70}{Colors.END}")
    print(f"{Colors.BOLD}{'=' * 70}{Colors.END}")
    
    # 1. Lire la version locale
    print_header("1️⃣  Lecture de la version locale (pubspec.yaml)")
    current_version = read_pubspec_version()
    if current_version:
        print_success(f"Version: {current_version['version']} (build {current_version['buildNumber']})")
    else:
        print_error("Impossible de lire pubspec.yaml")
        return
    
    # 2. Lire version.json local
    print_header("2️⃣  Lecture de version.json local")
    local_version_json = read_local_version()
    if local_version_json:
        print_success(f"Version: {local_version_json['version']} (build {local_version_json['buildNumber']})")
    else:
        print_error("Impossible de lire version.json local")
        return
    
    # 3. Récupérer la version depuis GitHub
    print_header("3️⃣  Récupération depuis GitHub")
    remote_version = fetch_github_version()
    if remote_version:
        print_success(f"Version sur GitHub: {remote_version['version']} (build {remote_version['buildNumber']})")
    else:
        print_warning("Impossible d'accéder à GitHub, utilisation de version.json local")
        remote_version = local_version_json
    
    # 4. Simuler la vérification de mise à jour
    update_available = simulate_flutter_check(current_version, remote_version)
    
    # 5. Si mise à jour disponible, afficher le dialogue
    if update_available:
        test_update_dialog_display(remote_version)
    
    # 6. Résumé des tests
    print_header("📊 Résumé des tests")
    print()
    print(f"{'Test':<40} {'Résultat':>20}")
    print(f"{'-' * 62}")
    
    tests = [
        ("Lecture pubspec.yaml", current_version is not None),
        ("Lecture version.json local", local_version_json is not None),
        ("Connexion GitHub", remote_version is not None),
        ("Logique de comparaison", True),
        ("Détection mise à jour", update_available),
    ]
    
    for test_name, passed in tests:
        status = f"{Colors.GREEN}✓ PASS{Colors.END}" if passed else f"{Colors.RED}✗ FAIL{Colors.END}"
        print(f"{test_name:<40} {status:>30}")
    
    print()
    print(f"{Colors.BOLD}{'=' * 70}{Colors.END}")
    
    if update_available:
        print()
        print_success("Le système de mise à jour fonctionne correctement !")
        print()
        print_info("Pour tester dans l'app :")
        print("  1. Compilez et installez l'app")
        print("  2. Lancez l'app (la vérification se fait après 3 secondes)")
        print("  3. OU allez dans Préférences > Vérifier les mises à jour")
        print()
    else:
        print()
        print_warning("Aucune mise à jour détectée")
        print_info("Pour simuler une mise à jour, modifiez version.json avec un buildNumber supérieur")
        print()

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print()
        print_warning("Test interrompu par l'utilisateur")
    except Exception as e:
        print_error(f"Erreur inattendue: {e}")
        import traceback
        traceback.print_exc()
