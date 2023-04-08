# BDNR-Grup81_10

Projecte MongoDB

EXERCICI 1:
Per començar, l’objectiu era crear una base de dades on emmagatzemar les publicacions de col·leccions de llibres de diferents editorials d’una tenda de còmics. Això implica la necessitat de tenir com col·leccions l’editorial, la col·lecció, la publicació, l’artista i el personatge. Les mateixes col·leccions que entitats del model E-R. Tanmateix, després ho hem canviat ja que entra també el factor de les consultes. 

Igual que el model E-R cada col·lecció té els mateixos camps que atributs:
-	Editorial: id, nom, responsable, adreça i país. 
-	Col·lecció: id, nomcolleccio, total_exemplars, generes, idioma, any_inici, any_fi i tancada. 
-	Publicació: id, ISBN,títol, stock, autor, preu i num_pagines. 
-	Personatge: id, nom, tipus i ISBN. 
-	Artista: id, nom_artistic, nom, cognoms, data_naix, país 
De tota manera hem necessitat aplicar patrons de dissenys per un millor accés a les dades i flexibilitat. 

La primera modificació va ser afegir l’atribut editorial a col·lecció a causa que hi ha una relació entre les dades. Altrament, en les consultes es demanen els camps col·lecció i editorial alhora. Per exemple, la consulta 5 requereix per cada editorial mostrar el recompte de col·leccions finalitzades i no finalitzades. Llavors vam creure convenient crear un atribut extra a col·lecció que referència a quina editorial pertany. 

A continuació, totes les altres modificacions les vam fer en publicació en ser-hi l’entitat més important. Pel fet que l’objectiu principal és emmagatzemar les publicacions, que aquestes després tenen uns personatges, uns artistes i una col·lecció (que pertany a una editorial). Per això, vam afegir en aquesta col·lecció els atributs per poder guardar la informació o poder accedir als registres editorial, col·lecció, personatge i artista. 

A l’haver-hi molta informació a col·lecció i que en pot tenir més d’una publicació, vam decidir el patró de disseny de referenciar per no duplicar les dades. A més, n’hi ha consultes que només volen la informació de la col·lecció, cosa que si estigues encastada seria més difícil l’accés. Per això hem afegit un atribut de col·lecció on hem guardat l’id de la col·lecció que pertany. 

Així mateix, en la col·lecció artista vam decidir utilitzar la referència. En ser una relació many-to-many preferíem no duplicar la informació o dificultar l’accés a només la informació d’artistes. En canvi de guardar un simple atribut artistes i allà emmagatzemar guionistes i dibuixant, vam seguir el model igual que les dades donades (dades.xlsx) on es divideix en guionistes i dibuixants. 

Al principi, no volíem afegir un atribut editorial a publicació, ja que estava referenciat a col·lecció i ja havíem guardat un atribut de col·lecció. Malgrat això a l’hora de les consultes ens vam trobar amb el problema d’integritat referencial on calia fer un join. Aleshores, per reduir el cost d’una transacció multi-document, vam afegir un atribut nomeditorial per guardar l’editorial que pertany, utilitzant referencia. 

Per últim, vam encastar personatge a publicació. Degut a que personatge era una col·lecció amb pocs atributs, només en té nom, tipus i ISBN. Cosa que llavors no ocupa molt espai o es dupliquen les dades en excés. Addicionalment, les consultes que volen informació sobre els personatges també volen de la publicació. No hi ha el problema de dificultar  l’accés a personatges, perquè en cap moment volem només la seva informació. A l’encastar personatge a publicació llavors no cal crear la col·lecció personatge. 

Al final, amb els patrons de disseny hem demostrat que la col·lecció publicació és la més significant. Pel fet que s’han creat les necessitats de relacionar-la amb totes les altres col·leccions. Cosa que té sentit perquè sabíem des del principi que l’objectiu principal era crear una base de dades per guardar publicacions.  

