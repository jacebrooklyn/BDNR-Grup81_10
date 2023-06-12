// 1. CARREGUEM INDIVIDUS
WITH "file:///INDIVIDUAL.csv" AS url1
LOAD CSV WITH HEADERS FROM url1 AS rowI
WITH toInteger(rowI.Id) AS id, toInteger(rowI.Year) AS year, rowI.name AS name, rowI.surname AS surname, rowI.second_surname AS second_surname
MERGE (i:Individu {Id: id})
    SET i.Name = name, i.Surname = surname, i.Second_Surname = second_surname
RETURN COUNT(i)

// 2. CARREGUEM HABITATGES
WITH "file:///HABITATGES.csv" AS url2
LOAD CSV WITH HEADERS FROM url2 AS rowH
WITH toInteger(rowH.Id_Llar) AS idllar, toInteger(rowH.Any_Padro) AS anypadro, rowH.Municipi AS municipi, rowH.Carrer AS carrer, rowH.Numero AS numero
MERGE (h:Habitatge {Id_Llar: idllar, Any_Padro: anypadro, Municipi: municipi})
    SET h.Carrer = carrer, h.Numero = numero
RETURN COUNT(h)

// 3. CARREGUEM RELACIONS ENTRE INDIVIDUS I HABITATGES
WITH "file:///VIU.csv" AS url3
LOAD CSV WITH HEADERS FROM url3 AS rowV
WITH toInteger(rowV.IND) AS ind_ID, toInteger(rowV.HOUSE_ID) AS houseid, rowV.Location AS location, toInteger(rowV.Year) AS year
MATCH (individu:Individu {Id: ind_ID})
MATCH (habitatge:Habitatge {Id_Llar: houseid, Municipi: location, Any_Padro: year})
MERGE (individu)-[rviu:VIU]->(habitatge)
RETURN COUNT(rviu)

// 4. CARREGUEM RELACIONS FAMILIARS ENTRE INDIVIDUS
WITH "file:///FAMILIA.csv" AS url4
LOAD CSV WITH HEADERS FROM url4 AS rowF
WITH toInteger(rowF.ID_1) AS id1, toInteger(rowF.ID_2) AS id2, rowF.Relacio AS relacio, rowF.Relacio_Harmonitzada AS relacio_harmonitzada
MATCH (individu1:Individu {Id: id1})
MATCH (individu2:Individu {Id: id2})
MERGE (individu1)-[rel:RELATION {Relacio: relacio, Relacio_Harmonitzada: relacio_harmonitzada}]->(individu2)
RETURN COUNT(rel)

// 5. CARREGUEM RELACIONS ENTRE INDIVIDUS IGUALS EN DIFERENTS ANYS
WITH "file:///SAME_AS.csv" AS url5
LOAD CSV WITH HEADERS FROM url5 AS rowA
WITH toInteger(rowA.Id_A) AS idA, toInteger(rowA.Id_B) AS idB
MATCH (ind1:Individu {Id: idA})
MATCH (ind2:Individu {Id: idB})
MERGE (ind1)-[ras:SAME_AS]->(ind2)
RETURN COUNT(ras)

// 6. DEFINIM INDEXS PER A MILLORAR LA VELOCITAT DE LES CONSULTES
CREATE INDEX FOR (i:Individu) ON (i.Municipi)
CREATE INDEX FOR (i:Individu) ON (i.Year)
CREATE INDEX FOR (i:Individu) ON (i.Id)
//...

// 7. CREEM CONSTRAINTS PER A MANTENIR L'INTREGITAT DE LES DADES
CREATE CONSTRAINT ON (i:Individu) ASSERT i.Id IS UNIQUE
