.AllMessages:
    Cette page reprend toutes les conversations de l'utilisateur connecté.
    ## Composants:
        - MessagePreview
            - L'image du user avec qui la conversation a ete entamee
            - Reprend le dernier message de la conversation
            - Un bouton pour acceder a la conversation
        - MessagePreviewGroup
            - L'image definie par le groupe
            - Reprend le dernier message de la conversation de groupe
            - Un bouton pour acceder a la conversation
        - MessagePreviewCommunity
            - L'image de la communaute avec qui la conversation a ete entamee
            - Reprend le dernier message de la conversation privee
            - Un bouton pour acceder a la conversation
    
.BookDetails:
    Cette page reprend les détails d'un livre.
    ## Composants:
        V BookDetails
            V L'image du livre
            V Le titre du livre
            V L'auteur du livre
            - La date de publication du livre
            - La description du livre
             si pas le livre
            V Un bouton pour ajouter le livre a la bibliotheque
            V Un bouton pour ajouter le livre a la liste de lecture
             si livre
            - Un bouton pour retirer le livre de la bibliotheque
             si lecture finie
            - Un bouton pour ajouter une review
    
.Community:
    Cette page reprend tout le contenu d'une communaute.
    ## Composants:
        - CommunityDetails
            - L'image de la communaute
            - Le nom de la communaute
            - La description de la communaute
            - Le nombre de membres de la communaute
            - Un bouton pour rejoindre la communaute
             or
            - Un bouton pour quitter la communaute
        - CommunityPost
            - L'image de l'utilisateur ayant poste
            - Le nom de l'utilisateur ayant poste
            - La date de publication du poste
            - Le contenu du poste
            - Un bouton pour ajouter un like
            - Un bouton pour ajouter un commentaire
        - CommunityReview
            - L'image de l'utilisateur ayant poste
            - Le nom de l'utilisateur ayant poste
            - La date de publication de la review
            - Le contenu de la review
            - Un bouton pour ajouter un like
            - Un bouton pour ajouter un commentaire
        - CommunityComment
            - L'image de l'utilisateur ayant poste
            - Le nom de l'utilisateur ayant poste
            - La date de publication du commentaire
            - Le contenu du commentaire
            - Un bouton pour ajouter un like
            - Un input pour repondre au commentaire
    
.CommunityParametres:
    Cette page reprend les parametres de gestion d'une page communaute.
    ## Composants:
        - CommunityParametres
            - Un champ pour changer l'image de la communaute
            - Un champ pour changer le nom de la communaute
            - Un champ pour changer la description de la communaute
            - Un champ pour definir si un groupe est publique ou prive
            - La possibilite de supprimer des messages
            - Un bouton pour valider les changements
            - Un bouton pour supprimer la communaute
    
.Feed:
    Reprend les actu que suis le user.
    ## Composants:
        - FeedPost
            - L'image de l'utilisateur ayant poste
            - Le nom de l'utilisateur ayant poste
            - La date de publication du poste
            - Le contenu du poste
            - Un bouton pour ajouter un like
            - Un bouton pour ajouter un commentaire
        - FeedReview
            - L'image de l'utilisateur ayant poste
            - Le nom de l'utilisateur ayant poste
            - La date de publication de la review
            - Le contenu de la review
            - Un bouton pour ajouter un like
            - Un bouton pour ajouter un commentaire
        - FeedComment
            - L'image de l'utilisateur ayant poste
            - Le nom de l'utilisateur ayant poste
            - La date de publication du commentaire
            - Le contenu du commentaire
            - Un bouton pour ajouter un like
            - Un bouton pour repondre au commentaire
        - FeedPostComment
            - Un champ de texte pour ajouter un commentaire
            - Un bouton pour ajouter le commentaire
    
.Home:
    -
    
.Library:
    Reprend tous les livres de l'utilisateur.
    ## Composants:
        V LibraryBook
            V L'image du livre
            - Un pastille pour indiquer si le livre est en cours de lecture
            - Un touch qui fait apparaitre un menu:
                - Le tracking de lecture
                - Le titre du livre
    
