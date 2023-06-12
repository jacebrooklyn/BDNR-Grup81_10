// 1. CARREGUEM INDIVIDUS
LOAD CSV WITH HEADERS FROM 'file:///INDIVIDUAL.csv' AS rowI
MERGE (:Individu {
  Id: rowI.Id,
  Year: toInteger(rowI.Year),
  name: rowI.name,
  surname: rowI.surname,
  second_surname: rowI.second_surname
})

// 2. CARREGUEM HABITATGES
LOAD CSV WITH HEADERS FROM 'file:///HABITATGES.csv' AS rowH
MERGE (:Habitatge {
  Municipi: rowH.Municipi,
  Id_Llar: toInteger(rowH.Id_Llar),
  Any_Padro: toInteger(rowH.Any_Padro),
  Carrer: rowH.Carrer,
  Numero: rowH.Numero
})

// 3. CREEM INDEXOS PER A OPTIMITZAR LES CONSULTES
CREATE INDEX IF NOT EXISTS FOR (I:Individu) ON (I.Id)
CREATE INDEX IF NOT EXISTS FOR (H:Habitatge) ON (H.Id_Llar)

// 4. CREEM CONSTRAINTS PER A EVITAR DUPLICATS
CREATE CONSTRAINT IF NOT EXISTS ON (I:Individu) ASSERT I.Id IS UNIQUE
CREATE CONSTRAINT IF NOT EXISTS ON (H:Habitatge) ASSERT H.Id_Llar IS UNIQUE

// 5. CARREGUEM RELACIONS ENTRE INDIVIDUS I HABITATGES
LOAD CSV WITH HEADERS FROM 'file:///VIU.csv' AS row
MATCH (individu:Individu {Id: row.IND})
MATCH (habitatge:Habitatge {Id_Llar: toInteger(row.HOUSE_ID)})
MERGE (individu)-[:VIU {Year: toInteger(row.Year)}]->(habitatge)

// 6. CARREGUEM RELACIONS FAMILIARS ENTRE INDIVIDUS
LOAD CSV WITH HEADERS FROM 'file:///FAMILIA.csv' AS row
MATCH (ind1:Individu {Id: row.ID_1})
MATCH (ind2:Individu {Id: row.ID_2})
MERGE (ind1)-[:RELACIO {Relacio: row.Relacio, Relacio_Harmonitzada: row.Relacio_Harmonitzada}]->(ind2)

// 7. CARREGUEM RELACIONS ENTRE INDIVIDUS IGUALS EN DIFERENTS ANYS
LOAD CSV WITH HEADERS FROM 'file:///SAME_AS.csv' AS row
MATCH (ind1:Individu {Id: row.Id_A})
MATCH (ind2:Individu {Id: row.Id_B})
MERGE (ind1)-[:SAME_AS]->(ind2)

