USE NBNData
GO
SELECT	TXOD.DATA,
		TXOD.MEASUREMENT_QUALIFIER_KEY,
		ITN.SORT_ORDER,
		ITN.PREFERRED_NAME,
		CASE WHEN ITN.PREFERRED_NAME = ITN2.COMMON_NAME THEN
			TXG.TAXON_GROUP_NAME
		ELSE
			ITN2.COMMON_NAME
		END AS [COMMON NAME],
		TXG.TAXON_GROUP_NAME,
		MIN(SA.VAGUE_DATE_START) AS DATE_FIRST, -- This is where the conversion is required
		MAX(SA.VAGUE_DATE_END) AS DATE_LAST,   -- This is where the conversion is reqired
		COUNT(DISTINCT TXO.TAXON_OCCURRENCE_KEY) AS RECORD_COUNT
FROM TAXON_OCCURRENCE_DATA TXOD
INNER JOIN TAXON_OCCURRENCE TXO ON
	TXOD.TAXON_OCCURRENCE_KEY = TXO.TAXON_OCCURRENCE_KEY
INNER JOIN TAXON_DETERMINATION TXD ON
	TXO.TAXON_OCCURRENCE_KEY = TXD.TAXON_OCCURRENCE_KEY
INNER JOIN INDEX_TAXON_NAME ITN ON
	TXD.TAXON_LIST_ITEM_KEY = ITN.TAXON_LIST_ITEM_KEY
INNER JOIN INDEX_TAXON_NAME ITN2 ON
	ITN.RECOMMENDED_TAXON_LIST_ITEM_KEY = ITN2.TAXON_LIST_ITEM_KEY
INNER JOIN TAXON_LIST_ITEM TLI ON
	ITN.TAXON_LIST_ITEM_KEY = TLI.TAXON_LIST_ITEM_KEY
INNER JOIN TAXON_VERSION TXV ON
	TLI.TAXON_VERSION_KEY = TXV.TAXON_VERSION_KEY
INNER JOIN TAXON_GROUP TXG ON
	TXV.OUTPUT_GROUP_KEY = TXG.TAXON_GROUP_KEY
INNER JOIN SAMPLE SA ON
	TXO.SAMPLE_KEY = SA.SAMPLE_KEY
WHERE TXOD.MEASUREMENT_QUALIFIER_KEY = 'THU00002000000A8'
AND TXOD.DATA = 'Yes'
GROUP BY TXOD.DATA, TXOD.MEASUREMENT_QUALIFIER_KEY, ITN.PREFERRED_NAME, ITN2.COMMON_NAME, ITN.SORT_ORDER, TXG.TAXON_GROUP_NAME
ORDER BY ITN.SORT_ORDER ASC