.Login:
    -
    
.Messages:
    Reprend une discussion privee ou de groupe
    ## Composants:
        - Message
            - L'image de l'utilisateur ayant poste
            - Le nom de l'utilisateur ayant poste
            - La date de publication du message
            - Le contenu du message
        - input pour repondre
        
    
.Profil:
    Reprend les informations de l'utilisateur connecté ainsi qu'un acces aux parametres.
    ## Composants:
        V ProfilDetails
            V L'image de l'utilisateur
            V Le nom de l'utilisateur
            V Un bouton pour ajouter un ami
            - Un bouton pour envoyer un message
        - ProfilContent reprend tous les posts
    
.ProfilParametres:
    Reprend les parametres de gestion du profil.
    ## Composants:
        - ProfilParametres
            - Un champ pour changer l'image de l'utilisateur
            - Un champ pour changer le nom de l'utilisateur
            - Un champ pour changer la date de naissance de l'utilisateur
            - Un champ pour changer la description de l'utilisateur
            - Un champ pour changer le mot de passe de l'utilisateur
            - Un bouton pour valider les changements
    
.Research:
    Reprend un eventail de suggestions de livres et de communautes
    ## Composants:
        V ResearchBook
            V L'image du livre
            V Le titre du livre
            V L'auteur du livre
        V ResearchUser
            V L'image du user
            V Le nom du user
        - ResearchCommunityComment
            - L'image de la communaute
            - Le nom de la communaute
            - Le comment
            - Un bouton pour rejoindre la communaute
        
.Scan:
    Scanne les codes barres des livres pour les ajouter a une liste.
    ## Composants:
        V Scan
            V Un champ pour scanner le code barre
            V Un bouton pour valider le scan
        V Input string:
            V Un champ pour ajouter un livre manuellement avec le titre et/ou l'auteur
            V Un bouton pour valider l'ajout

Un user peut decider de follow un autre user.
si on suit quelqu'un on est son followers
si on est suiviv par quelqu'un on est son following

To Do:
    Detailler les pages et leur fonctionnalites.
    Detailler les composants de chaque page.
    Detailler les routes de chaque page.
    Detailler les actions de chaque page.

    
To do:
    Ameliorer les recherches de livres et de usernames
    Ameliorer la page de parametres de profils
    Ameliorer la page de livres
    
    Faire les messages
    Faire la page d'actualites
    Faire la page de communaute
    Faire la page de parametres de communaute


    En urgence

    - Mettre en place pour push sur github
    
    - Decider de la politique des gens bloques

    - Faire les commentaires
    - Faire la liste des abonnements et des abonnes
    - Continuer la page parametres de l'utilisateur
        - Faire les notifs
    - Mettre en place les mutliples bibliothèques & wishlist





Nouvelle Structure de la Base de Données
    Collection users :

    Document userId :
        Champs : name, email, profilePicture, etc.
        Sous-collection shelves :
            Document nameShelf :
                Champs :
                    isbn :
                        Champs : 
                            tracker
        Sous-collection followers :
            Document followerUserId : Champs vides (la clé primaire est suffisante)
        Sous-collection following :
            Document followingUserId : Champs vides (la clé primaire est suffisante)
        Sous-collection blocked :
            Document blockedUserId : Champs vides (la clé primaire est suffisante)

    Collection books :

        Document isbn :
            Champs : title, imageUrl, isbn

    Collection posts :

        Document postId :
            Champs : userId (référence à l'auteur du post), content, timestamp, bookId (optionnel, référence à un livre), likesCount (nombre total de likes)
            Sous-collection likes :
        
                Document likeUserId : Champs vides (la clé primaire est suffisante, indiquant que cet utilisateur a aimé le post)
        
            Sous-collection comments :
                Document commentId :
                    Champs : userId (référence à l'auteur du commentaire), content, timestamp