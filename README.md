# README

## Présentation de BookHive
BookHive est un réseau social innovant dédié aux passionnés de lecture. Conçu pour créer des communautés dynamiques et interactives autour des livres, des auteurs et des librairies, BookHive offre une expérience enrichissante aux lecteurs.

## Pages Principales et Composants

### 1. Homepage
- **TopBar** : Titre et icon vers son profil.
- **Feed** : Flux d'actualités des utilisateurs suivis.
    - ***Description*** : Reprend les posts des utilisateurs suivis. 
    - ***Contenu*** : Chaque post contient une image du livre avec un text ainsi que leurs compteurs de like et de comment.
    - ***Liens*** : 
        - Nom du user
        - Nom du livre
        - Logo commentaire
- **Navbar** : Barre de navigation en bas de la page composee de home, search, scan et bibliotheques.

### 2. Search
- **TopBar** : Titre et icon vers son profil.
- **SearchBar** : Barre de recherche pour les livres et les utilisateurs.
- **SearchResults** : Résultats de la recherche.
    - ***Description*** : Affiche les résultats de la recherche.
    - ***Contenu*** : Chaque résultat contient une image du livre ou du profil avec un texte.
    - ***Liens*** : 
        - Nom du user
        - Nom du livre
- **Navbar** : Barre de navigation en bas de la page composee de home, search, scan et bibliotheques.

### 3. Scan
- **TopBar** : Titre et icon vers son profil.
- **SearchBar** : Barre de recherche pour les livres.
- **Camera** : Scanner de code-barres.
- **ScanResults** : Résultats de la recherche.
    - ***Description*** : Affiche les résultats de la recherche.
    - ***Contenu*** : Chaque résultat contient une image du livre.
    - ***Liens*** : 
        - Nom du livre -> vers update status
- **Navbar** : Barre de navigation en bas de la page composee de home, search, scan et bibliotheques.

### 4. Library
- **TopBar** : Titre et icon vers son profil.
<!-- - **Shelves** : Liste des étagères de la bibliothèque.
    - ***Description*** : Affiche les étagères de la bibliothèque.
    - ***Contenu*** : Chaque étagère contient une liste de livres.
    - ***Liens*** : 
        - Nom du livre -> vers update status -->
- **Books** : Liste des livres de la bibliothèque.
    - ***Description*** : Affiche les livres de la bibliothèque.
    - ***Contenu*** : Chaque livre contient une image et un tracket.
    - ***Liens*** : 
        - logo de tracking -> vers update status
        - image du livre -> vers livre
- **Navbar** : Barre de navigation en bas de la page composee de home, search, scan et bibliotheques.

### 5. Profil Page
- **TopBar** : 'profil', icon vers retour et icon vers params.
- **User** : Informations de l'utilisateur.
    - ***Description*** : Affiche les informations de l'utilisateur.
    - ***Contenu*** : Nom, photo de profil, nombre de followers et de following.
    - ***Liens*** : 
        - Nom du user -> vers profil
- **Button** : Bouton pour suivre ou ne plus suivre l'utilisateur si la page n'est pas vers nous meme
- **Posts** : Liste des posts de l'utilisateur.
    - ***Description*** : Affiche les posts de l'utilisateur.
    - ***Contenu*** : Chaque post contient une image du livre avec un text ainsi que leurs compteurs de like et de comment.
    - ***Liens*** : 
        - Nom du user
        - Nom du livre
        - Logo commentaire
- **Library** : Liste des livres de l'utilisateur.
    - ***Description*** : Affiche les livres de l'utilisateur.
    - ***Contenu*** : Chaque livre contient une image et un tracket.
    - ***Liens*** : 
        - logo de tracking -> vers update status
        - image du livre -> vers livre
- **Navbar** : Barre de navigation en bas de la page composee de home, search, scan et bibliotheques.

### 6. Paramètres de Profil
- **TopBar** : 'paramètres', icon vers retour.
- **Compte** : Permet la modif liee au compte.
    - ***Description*** : Permet de modifier les informations du compte.
    - ***Contenu*** : Nom, email, photo de profil.
