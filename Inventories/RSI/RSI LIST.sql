SELECT
    ITN2.SORT_ORDER, 
		ITN2.PREFERRED_NAME,
		CASE WHEN ITN2.PREFERRED_NAME = ITN2.COMMON_NAME THEN
			TXG.TAXON_GROUP_NAME
		ELSE
			ITN2.COMMON_NAME
		END AS [CO_NAME],
		TXG.TAXON_GROUP_NAME,
		COUNT(DISTINCT TXO.TAXON_OCCURRENCE_KEY)
FROM INDEX_TAXON_NAME ITN
INNER JOIN TAXON_LIST_ITEM TLI ON 
	ITN.RECOMMENDED_TAXON_LIST_ITEM_KEY = TLI.TAXON_LIST_ITEM_KEY
INNER JOIN TAXON_DETERMINATION TD ON 
	TLI.TAXON_LIST_ITEM_KEY = TD.TAXON_LIST_ITEM_KEY
INNER JOIN TAXON_OCCURRENCE TXO ON 
	TD.TAXON_OCCURRENCE_KEY = TXO.TAXON_OCCURRENCE_KEY
INNER JOIN SAMPLE SA ON 
	TXO.SAMPLE_KEY = SA.SAMPLE_KEY
INNER JOIN TAXON_OCCURRENCE_DATA TXOD ON 
	TXO.TAXON_OCCURRENCE_KEY = TXOD.TAXON_OCCURRENCE_KEY
INNER JOIN TAXON_VERSION TXV ON 
	TLI.TAXON_VERSION_KEY = TXV.TAXON_VERSION_KEY
INNER JOIN TAXON_GROUP TXG ON 
	TXV.OUTPUT_GROUP_KEY = TXG.TAXON_GROUP_KEY
INNER JOIN INDEX_TAXON_NAME ITN2 ON
	ITN.RECOMMENDED_TAXON_LIST_ITEM_KEY = ITN2.TAXON_LIST_ITEM_KEY
WHERE TXOD.MEASUREMENT_QUALIFIER_KEY = 'THU00002000000A8' 
	AND TXOD.DATA = 'Yes'
GROUP BY ITN2.SORT_ORDER, ITN2.PREFERRED_NAME, ITN2.COMMON_NAME, TXG.TAXON_GROUP_NAME
ORDER BY ITN2.SORT_ORDER ASC

