#!/bin/bash

# ============================================================
# Script Poubelle - Archivage de fichiers dans ~/trash
# Usage: ./trash.sh <fichier1> [fichier2 ... fichier10]
# ============================================================

TRASH_DIR="/home/$USER/trash"

usage() {
    echo "Usage: $0 <fichier1> [fichier2 ... fichier10]"
    echo "  Déplace entre 1 et 10 fichiers dans la poubelle (~/$TRASH_DIR)."
    exit 1
}

# --- 1. Vérification du nombre d'arguments ---
if [ "$#" -lt 1 ] || [ "$#" -gt 10 ]; then
    echo "Erreur : vous devez passer entre 1 et 10 arguments."
    usage
fi

# --- 2. Création des 10 fichiers de test ---
echo "Création des fichiers de test..."
for i in $(seq 1 10); do
    if [ ! -f "fichier$i" ]; then
        touch "fichier$i"
        echo "  fichier$i créé"
    else
        echo "  fichier$i existe déjà, ignoré"
    fi
done
echo ""

# --- 3. Vérification des doublons ---
args_uniq=$(printf '%s\n' "$@" | sort -u | wc -l)
if [ "$args_uniq" -ne "$#" ]; then
    echo "Erreur : les arguments contiennent des doublons."
    usage
fi

# --- 4. Vérification que chaque fichier existe ---
for fichier in "$@"; do
    if [ ! -f "$fichier" ]; then
        echo "Erreur : le fichier '$fichier' n'existe pas."
        usage
    fi
done

# --- 5. Création du répertoire trash ---
if ! mkdir -p "$TRASH_DIR"; then
    echo "Erreur : impossible de créer le répertoire $TRASH_DIR."
    exit 1
fi

# --- 6. Archivage ---
DATE=$(date +%d_%m_%Y_%H_%M)
ARCHIVE="$TRASH_DIR/archive_$DATE.tar.gz"

echo "Archivage des fichiers dans : $ARCHIVE"
if ! tar -czf "$ARCHIVE" "$@"; then
    echo "Erreur : l'archivage a échoué."
    exit 1
fi
echo "Archive créée avec succès."
echo ""

# --- 7. Suppression des fichiers originaux ---
read -rp "Voulez-vous supprimer les fichiers originaux ? [o/N] " reponse

case "$reponse" in
    o|O|oui|OUI)
        for fichier in "$@"; do
            rm "$fichier"
            echo "  '$fichier' supprimé."
        done
        echo "Fichiers supprimés."
        ;;
    *)
        echo "Fichiers conservés."
        ;;
esac

exit 0
