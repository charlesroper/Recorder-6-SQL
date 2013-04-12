/*
Get BoCC species.
Requires VW_DESIGNATIONS view
Returns list of BoCC designated species
*/

USE NBNData
GO

SELECT DISTINCT
  ITN2.TAXON_LIST_ITEM_KEY,
  ITN2.PREFERRED_NAME AS [PREFERRED NAME],
  ITN2.COMMON_NAME,
  DES.STATUS_KIND,
  DES.SHORT_NAME,
  ITN2.SORT_ORDER
INTO
  #BOCC_TEMP
FROM
  INDEX_TAXON_NAME ITN
INNER JOIN
  INDEX_TAXON_NAME ITN2 ON
  ITN.RECOMMENDED_TAXON_LIST_ITEM_KEY = ITN2.TAXON_LIST_ITEM_KEY
INNER JOIN
  dbo.VW_DESIGNATIONS DES ON -- Join the designations view
  ITN.TAXON_LIST_ITEM_KEY = DES.TAXON_LIST_ITEM_KEY
WHERE
  DES.STATUS_KIND LIKE 'BoCC%' AND
  ITN.RECOMMENDED_TAXON_LIST_ITEM_KEY = ITN2.RECOMMENDED_TAXON_LIST_ITEM_KEY
GO

SELECT * FROM #BOCC_TEMP ORDER BY SORT_ORDER
GO

DROP TABLE #BOCC_TEMP
GO
