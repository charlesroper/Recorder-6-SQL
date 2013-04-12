USE NBNData
GO

IF OBJECT_ID('tempdb..#TEMP_COUNT') IS NOT NULL
  DROP TABLE #TEMP_COUNT

SELECT
  COUNT(TXD.TAXON_OCCURRENCE_KEY) [cnt],
  ITN2.TAXON_LIST_ITEM_KEY,
  TXG.TAXON_GROUP_NAME,
  TXG.SORT_ORDER
INTO #TEMP_COUNT
FROM
  INDEX_TAXON_NAME ITN
INNER JOIN
  INDEX_TAXON_NAME ITN2 ON
  ITN.RECOMMENDED_TAXON_LIST_ITEM_KEY = ITN2.TAXON_LIST_ITEM_KEY
INNER JOIN
  TAXON_DETERMINATION TXD ON
  ITN.TAXON_LIST_ITEM_KEY = TXD.TAXON_LIST_ITEM_KEY
INNER JOIN
  TAXON_OCCURRENCE TXO ON
  TXD.TAXON_OCCURRENCE_KEY = TXO.TAXON_OCCURRENCE_KEY
INNER JOIN
  VW_TAXON_GROUP TXG ON
  ITN.TAXON_LIST_ITEM_KEY = TXG.TAXON_LIST_ITEM_KEY
WHERE
  TXD.PREFERRED = 'True' AND
  TXO.CHECKED = 'True' AND
  TXO.CONFIDENTIAL = 'False' AND
  TXO.ZERO_ABUNDANCE = 'False'
GROUP BY
  ITN2.TAXON_LIST_ITEM_KEY,
  TXG.TAXON_GROUP_NAME,
  TXG.SORT_ORDER
GO

SELECT
  tc.TAXON_GROUP_NAME
  ,SUM(cnt) AS [SUM]
  ,tc.SORT_ORDER
FROM
  #TEMP_COUNT as tc
GROUP BY
  tc.TAXON_GROUP_NAME
  ,tc.SORT_ORDER
ORDER BY
  tc.SORT_ORDER DESC

DROP TABLE #TEMP_COUNT
