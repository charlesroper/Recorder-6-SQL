SELECT	ITN.SORT_ORDER, 
		ITN.PREFERRED_NAME,
		ITN.COMMON_NAME
FROM INDEX_TAXON_NAME ITN
INNER JOIN TAXON_LIST_ITEM TLI ON 
	ITN.RECOMMENDED_TAXON_LIST_ITEM_KEY = TLI.TAXON_LIST_ITEM_KEY
INNER JOIN TD ON 
	TLI.TAXON_LIST_ITEM_KEY = TD.TAXON_LIST_ITEM_KEY
INNER JOIN TAXON_OCCURRENCE TXO ON 
	TD.TAXON_OCCURRENCE_KEY = TXO.TAXON_OCCURRENCE_KEY
INNER JOIN SAMPLE SA ON 
	TXO.SAMPLE_KEY = SA.SAMPLE_KEY
INNER JOIN TAXON_OCCURRENCE_DATA TXD ON 
	TXO.TAXON_OCCURRENCE_KEY = TXD.TAXON_OCCURRENCE_KEY
INNER JOIN TAXON_VERSION TXV ON 
	TLI.TAXON_VERSION_KEY = TXV.TAXON_VERSION_KEY
INNER JOIN TAXON_GROUP TXG ON 
	TXV.TAXON_VERSION.OUTPUT_GROUP_KEY = TXG.TAXON_GROUP_KEY