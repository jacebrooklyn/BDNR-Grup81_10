use ("tendacomics")

db.createCollection("editorial")
db.editorial.insertOne([
    "id": ObjectId,
    "NomEditorial": "str",
    "responsable": "str",
    "adreça": "str",
    "país": "str"
])

//a lo millor un atribut de les seves col·leccions 
//hi ha una consulta que implica editorial-publicacio: 2. Valor màxim, mínim i mitjà del preus de les publicacions de l’editorial Juniper Books
//però la relacio de editorial-publicacio ve més de editorial-col·leccio-publicació
//llavors podriem ficar en editorial les colleccions o al reves, en les colleccions ficar una d'editorials
//només s'hauria de guardar id i nom de l'editorial

//hi ha una altre consulta: 5. Per cada editorial, mostrar el recompte de col·leccions finalitzades i no finalitzades.
// implica relacio editorial-col·leccio i veure l'atribut tancada.
//tmb consulta 6 relacional editorial-collection. 6. Mostrar les 2 col·leccions ja finalitzades amb més publicacions. mostrar editorial i nom

db.createCollection("colleccio")
db.colleccio.insertOne([
    "id": ObjectId,
    "NomColleccio": "str",
    "total_exemplars": int,
    "gèneres": ["str"],
    "idioma": "str",
    "any_inici": int,
    "any_fi": int,
    "tancada": Boolean //true o false
    //"editorials": [{"id":ObjectId, "nom": "str"},{}]
    ])
    
    
//al igual que abans, caldria un atribut amb editorials que sigui una llista de les editorials id i nom: consulta 2,5 i 6
//4. Numero de col·leccions per gènere. Mostra gènere i número total.

db.createCollection("publicacio")
db.publicacio.insertOne([
    "_id": ObjectId,
    "ISBN": int,
    "títol": "str",
    "stock": int,
    "autor": "str",
    "preu": int, 
    "num_pagines": int,
    ])

//1. Les 5 publicacions amb major preu. Mostrar només el títol i preu.
//9. Modificar el preu de les publicacions de primera edició i incrementar-lo un 25%.

//2. Valor màxim, mínim i mitjà del preus de les publicacions de l’editorial Juniper Books
//6. Mostrar les 2 col·leccions ja finalitzades amb més publicacions. Mostrar editorial i nom col·lecció.
// consulta 2 i 6 implica publi-colleccio-editorial. a la collecio tindriem les editorials amb id i nom

// caldria una relacio amb artistes i personatges:fer dos atributs de artistes:[] i personatges: []
//3. Artistes (nom artístic) que participen en més de 5 publicacions com a dibuixant.
//10. Mostrar ISBN i títol de les publicacions conjuntament amb tota la seva informació dels personatges.

db.createCollection("personatge")
db.personatge.insertOne([
    "_id": ObjectId,
    "nom": "str",
    "tipus": "str",
    "ISBN": int
    ])
//8. Mostrar les publicacions amb tots els personatges de tipus “heroe”.
//10. Mostrar ISBN i títol de les publicacions conjuntament amb tota la seva
//nformació dels personatges.
    
    
db.createCollection("artista")
db.artista.insertOne([
    "_id": ObjectId,
    "nom_artistic": "str",
    "nom": "str",
    "cognoms": "str",
    "data_naix": Date,
    "pais": "str",
    "tipus": "str" //guionista o dibuixant
    ])
    
//3. Artistes (nom artístic) que participen en més de 5 publicacions com a dibuixant.
//7. Mostrar el país d’origen de l’artista o artistes que han fet més guions.