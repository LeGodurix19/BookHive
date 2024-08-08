# README

## Présentation du Projet
Ce projet est une application de gestion de bibliothèque et de communauté de lecteurs, permettant aux utilisateurs de suivre des amis, de gérer leur bibliothèque personnelle, et de participer à des discussions sur des livres.

## Pages Principales et Composants

### 1. AllMessages
Cette page affiche toutes les conversations de l'utilisateur connecté.
#### Composants :
- **MessagePreview**
  - Image de l'utilisateur avec qui la conversation a été entamée.
  - Affichage du dernier message de la conversation.
  - Bouton d'accès à la conversation.

- **MessagePreviewGroup**
  - Image définie par le groupe.
  - Affichage du dernier message de la conversation de groupe.
  - Bouton d'accès à la conversation.

- **MessagePreviewCommunity**
  - Image de la communauté avec qui la conversation a été entamée.
  - Affichage du dernier message de la conversation privée.
  - Bouton d'accès à la conversation.

### 2. BookDetails
Cette page présente les détails d'un livre.
#### Composants :
- **BookDetails**
  - Image du livre.
  - Titre du livre.
  - Auteur du livre.
  - Date de publication du livre.
  - Description du livre (si disponible).
  - Bouton pour ajouter le livre à la bibliothèque.
  - Bouton pour ajouter le livre à la liste de lecture (si disponible).
  - Bouton pour retirer le livre de la bibliothèque (si lecture terminée).
  - Bouton pour ajouter une critique.

### 3. Community
Cette page reprend tout le contenu d'une communauté.
#### Composants :
- **CommunityDetails**
  - Image de la communauté.
  - Nom de la communauté.
  - Description de la communauté.
  - Nombre de membres de la communauté.
  - Bouton pour rejoindre la communauté ou pour quitter la communauté.

- **CommunityPost**
  - Image de l'utilisateur ayant posté.
  - Nom de l'utilisateur ayant posté.
  - Date de publication du post.
  - Contenu du post.
  - Bouton pour ajouter un like.
  - Bouton pour ajouter un commentaire.

- **CommunityReview**
  - Image de l'utilisateur ayant posté.
  - Nom de l'utilisateur ayant posté.
  - Date de publication de la critique.
  - Contenu de la critique.
  - Bouton pour ajouter un like.
  - Bouton pour ajouter un commentaire.

- **CommunityComment**
  - Image de l'utilisateur ayant posté.
  - Nom de l'utilisateur ayant posté.
  - Date de publication du commentaire.
  - Contenu du commentaire.
  - Bouton pour ajouter un like.
  - Champ pour répondre au commentaire.

### 4. CommunityParametres
Cette page permet de gérer les paramètres d'une communauté.
#### Composants :
- **CommunityParametres**
  - Champ pour changer l'image de la communauté.
  - Champ pour changer le nom de la communauté.
  - Champ pour changer la description de la communauté.
  - Champ pour définir si un groupe est public ou privé.
  - Possibilité de supprimer des messages.
  - Bouton pour valider les changements.
  - Bouton pour supprimer la communauté.

### 5. Feed
Cette page reprend les actualités que suit l'utilisateur.
#### Composants :
- **FeedPost**
  - Image de l'utilisateur ayant posté.
  - Nom de l'utilisateur ayant posté.
  - Date de publication du post.
  - Contenu du post.
  - Bouton pour ajouter un like.
  - Bouton pour ajouter un commentaire.

- **FeedReview**
  - Image de l'utilisateur ayant posté.
  - Nom de l'utilisateur ayant posté.
  - Date de publication de la critique.
  - Contenu de la critique.
  - Bouton pour ajouter un like.
  - Bouton pour ajouter un commentaire.

- **FeedComment**
  - Image de l'utilisateur ayant posté.
  - Nom de l'utilisateur ayant posté.
  - Date de publication du commentaire.
  - Contenu du commentaire.
  - Bouton pour ajouter un like.
  - Bouton pour répondre au commentaire.

- **FeedPostComment**
  - Champ de texte pour ajouter un commentaire.
  - Bouton pour ajouter le commentaire.

### 6. Home
- (À définir)

### 7. Library
Cette page affiche tous les livres de l'utilisateur.
#### Composants :
- **LibraryBook**
  - Image du livre.
  - Pastille pour indiquer si le livre est en cours de lecture.
  - Interaction pour afficher un menu avec :
    - Suivi de lecture.
    - Titre du livre.

### 8. Login
- (À définir)

### 9. Messages
Cette page affiche une discussion privée ou de groupe.
#### Composants :
- **Message**
  - Image de l'utilisateur ayant posté.
  - Nom de l'utilisateur ayant posté.
  - Date de publication du message.
  - Contenu du message.
  - Champ d'entrée pour répondre.

### 10. Profil
Cette page affiche les informations de l'utilisateur connecté ainsi qu'un accès aux paramètres.
#### Composants :
- **ProfilDetails**
  - Image de l'utilisateur.
  - Nom de l'utilisateur.
  - Bouton pour ajouter un ami.
  - Bouton pour envoyer un message.

- **ProfilContent**
  - Affichage de tous les posts de l'utilisateur.

### 11. ProfilParametres
Cette page permet de gérer les paramètres du profil.
#### Composants :
- **ProfilParametres**
  - Champ pour changer l'image de l'utilisateur.
  - Champ pour changer le nom de l'utilisateur.
  - Champ pour changer la date de naissance de l'utilisateur.
  - Champ pour changer la description de l'utilisateur.
  - Champ pour changer le mot de passe de l'utilisateur.
  - Bouton pour valider les changements.

### 12. Research
Cette page présente un éventail de suggestions de livres et de communautés.
#### Composants :
- **ResearchBook**
  - Image du livre.
  - Titre du livre.
  - Auteur du livre.

- **ResearchUser**
  - Image de l'utilisateur.
  - Nom de l'utilisateur.

- **ResearchCommunityComment**
  - Image de la communauté.
  - Nom de la communauté.
  - Commentaire.
  - Bouton pour rejoindre la communauté.

### 13. Scan
Cette page permet de scanner des codes-barres de livres pour les ajouter à une liste.
#### Composants :
- **Scan**
  - Champ pour scanner le code-barres.
  - Bouton pour valider le scan.

- **Input String**
  - Champ pour ajouter un livre manuellement avec le titre et/ou l'auteur.
  - Bouton pour valider l'ajout.

## Fonctionnalités de Suivi
Les utilisateurs peuvent suivre d'autres utilisateurs. Si vous suivez quelqu'un, vous devenez leur follower, et si quelqu'un vous suit, vous êtes leur following.

## À Faire
- Détails sur les pages et leurs fonctionnalités.
- Détails sur les composants de chaque page.
- Détails sur les routes de chaque page.
- Détails sur les actions de chaque page.
- Améliorer les recherches de livres et de noms d'utilisateur.
- Améliorer la page des paramètres de profil.
- Améliorer la page de gestion des livres.
- Développer les fonctionnalités de messagerie.
- Créer la page d'actualités.
- Créer la page de communauté.
- Finaliser la page des paramètres de la communauté.

## Urgent
- Configurer le dépôt GitHub pour le push.
- Définir la politique concernant les utilisateurs bloqués.
- Finaliser la gestion des commentaires.
- Élaborer une liste des abonnements et des abonnés.
- Continuer le développement des paramètres de l'utilisateur (incluant les notifications).
- Mettre en place des bibliothèques multiples et des listes de souhaits.

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