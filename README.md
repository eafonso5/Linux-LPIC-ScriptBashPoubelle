# Linux-LPIC-ScriptBashPoubelle
Linux LPIC project - ESGI 3SRCB

## Sujet
### Objectif du projet (à la fin du projet les étudiants sauront réaliser un...)
Créer un script bash qui permet d'avoir l'équivalent d'une poubelle sur un système linux
### Descriptif détaillé
1. Votre script doit être utilisable sur n'importe quelle machine
2. Votre script commencera par créer 10 fichiers : fichier1, fichier2,...fichier10
3. Le script doit recevoir entre 1 et 10 arguments (fichiers différents)
4. Les fichiers passés en arguments seront placés dans une archive dans le répertoire /home/$USER/trash de l'utilisateur. Le fichier s'appellera : archive_DATE.tar.gz
5. Format de la date : jj_mm_aaaa_hh_min
6. Ensuite le script demandera si les fichiers originaux passés en arguments doivent être supprimés.
7. Votre script doit vérifier au maximum toutes les erreurs de saisie (pensez à la fonction usage)

Bon courage.