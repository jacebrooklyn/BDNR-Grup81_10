// Consulta 1: Del padró de 1866 de Castellví de Rosanes (CR), retorna el número d'habitants i la llista de cognoms, sense eliminar duplicats.
MATCH (individu:Individu)-[:VIU]->(habitatge:Habitatge)
WHERE habitatge.Municipi = 'CR' AND habitatge.Any_Padro = 1866
RETURN COUNT(individu) AS NumeroHabitantes, COLLECT(individu.Surname) AS ListaCognoms;

// Consulta 2: Per a cada padró de Sant Feliu de Llobregat (SFLL), retorna l’any de padró, el número d'habitants, i la llista de cognoms. Elimina duplicats i “nan”.
MATCH (ind:Individu)-[:VIU]->(hab:Habitatge)
WHERE hab.Municipi = 'SFLL' AND NOT ind.Surname = 'nan'
RETURN hab.Any_Padro AS Any_Padro, COUNT(DISTINCT ind) AS Num_Habitants, COLLECT(DISTINCTind.Surname) AS Llista_Cognoms;

// Consulta 3: Dels padrons de Sant Feliu de Llobregat (SFLL) d’entre 1800 i 1845 (no inclosos), retorna la població, l'any del padró i la llista d'identificadors dels habitatges de cada padró. Ordena els resultats per l'any de padró.
MATCH (hab:Habitatge)
WHERE hab.Any_Padro>1800 AND hab.Any_Padro<1845 AND hab.Municipi='SFLL'
RETURN hab.Municipi AS municipi, hab.Any_Padro AS any_padro, COLLECT(DISTINCT hab.Id_Llar)
ORDER BY hab.Any_Padro;

// Consulta 4:  Retorna el nom de les persones que vivien al mateix habitatge que "rafel marti" (no té segon cognom) segons el padró de 1838 de Sant Feliu de Llobregat (SFLL). Retorna la informació en mode graf i mode llista. 
//	Mode graf:
MATCH (i:Individu)-[:VIU]->(h:Habitatge)
WHERE i.Name = 'rafel' AND i.Surname = 'marti' AND h.Municipi = 'SFLL' AND h.Any_Padro = 1838
WITH h
MATCH (i2:Individu)-[:VIU]->(h)
RETURN i2;

//	Mode llista:
MATCH (i:Individu)-[:VIU]->(h:Habitatge)
WHERE i.Name = 'rafel' AND i.Surname = 'marti' AND h.Municipi = 'SFLL' AND h.Any_Padro = 1838
WITH h
MATCH (i2:Individu)-[:VIU]->(h)
RETURN COLLECT(i2.Name) AS persones_vivien;

// Consulta 5: Retorna totes les aparicions de "miguel estape bofill". Fes servir la relació SAME_AS per poder retornar totes les instancies, independentment de si hi ha variacions lèxiques (ex. diferents formes d'escriure el seu nom/cognoms). Mostra la informació en forma de subgraf. 
MATCH (i:Individu)-[:SAME_AS*]-(i2:Individu)
WHERE toLower(i.Name) CONTAINS 'miguel' AND toLower(i.Surname) CONTAINS 'estape' ANDtoLower(i.Second_Surname) CONTAINS 'bofill'
RETURN *;

// Consulta 6: De la consulta anterior, retorna la informació en forma de taula: el nom, la llista de cognoms i la llista de segon cognom (elimina duplicats). 
MATCH (i:Individu)-[:SAME_AS*]-(i2:Individu)
WHERE toLower(i.Name) CONTAINS 'miguel' AND toLower(i.Surname) CONTAINS 'estape' ANDtoLower(i.Second_Surname) CONTAINS 'bofill'
RETURN i2.Name AS Nom, COLLECT(DISTINCT i2.Surname) AS Cognom, COLLECT(DISTINCTi2.Second_Surname) AS Segon_Cognom;

// Consulta 7: Mostra totes les persones relacionades amb "benito julivert". Mostra la informació en forma de taula: el nom, cognom1, cognom2, i tipus de relació. 
MATCH (i:Individu)-[r:RELATION]-(i2:Individu)
WHERE i.Name='benito' AND i.Surname ='julivert'
RETURN i2.Name AS Nom, i2.Surname AS Cognom1, i2.Second_Surname AS Cognom2, r.Relacio AS Tipus_relacio;

// Consulta 8: De la consulta anterior, mostra ara només els fills o filles de "benito julivert". Ordena els resultats alfabèticament per nom. 
MATCH (i:Individu)-[r:RELATION]-(i2:Individu)
WHERE i.Name='benito' AND i.Surname ='julivert' AND (r.Relacio = 'hijo' OR r.Relacio = 'hija')
RETURN i2.Name AS Nom, i2.Surname AS Cognom1, i2.Second_Surname AS Cognom2, r.Relacio AS Tipus_relacio
ORDER BY Nom;

