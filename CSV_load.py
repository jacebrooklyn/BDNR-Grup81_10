import pymongo
import sys
import pandas as pd

# ---------------------------- 1. Creem la base de dades ----------------------------
client = pymongo.MongoClient("mongodb://localhost:27017/")
db = client["TendaComics"]

# ---------------------------- 2. Creem les coleccions ----------------------------
editorial = db["editorial"] # Tindrà per identificador el nom de l'editorial i contindrà info d'aquesta
colleccio = db["colleccio"] # Tindrà per identificador el nom de l'editorial i el de la coleccio i contindrà info de la col·lecció
publicacio = db["publicacio"]   # Tindrà per identificador el ISBN de la publicació i contindrà info de la publicació i l'editrial-col·lecció
artista = db["artista"] # Tindrà per identificador el nom de l'artista i contindrà info d'aquest
personatge = db["personatge"]   # Tindrà per identificador el nom del personatge i contindrà info d'aquest

# ---------------------------- 3. Carreguem les dades ----------------------------
# 3.0 Carreguem les dades dels CSV de cada pàgina 
col_pub = pd.read_excel("Dades.xlsx", sheet_name='Colleccions-Publicacions')
personatges = pd.read_excel("Dades.xlsx", sheet_name='Personatges')
artists = pd.read_excel("Dades.xlsx", sheet_name='Artistes')

# 3.1 Carreguem les dades de les editorials
if db.editorial.count_documents({})==0: # si no hi ha dades a la colecció editorial, les carreguem
    print('\n1. Carregant dades de les editorials...')
    editorial_dict=col_pub[['NomEditorial','resposable','adreca','pais']].to_dict('records') # utilizem format records perque cada fila sigue dict
    db.editorial.insert_many(editorial_dict) # carreguem les dades

    # Comprovem que s'han afegit correctament
    if db.editorial.count_documents({})!=26: print("[1] >> Error: No s'han carregat totes les editorials"); sys.exit()
    else: print("[1] >> Dades carregades correctament")

else: print('[1] >> Dades ja carregades anteriorment')

# 3.2 Carreguem les dades de les coleccions
if db.colleccio.count_documents({})==0: # si no hi ha dades a la colecció colleccio, les carreguem
    print('\n2. Carregant dades de les colleccions...')
    colleccio_dict=col_pub[['NomEditorial','NomColleccio','total_exemplars','genere','any_inici','any_fi','idioma','tancada']].to_dict('records') # utilizem format records perque cada fila sigue dict
    db.colleccio.insert_many(colleccio_dict) # carreguem les dades

    # Comprovem que s'han afegit correctament
    if db.colleccio.count_documents({})!=26: print("[2] >> Error: No s'han carregat totes les col·leccions"); sys.exit()
    else: print("[2] >> Dades carregades correctament")

else: print('[2] >> Dades ja carregades anteriorment')

# 3.3 Carreguem les dades de les publicacions
if db.publicacio.count_documents({})==0: # si no hi ha dades a la colecció publicacio, les carreguem
    print('\n3. Carregant dades de les publicacions...')
    publicacio_dict=col_pub[['ISBN','NomEditorial','NomColleccio','titol','stock','autor','preu','num_pagines']].to_dict('records') # utilizem format records perque cada fila sigue dict
    #afegim els guionistes i dibuixants com a llistes
    g = col_pub['guionistes'].apply(lambda x: x.strip('[]').split(','))
    d = col_pub['dibuixants'].apply(lambda x: x.strip('[]').split(','))
    for i,e in enumerate(publicacio_dict):
        e['guionistes'] = g[i]  # inserim la llista de guionistes
        e['dibuixants'] = d[i]  # inserim la llista de dibuixants
    db.publicacio.insert_many(publicacio_dict) # carreguem les dades

    # Comprovem que s'han afegit correctament
    if db.publicacio.count_documents({})!=26: print("[3] >> Error: No s'han carregat totes les publicacions"); sys.exit()
    else: print("[3] >> Dades carregades correctament")

else: print('[3] >> Dades ja carregades anteriorment')

# 3.4 Carreguem les dades dels personatges
if db.personatge.count_documents({})==0: # si no hi ha dades a la colecció personatge, les carreguem
    print('\n4. Carregant dades dels personatges...')
    personatge_dict=personatges[['nom','tipus']].to_dict('records') # utilizem format records perque cada fila sigue dict
    db.personatge.insert_many(personatge_dict) # carreguem les dades

    # Comprovem que s'han afegit correctament
    if db.personatge.count_documents({})!=77: print("[4] >> Error: No s'han carregat tots els personatges"); sys.exit()
    else: print("[4] >> Dades carregades correctament")

else: print('[4] >> Dades ja carregades anteriorment')

# 3.5 Carreguem les dades dels artistes
if db.artista.count_documents({})==0: # si no hi ha dades a la colecció artista, les carreguem
    print('\n5. Carregant dades dels artistes...')
    artista_dict=artists[['Nom_artistic','nom','cognoms','data_naix','pais']].to_dict('records') # utilizem format records perque cada fila sigue dict
    db.artista.insert_many(artista_dict) # carreguem les dades

    # Comprovem que s'han afegit correctament
    if db.artista.count_documents({})!=7: print("[5] >> Error: No s'han carregat tots els artistes"); sys.exit()
    else: print("[5] >> Dades carregades correctament")

else: print('[5] >> Dades ja carregades anteriorment')

# ---------------------------- 4. Tanquem la connexió ----------------------------
client.close()
