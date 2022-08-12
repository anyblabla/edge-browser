#!/bin/bash
#
# Autheur:
#   Amaury Libert <amaury-libert@hotmail.com> de Blabla Linux <https://blablalinux.be>
#
# Description:
#   Installation automatisée du navigateur Edge de Microsoft à partir du dépôt tiers de ce dernier. Script valable pour Debian 11,x, Ubuntu 22.04.x, Mint 21.x...
#   Automated installation of Microsoft's Edge browser from its third-party repository. Script valid for Debian 11.x, Ubuntu 22.04.x, Mint 21.x...
#
# Préambule Légal:
# 	Ce script est un logiciel libre.
# 	Vous pouvez le redistribuer et / ou le modifier selon les termes de la licence publique générale GNU telle que publiée par la Free Software Foundation; version 3.
#
# 	Ce script est distribué dans l'espoir qu'il sera utile, mais SANS AUCUNE GARANTIE; sans même la garantie implicite de QUALITÉ MARCHANDE ou d'ADÉQUATION À UN USAGE PARTICULIER.
# 	Voir la licence publique générale GNU pour plus de détails.
#
# 	Licence publique générale GNU : <https://www.gnu.org/licenses/gpl-2.0.txt>
#
echo "Effacement écran..."
clear
#
echo "Raffraichissement dépôts"
apt update
#
echo "Installation paquets requis"
apt install apt-transport-https wget -y
#
echo "Importation clé publique (/usr/share/keyrings/microsoft.gpg)"
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | dd of=/usr/share/keyrings/microsoft.gpg
#
echo "Génération sources.list (/etc/apt/sources.list.d/microsoft-edge.list)"
echo "deb [signed-by=/usr/share/keyrings/microsoft.gpg arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list
#
echo "Raffraichissement dépôts"
apt update
#
echo "Installation Vivaldi"
apt install microsoft-edge-stable -y
#
echo "Source : https://docs.microsoft.com/en-us/windows-server/administration/linux-package-repository-for-microsoft-software"