// Consulta 9: Llisteu totes les relacions familiars que hi ha
MATCH (:Individu)-[r:RELATION]->()
WHERE NOT r.Relacio IN ["hijo", "cabeza", "hija", "nieto", "yerno", "hermano", "nuera", "nieta", "madre", "hermana"]
AND r.Relacio<>'null'
AND r.Relacio<>'jefe'
RETURN COLLECT(DISTINCT r.Relacio) AS Tipus_Relacio;

// Consulta 10: Identifiqueu els nodes que representen el mateix habitatge (carrer i numero) al llarg dels padrons de Sant Feliu del Llobregat (SFLL). Seleccioneu només els habitatges que tinguin totes dues informacions (carrer i numero). Per a cada habitatge, retorneu el carrer i número, el nombre total de padrons on apareix, el llistat d’anys dels padrons i el llistat de les Ids de les llars (eviteu duplicats). Ordeneu de més a menys segons el total de padrons i mostreu-ne els 15 primers.
MATCH (h:Habitatge)
WHERE h.Carrer IS NOT NULL AND h.Numero IS NOT NULL AND h.Municipi = "SFLL"
WITH h.Carrer AS Carrer, h.Numero AS Numero, count(DISTINCT h.Any_Padro) AS Num_Padrons, collect(DISTINCT h.Any_Padro) AS Anys_padrons, collect(DISTINCT h.Id_Llar) AS Ids_llars
ORDER BY Num_Padrons DESC
LIMIT 15
RETURN Carrer, Numero, Num_Padrons, Anys_padrons, Ids_llars;

// Consulta 11: Mostreu les famílies de Castellví de Rosanes (MUNICIPI= “CR”) amb més de 3 fills. Mostreu el nom i cognoms del cap de família i el nombre de fills. Ordeneu-les pel nombre de fills fins a un límit de 20, de més a menys. 
MATCH (cap:Individu)-[r:RELATION]->(familia:Individu)
MATCH (familia:Individu)-[r1:RELATION]->(fills:Individu)
MATCH (cap)-[:VIU]->(h:Habitatge)
WHERE h.Municipi = "CR" AND r.Relacio = "cabeza" AND (r1.Relacio = "hijo" OR r1.Relacio = "hija")
WITH cap, COUNT(DISTINCT fills) AS Num_fills
WHERE Num_fills > 3
RETURN cap.Name AS Cap_familia, cap.Surname AS Cognom, SUM(Num_fills) AS Total_fills
ORDER BY Total_fills DESC
LIMIT 20;

// Consulta 12: Mitja de fills a Sant Feliu del Llobregat l’any 1881 per família. Mostreu el total de fills, el nombre d’habitatges i la mitja de fills per habitatge. Fes servir CALL per obtenir el nombre de llars. 
CALL {
MATCH (ind1:Individu)-[r:RELATION]-(ind2:Individu)-[:VIU]->(h1:Habitatge{Municipi:"SFLL"}),(h2:Habitatge{Municipi:"SFLL"})
WHERE h1.Any_Padro = 1881 AND r.Relacio IN ['fill','filla'] AND h2.Any_Padro = 1881
RETURN ind2 AS fills, h2 AS habitatges
}
MATCH (fills),(habitatges)
WITH toFloat(COUNT(DISTINCT habitatges)) AS Nhabs, toFloat(COUNT(DISTINCT fills)) AS Fills
RETURN Fills/Nhabs AS mitjana_fills, Fills, Nhabs;

// Consulta 13: Per cada padró/any de Sant Feliu de Llobregat, mostra el carrer amb menys habitants i el nombre d’habitants en aquell carrer. Fes servir la funció min() i CALL per obtenir el nombre mínim d’habitants. Ordena els resultats per any de forma ascendent.  
MATCH (i:Individu)-[:VIU]->(h:Habitatge)
WHERE h.Municipi="SFLL"
WITH h.Any_Padro AS Any_Padro, h.Carrer AS Carrer, COUNT(i) AS Num_habitants
ORDER BY Any_Padro ASC, Num_habitants ASC
WITH Any_Padro, COLLECT({Carrer: Carrer, Num_habitants: Num_habitants})[0] AS CarrerMinHabitants
CALL {
WITH Any_Padro, CarrerMinHabitants
RETURN CarrerMinHabitants.Carrer AS Carrer, MIN(CarrerMinHabitants.Num_habitants) AS Num_habitants
}
RETURN Any_Padro, CarrerMinHabitants.Carrer AS Carrer, CarrerMinHabitants.Num_habitants AS Num_habitants
ORDER BY Any_Padro ASC;







