use ("tendacomics")

db.createCollection("editorial")
db.editorial.insertOne({
    "id": ObjectId, 
    "NomEditorial": "str",
    "responsable": "str",
    "adreça": "str",
    "país": "str"
})

db.createCollection("colleccio")
db.colleccio.insertOne({
    "id": ObjectId,
    "NomColleccio": "str",
    "total_exemplars": int,
    "gèneres": ["str"],
    "idioma": "str",
    "any_inici": int,
    "any_fi": int,
    "tancada": Boolean //true o false
    //només hi ha una editorial per collecio
    "editorial": ["id": IDeditorial, "nom": "str"] //guardar id i nom editorials
    })

db.createCollection("publicacio")
db.publicacio.insertOne(}
    "_id": ObjectId,
    "ISBN": int,
    "títol": "str",
    "stock": int,
    "autor": "str",
    "preu": int, 
    "num_pagines": int,
    //nomes una editorial per publicacio
    "nomeditorial": "editorial" //referenciar editorial
    //només hi ha una colleccio per publicacio
    "colleccio": "nomcolleccio",  //referenciar colleccion 
    "personatges": [ {"_id": ObjectId, "nom": "str","tipus": "str","ISBN": int}, {} ], 
    //ENCASTAR PERSONATGES A PUBLI
    "guionistes": ["nom_artistic", "nom_artistic"], //referenciar artistes pel nombre artistic
    "dibuixants": ["nom_artistic", "nom_artistic"]
    })

    
db.createCollection("artista")
db.artista.insertOne(}
    "_id": ObjectId,
    "nom_artistic": "str",
    "nom": "str",
    "cognoms": "str",
    "data_naix": Date,
    "pais": "str",
    "tipus": "str" //guionista o dibuixant
    })

//Colleccio personatges no cal crear perque embedded en publicacio
//db.createCollection("personatge")
//db.personatge.insertOne(}
//    "_id": ObjectId,
//    "nom": "str",
//    "tipus": "str",
//    "ISBN": int
//    })

//CONSULTES SOLES:

  //Només colleccio: 
      //4-Numero de col·leccions per gènere. Mostra gènere i número total.
  
  //Només publi:
      //1-Les 5 publicacions amb major preu. Mostrar només el títol i preu.
      //9-Modificar el preu de les publicacions amb stock superior a 20 exemplars i incrementar-lo un 25%.
  
 
     

//CONSULTES RELACIONADES:
    
  //EDITORIAL-PUBLICACIO-COLLECCIO:

      //2-Valor màxim, mínim i mitjà del preus de les publicacions de l’editorial Juniper Books  
      //5-Per cada editorial, mostrar el recompte de col·leccions finalitzades i no finalitzades (editorial-col·leccio)
      //6-Mostrar les 2 col·leccions ja finalitzades amb més publicacions. mostrar editorial i nom 
      // SOLUCIO 2,5,6: 
          //En les colleccions ficar editorials. Només s'hauria de guardar id i nom de l'editorial.
          //En publicacions ficar colleccions referencial 


  //PUBLICACIO-PERSONATGES:
  
      //8-Mostrar les publicacions amb tots els personatges de tipus “heroe”.
      //10-Mostrar ISBN i títol de les publicacions conjuntament amb tota la seva informació dels personatges.
      //SOLUCIO 8,10: 
          //Encastar tota la info dels personatges a publi (eliminar colleccio personatges) 


  //PUBLICACIO-ARTISTA: 
  
      //3-Artistes (nom artístic) que participen en més de 5 publicacions com a dibuixant.
      //7-Mostrar el país d’origen de l’artista o artistes que han fet més guions.
      //SOLUCIO: 
          //guardar nom artistic dels artistes en publi
