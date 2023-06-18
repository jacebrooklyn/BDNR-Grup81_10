
CALL gds.graph.project('apartat_3_a', ['Habitatge', 'Individu'], ['VIU', 'RELATION', 'SAME_AS'])

- Taula agrupant els resultats segons la mida de la cc.

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
RETURN n

- Distribució de tipus de nodes (Individu o Habitatge) segons la mida de la cc.

CALL gds.wcc.stream('apartat_3_a')
YIELD nodeId, componentId
WITH componentId, collect(nodeId) as nodes
UNWIND nodes AS nodeId
MATCH (n) WHERE id(n) = nodeId
RETURN componentId, size(nodes) as comp_mida,
       count(CASE WHEN n:Individu THEN 1 END) as individu_count,
       count(CASE WHEN n:Habitatge THEN 1 END) as habitatge_count
ORDER BY comp_mida DESC;

- Per cada municipi i any el nombre de parelles del tipus: (Individu)—(Habitatge)

CALL gds.wcc.stream('apartat_3_a')
YIELD componentId, nodeId
WITH componentId, size(collect(nodeId)) AS mida, collect(nodeId) AS nodes
MATCH (n:Individu)-[:VIU]->(m:Habitatge{Municipi:"X"}
)
WHERE id(n) IN nodes AND id(m) IN nodes
RETURN m.Municipi AS Municipi, m.Any_Padro AS Any_, count(DISTINCT n) AS Individu, count(DISTINCT m) AS Habitatges, componentId
ORDER BY Individu DESC

- quantes components connexes no estan connectades a cap node de tipus ‘Habitatge’.

CALL gds.wcc.stream('apartat_3_a')
YIELD componentId, nodeId
WITH componentId, size(collect(nodeId)) AS mida, collect(nodeId) AS nodes
MATCH (n),(m:Individu)
WHERE id(n) IN nodes AND id(m) IN nodes
WITH componentId, count(DISTINCT n) AS Total, count(DISTINCT m) AS Individus
WHERE Total - Individus = 0
RETURN count(componentId)
