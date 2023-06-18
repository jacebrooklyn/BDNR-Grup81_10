// A - Estudi de les components connexes (cc)

CALL gds.graph.project('apartat_3_a', ['Habitatge', 'Individu'], ['VIU', 'RELATION', 'SAME_AS'])

// Taula agrupant els resultats segons la mida de la cc.

CALL gds.wcc.stream('apartat_3_a')
YIELD nodeId, componentId
RETURN componentId, size(collect(nodeId)) as comp_mida, 
collect(nodeId) as nodes 
order by comp_mida desc;


CALL gds.wcc.stream('apartat_3_a')
YIELD componentId, nodeId
WITH componentId, size(collect(nodeId)) AS mida, collect(nodeId) AS nodes
WHERE componentId = 655
MATCH (n)
WHERE id(n) IN nodes
RETURN n;

// Distribució de tipus de nodes (Individu o Habitatge) segons la mida de la cc.

CALL gds.wcc.stream('apartat_3_a')
YIELD nodeId, componentId
WITH componentId, collect(nodeId) as nodes
UNWIND nodes AS nodeId
MATCH (n) WHERE id(n) = nodeId
RETURN componentId, size(nodes) as comp_mida,
       count(CASE WHEN n:Individu THEN 1 END) as individu_count,
       count(CASE WHEN n:Habitatge THEN 1 END) as habitatge_count
ORDER BY comp_mida DESC;

// Per cada municipi i any el nombre de parelles del tipus: (Individu)—(Habitatge)

CALL gds.wcc.stream('apartat_3_a')
YIELD componentId, nodeId
WITH componentId, size(collect(nodeId)) AS mida, collect(nodeId) AS nodes
MATCH (n:Individu)-[:VIU]->(m:Habitatge{Municipi:"X"}
)
WHERE id(n) IN nodes AND id(m) IN nodes
RETURN m.Municipi AS Municipi, m.Any_Padro AS Any_, count(DISTINCT n) AS Individu, count(DISTINCT m) AS Habitatges, componentId
ORDER BY Individu DESC;

// Quantes components connexes no estan connectades a cap node de tipus ‘Habitatge’.

CALL gds.wcc.stream('apartat_3_a')
YIELD componentId, nodeId
WITH componentId, size(collect(nodeId)) AS mida, collect(nodeId) AS nodes
MATCH (n),(m:Individu)
WHERE id(n) IN nodes AND id(m) IN nodes
WITH componentId, count(DISTINCT n) AS Total, count(DISTINCT m) AS Individus
WHERE Total - Individus = 0
RETURN count(componentId);


// B - Semblança entre els nodes

// 1. Determineu els habitatges que són els mateixos al llarg dels anys. Afegiu una aresta amb nom “MATEIX_HAB“ entre aquests habitatges. Per evitar arestes duplicades feu que la aresta apunti al habitatge amb any de padró més petit.

MATCH (h1:Habitatge), (h2:Habitatge)
WHERE h1.Municipi = h2.Municipi AND h1.Carrer = h2.Carrer AND h1.Numero = h2.Numero AND h1.Any_Padro < h2.Any_Padro
WITH h1, h2,
CASE WHEN h1.Any_Padro > h2.Any_Padro THEN h1 ELSE h2 END AS hab1,
CASE WHEN h1.Any_Padro > h2.Any_Padro THEN h2 ELSE h1 END AS hab2
MERGE (hab1)-[r:MATEIX_HAB]->(hab2)
RETURN hab1.Municipi, hab1.Carrer, hab1.Numero, hab1.Any_Padro, hab2.Municipi, hab2.Carrer, hab2.Numero, hab2.Any_Padro
LIMIT 10;

// 2. Creeu un graf en memòria que inclogui els nodes Individu i Habitatge i les relacions VIU, FAMILIA, MATEIX_HAB que acabeu de crear.
CALL gds.graph.project('graph-ex3-b',
    ['Individu', 'Habitatge'],
    ['VIU', 'RELATION', 'MATEIX_HAB']
    );
