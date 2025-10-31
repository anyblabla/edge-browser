#!/bin/bash

# ==============================================================================
# TITRE: Installation de Microsoft Edge
# AUTEUR: Amaury Libert (Base) | Amélioré par l'IA
# LICENCE: GPLv3
# DESCRIPTION:
#   Installation automatisée du navigateur Edge de Microsoft à partir de son dépôt
#   officiel (stable). Compatible Debian/Ubuntu/Mint.
# ==============================================================================

# --- Configuration et Préparation ---

# Mode strict: Quitte en cas d'erreur (-e), variable non définie (-u), ou échec
# dans un pipe (-o pipefail).
set -euo pipefail

# Couleurs pour une sortie utilisateur claire
VERT='\033[0;32m'
ROUGE='\033[0;31m'
JAUNE='\033[0;33m'
CYAN='\033[0;36m'
FIN='\033[0m'

CLE_KEYRING="/usr/share/keyrings/microsoft-edge.gpg"
FICHIER_SOURCES="/etc/apt/sources.list.d/microsoft-edge.list"
LOGICIEL="microsoft-edge-stable"

# Vérification des droits root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${ROUGE}ERREUR : Ce script doit être exécuté avec 'sudo' ou en tant que root.${FIN}"
    exit 1
fi

echo -e "${CYAN}*** Début de l'installation de Microsoft Edge ***${FIN}"
clear # Effacer l'écran après le message d'introduction

# --- Étape 1: Installation des Dépendances Nécessaires ---

echo -e "${JAUNE}1. Mise à jour des dépôts et installation des prérequis...${FIN}"
# La commande 'apt-transport-https' est souvent implicite maintenant, mais on la garde
# pour une compatibilité maximale. 'gpg' est nécessaire pour la dé-armorisation.
apt update
apt install -y wget apt-transport-https gpg

# --- Étape 2: Importation de la Clé GPG (Méthode Moderne et Sécurisée) ---

echo -e "${JAUNE}2. Importation de la clé publique de Microsoft vers ${CLE_KEYRING}...${FIN}"

# Utilisation de 'curl' (souvent préinstallé ou plus robuste que 'wget')
# et de la commande 'gpg' pour le déchiffrement et l'enregistrement direct.
# Ceci est la méthode recommandée pour les versions modernes de Debian/Ubuntu.
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > "${CLE_KEYRING}"

if [ ! -f "${CLE_KEYRING}" ]; then
    echo -e "${ROUGE}ERREUR : Échec de l'importation de la clé GPG. Abandon.${FIN}"
    exit 1
fi
echo -e "${VERT}Clé GPG importée avec succès.${FIN}"

# --- Étape 3: Ajout du Dépôt Edge ---

echo -e "${JAUNE}3. Ajout du dépôt 'stable' de Microsoft Edge dans ${FICHIER_SOURCES}...${FIN}"

# Utilisation de la syntaxe 'signed-by' pour Debian 11+ / Ubuntu 20.04+ (sécurité).
# La syntaxe [arch=amd64] est conservée pour garantir l'architecture.
echo "deb [arch=amd64 signed-by=${CLE_KEYRING}] https://packages.microsoft.com/repos/edge stable main" > "${FICHIER_SOURCES}"

if [ ! -f "${FICHIER_SOURCES}" ]; then
    echo -e "${ROUGE}ERREUR : Échec de la création du fichier sources.list. Abandon.${FIN}"
    exit 1
fi
echo -e "${VERT}Dépôt Edge ajouté avec succès.${FIN}"

# --- Étape 4: Installation du Navigateur ---

echo -e "${JAUNE}4. Raffraîchissement des dépôts et installation de ${LOGICIEL}...${FIN}"
apt update
apt install -y "${LOGICIEL}"

# --- Étape 5: Finalisation ---

echo -e "${VERT}*** Installation de Microsoft Edge (Stable) terminée ! ***${FIN}"

# Source d'information (Conservé pour référence)
echo ""
echo -e "Source officielle : https://learn.microsoft.com/en-us/windows-server/administration/linux-package-repository-for-microsoft-software"