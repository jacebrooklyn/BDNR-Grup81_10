// 1. CARREGUEM INDIVIDUS
LOAD CSV WITH HEADERS FROM 'file:///INDIVIDUAL.csv' AS rowI
MERGE (i:Individu {Id: rowI.Id})
ON CREATE SET i.Year = toInteger(rowI.Year), i.name = rowI.name, i.surname = rowI.surname, i.second_surname = rowI.second_surname

// 2. CARREGUEM HABITATGES
LOAD CSV WITH HEADERS FROM 'file:///HABITATGES.csv' AS rowH
MERGE (h:Habitatge {Id_Llar: toInteger(rowH.Id_Llar), Municipi: rowH.Municipi, Any_Padro: toInteger(rowH.Any_Padro)})
ON CREATE SET h.Carrer = rowH.Carrer, h.Numero = rowH.Numero

// 3. CREEM INDEXOS PER A OPTIMITZAR LES CONSULTES
CREATE INDEX FOR (I:Individu) ON (I.Id)
CREATE INDEX FOR (H:Habitatge) ON (H.Id_Llar)

// 4. CARREGUEM RELACIONS ENTRE INDIVIDUS I HABITATGES
LOAD CSV WITH HEADERS FROM 'file:///VIU.csv' AS row
MATCH (individu:Individu {Id: row.IND})
MATCH (habitatge:Habitatge {Year: toInteger(row.Year), Municipi: row.Location, Id_Llar: toInteger(row.HOUSE_ID)})
MERGE (individu)-[:VIU]->(habitatge)

// 5. CARREGUEM RELACIONS FAMILIARS ENTRE INDIVIDUS
LOAD CSV WITH HEADERS FROM 'file:///FAMILIA.csv' AS row
MATCH (ind1:Individu {Id: row.ID_1})
MATCH (ind2:Individu {Id: row.ID_2})
CREATE (ind1)-[:RELACIO {Relacio: row.Relacio, Relacio_Harmonitzada: row.Relacio_Harmonitzada}]->(ind2)

// 6. CARREGUEM RELACIONS ENTRE INDIVIDUS IGUALS EN DIFERENTS ANYS
LOAD CSV WITH HEADERS FROM 'file:///SAME_AS.csv' AS row
MATCH (ind1:Individu {Id: row.Id_A})
MATCH (ind2:Individu {Id: row.Id_B})
CREATE (ind1)-[:SAME_AS]->(ind2)

