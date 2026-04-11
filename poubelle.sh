#!/bin/bash

TRASH_DIR="/home/$USER/trash"

## On commence par créer un dossier pour la poubelle s'il n'existe pas déjà
mkdir -p "$TRASH_DIR"

## On demande à l'utilisateur s'il souhaite créer les 10 fichiers de test
read -p "Voulez-vous créer les 10 fichiers de test ? (y/n/q) " create_files

## On boucle tant que la réponse de l'utilisateur n'est pas valide (y/n/q)
while [[ "$create_files" != "y" && "$create_files" != "n" && "$create_files" != "q" ]]; do
    echo "Réponse invalide. Veuillez répondre par 'y', 'n' ou 'q' pour quitter."
    read -p "Voulez-vous créer les 10 fichiers de test ? (y/n/q) " create_files
done

## En fonction de la réponse de l'utilisateur, on crée les fichiers ou on affiche un message
if [[ "$create_files" == "y" ]]; then
    for i in {1..10}; do
        if [ ! -f "fichier$i.txt" ]; then  
            touch "fichier$i.txt"
            echo "fichier$i.txt créé"
        else
            echo "fichier$i.txt existe déjà."
        fi
    done
    echo "Les fichiers de test ont été créés."
elif [[ "$create_files" == "n" ]]; then
    echo "Les fichiers de test n'ont pas été créés."

## On arrête le programme si l'utilisateur souhaite quitter en tapant 'q'
elif [[ "$create_files" == "q" ]]; then
    echo "Programme terminé."
    exit 0
fi

## On demande à l'utilisateur de saisir le nom du ou des fichiers à supprimer (maximum 10 fichiers)
read -p "Entrez le nom du ou des fichiers à supprimer (séparés par des espaces) : " files_to_delete 

## On boucle tant que l'utilisateur n'a pas saisi de nom de fichier
while [[ -z "$files_to_delete" ]]; do 
    echo "Aucun fichier saisi. Veuillez entrer le nom du ou des fichiers à supprimer."
    read -p "Entrez le nom du ou des fichiers à supprimer (séparés par des espaces) : " files_to_delete
done  

## On vérifie que le nombre de fichiers saisis ne dépasse pas 10
files_count=$(echo "$files_to_delete" | wc -w)
while [[ "$files_count" -gt 10 ]]; do
    echo "Vous avez saisi plus de 10 fichiers. Veuillez entrer au maximum 10 fichiers à supprimer."
    read -p "Entrez le nom du ou des fichiers à supprimer (séparés par des espaces) : " files_to_delete
    files_count=$(echo "$files_to_delete" | wc -w)
done

## On demande confirmation à l'utilisateur avant de déplacer les fichiers dans la poubelle
    read -p "Êtes-vous sûr de vouloir supprimer les fichiers '$files_to_delete' ? (y/n) " confirm_delete
    while [[ "$confirm_delete" != "y" && "$confirm_delete" != "n" ]]; do
        echo "Réponse invalide. Veuillez répondre par 'y' ou 'n'."
        read -p "Êtes-vous sûr de vouloir déplacer les fichiers '$files_to_delete' dans la poubelle ? (y/n) " confirm_delete
    done

    if [[ "$confirm_delete" == "n" ]]; then
        echo "Déplacement annulé."
        exit 0
    fi

## On vérifie que les fichiers saisis existent avant de les déplacer dans la poubelle
for file in $files_to_delete; do
    if [ -f "$file" ]; then

## On convertit le fichier en archive tar.gz avant de le déplacer dans la poubelle
## On ajoute la date et l'heure au nom de l'archive pour éviter les problèmes de doublons et de perte de données
        DATE=$(date +%d_%m_%Y_%H_%M)
        ARCHIVE="$TRASH_DIR/${file}_${DATE}.tar.gz"
        tar -czf "$ARCHIVE" "$file"
        echo "Le fichier '$file' a été déplacé dans la poubelle."
    else
        echo "Le fichier '$file' n'existe pas et ne peut pas être déplacé dans la poubelle."
    fi
done

## On affiche un message de confirmation une fois que tous les fichiers ont été traités 
echo "Le processus de déplacement des fichiers dans la poubelle est terminé."

## On demande à l'utilisateur s'il souhaite supprimer les fichiers originaux après les avoir déplacés dans la poubelle
read -p "Voulez-vous supprimer les fichiers originaux après les avoir déplacés dans la poubelle ? (y/n) " delete_originals
while [[ "$delete_originals" != "y" && "$delete_originals" != "n" ]]; do
    echo "Réponse invalide. Veuillez répondre par 'y' ou 'n'."
    read -p "Voulez-vous supprimer les fichiers originaux après les avoir déplacés dans la poubelle ? (y/n) " delete_originals
    done
if [[ "$delete_originals" == "y" ]]; then
    for file in $files_to_delete; do
        if [ -f "$file" ]; then
            rm "$file"
            echo "Le fichier '$file' a été supprimé."
        else
            echo "Le fichier '$file' n'existe pas et ne peut pas être supprimé."
        fi
    done 
fi 
echo "Programme terminé."