- **Notifications** : Permet la modif liee aux notifications.
    - ***Description*** : Permet de modifier les notifications.
    - ***Contenu*** : Notifications activées ou désactivées pour tel ou tel infos.
- **Securite** : Permet la modif liee a la securite.
    - ***Description*** : Permet de modifier les informations de sécurité.
    - ***Contenu*** : Mot de passe, etc.
- **Social** : Gestion des users.
    - ***Description*** : Permet de gerer les followers, following et bloques.
    - ***Contenu*** : followers, following, bloques.


## Fonctionnalités de Suivi
Les utilisateurs peuvent suivre d'autres utilisateurs. Si vous suivez quelqu'un, vous devenez leur follower, et si quelqu'un vous suit, vous êtes leur following.

## Comportement du blocage
Les utilisateurs peuvent bloquer d'autres utilisateurs. Si vous bloquez quelqu'un, vous ne pourrez plus voir leurs posts/livres et ils ne pourront plus voir les vôtres. Egalement, vous ne le verrez plus dans les recherches. Cependant il reste possible de le debloquer. Et de voir le nom et la photo de profil via des amis a la personne bloquee cependant lacces a sa page sera bloque.

## Nouvelle Structure de la Base de Données

### Collection `users`
- **Document `userId`**
  - Champs : `name`, `email`, `profilePicture`, etc.
  - Sous-collection `shelves`
    - **Document `nameShelf`**
      - Champs :
        - `isbn`
          - Champs : `tracker`
  - Sous-collection `followers`
    - **Document `followerUserId`** : Champs vides.
  - Sous-collection `following`
    - **Document `followingUserId`** : Champs vides.
  - Sous-collection `blocked`
    - **Document `blockedUserId`** : Champs vides.

### Collection `books`
- **Document `isbn`**
  - Champs : `title`, `imageUrl`, `isbn`.

### Collection `posts`
- **Document `postId`**
  - Champs : `userId`, `content`, `timestamp`, `bookId` (optionnel), `likesCount`.
  - Sous-collection `likes`
    - **Document `likeUserId`** : Champs vides.
  - Sous-collection `comments`
    - **Document `commentId`**
      - Champs : `userId`, `content`, `timestamp`.

### Collection `errors`
- **Document `errorId`**
  - Champs : `userId`, `page`, `timestamp`, `stack`, `error`.


## Tracking updates

### 0.0.1
- Création du projet
- Création des pages principales
- Création des composants principaux
- Création des routes principales
- Création des actions principales
- Création de la base de données
- Création des collections principales
- Ajout de la page de recherche
- Ajout de la page de scan
- Ajout de la page de bibliothèque
- Ajout de la page de profil
- Ajout de la page actualités
- Ajout de la page de paramètres de depart pour profil, compte, secu et social

### 0.0.2
- Mise en place du multilingue
- Gestion des erreurs ave Sentry

### 0.0.3 (En cours)
1. Mise en place de la verification par email
2. Mise en place des listes des abonnements et des abonnes
3. Définir la politique concernant les utilisateurs bloqués (voir en haut) et l'appliquer
4. Faire la gestion des images profil
5. Lors de la premiere connexion, faire page pour demander le nom et la photo de profil

#### Modifications
Desormais les updates de developpement seront faites dans la branche `vX.X.X` et les push finaux de branches seront mis sur `master`.

### 0.0.4 (A venir)
- Continuer le développement des paramètres de l'utilisateur: notifs, images.
- Developper un outils d'edit pour les images
- Mettre en place des bibliothèques multiples et des listes de souhaits.
- Faire une recherche par auteur

### 0.0.5 (A venir)
- Mise en place de la gestion des messages privés
- Mise en place de la gestion des groupes
- Definir la politique de privacy
- Ajout du principe de privacy
  - Possibilite de mettre des bibliothèques en privé
  - Possibilite de mettre des posts en privé
  - Possibilite de mettre son compte en prive


### 0.0.6 (A venir)
- Refonte du design

### 0.0.?
- Mise en place des communautés
- Mise en place de la gestion des commentaires
- Mise en place de la gestion des posts independant des livres
- Definition de la politique des posts