-- QUERY TO GET ALL SXRSI MARINE MAMMALS AND RSI MEASUREMENT DATA
-- CONTAINS UPDATE CODE

--use nbndata 
--go

--UPDATE TXOD
--SET TXOD.DATA = 'No'
SELECT 
  TXOD.TAXON_OCCURRENCE_KEY,
  ITN.TAXON_LIST_ITEM_KEY,
  VTG.TAXON_GROUP_NAME, 
  ITN.PREFERRED_NAME,
  ITN.COMMON_NAME,
  MQ.SHORT_NAME,
  TXOD.DATA
FROM
  VW_TAXON_GROUP VTG
INNER JOIN
  INDEX_TAXON_NAME ITN ON
  VTG.TAXON_LIST_ITEM_KEY = ITN.TAXON_LIST_ITEM_KEY
INNER JOIN
  TAXON_DETERMINATION TXD ON
  ITN.TAXON_LIST_ITEM_KEY = TXD.TAXON_LIST_ITEM_KEY
INNER JOIN
  TAXON_OCCURRENCE_DATA TXOD ON
  TXD.TAXON_OCCURRENCE_KEY = TXOD.TAXON_OCCURRENCE_KEY
INNER JOIN
  MEASUREMENT_QUALIFIER MQ ON
  TXOD.MEASUREMENT_QUALIFIER_KEY = MQ.MEASUREMENT_QUALIFIER_KEY
--INNER JOIN
--  VW_DESIGNATIONS VD ON
--  ITN.TAXON_LIST_ITEM_KEY = VD.TAXON_LIST_ITEM_KEY
WHERE
  TAXON_GROUP_NAME = 'MARINE MAMMAL' AND
  --VD.[STATUS KIND] = 'SXRSI' AND
  TXOD.MEASUREMENT_QUALIFIER_KEY = 'THU00002000000A8' -- << THIS IS THE RSI KEY
ORDER BY
  TXOD.TAXON_OCCURRENCE_KEY