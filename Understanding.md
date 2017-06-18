# Compréhension du jeu

Les pièces sont placées aléatoirement sur le jeu

## Game state
Side : à qui le tour ? et quelles pièces capturées pour les deux camps

## Board
L'état du plateau :
[ligne, colonne, type, couleur]

On a un plateau de 8x8 indicée de 0 à 7
Trous en    [2,2]
            [2,5]
            [5,2]
            [5,5]

## Move
Retourner les 4 moves des pièces qui sont sous la forme :
[[ancienneposition],[nouvelleposition]]

# Elaboration des règles

## Règles préétablies :
Qui provoquent une erreur :
* Une pièce ne peut pas sortir du board
* Gestion des pièges et de la capture ok
* Le push est implémenté côté humain


### Todo
* Déplacement possible ?
    * Récupérer tous les voisins **DONE** (mais genre vraiment vraiment)
    * N'est pas entourée d'une composition d'alliés et de bordures (une case adjacente est donc soit libre soit ennemie) **DONE**
    * Il y a une piece ennemie **DONE**
        * Est-elle plus forte ? **DONE**
            * A-t-on un voisin allié ? **DONE**
        * Est-elle bougeable ?  **DONE**
    * La case est donc libre, il peut bouger (si il a assez de step)  **DONE**

* Lister tous les mouvements possibles  **DONE**

* Bons coups à jouer
    * Si on peut gagner (mener un lapin à une position gagnante)
    * Si on peut push/pull la piece ennemie dans un trou
    * Si on peut sauver une piece alliée de se faire pousser dans un trou





###PUSH :
	* 2 Steps :
		- Premier on déplace la pièce ennemie vers une case adjacente
		- Deuxième on avance vers la case d'origine de la pièce ennemie.

	* Peut Push si notre pièce est plus forte que celle de l'adversaire.


###PULL :
	* 2 Steps :
		- Premier on recule d'une case.
		- Deuxième la pièce ennemie est tirée vers notre case d'origine.

	* Peut Pull si notre pièce est plus forte que celle de l'adversaire.



* Elle bouffe tout ce qui se trouve sur sa case d'arrivée
* Aucune contrainte de déplacement
* Du nombre de step par l'IA
* Pas de pousse possible si on a moins

### Done
* Récupérer tous les voisins d'une case
* Récupérer les pièces ennemies ou alliées  
* Récupérer les infos d'une case en fonction de ses coordonnées





Points des moves pour Min/Max :
- 100 points pour faire tomber une pièce ennemie dans un trou
- 80 points pour mettre une pièce ennemie dans un trou même si elle ne tombe pas (ça va la bloquer)
- 50  points pour aller secourir une pièce en danger.
- 50 points pour aller mettre une pièce ennemie en danger.
- 30 points pour aller mettre une pièce ennemie près d'un trou.
- 20 points pour avancer un lapin vers une pièce alliée plus forte.
- 20 points pour avancer notre éléphant à côté d'un trou.
- -1000000 point pour rendre une de nos pièces en danger
 






