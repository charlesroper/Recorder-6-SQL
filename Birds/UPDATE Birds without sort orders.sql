USE NBNData; 
UPDATE
  INDEX_TAXON_NAME
SET
  SORT_ORDER = CAST(TXG.SORT_ORDER AS VARCHAR) + 
               REPLICATE('0', 11 - (LEN(TXG.SORT_ORDER) + LEN(TLI.SORT_CODE))) +
               CAST(TLI.SORT_CODE AS VARCHAR)
--SELECT
--  ITN.SORT_ORDER,
--  TXG.SORT_ORDER,
--  TLI.SORT_CODE,
--  CAST(TXG.SORT_ORDER AS VARCHAR) + 
--    REPLICATE('0', 11 - (LEN(TXG.SORT_ORDER) + LEN(TLI.SORT_CODE))) +
--    CAST(TLI.SORT_CODE AS VARCHAR)
--  AS SORT
FROM
  INDEX_TAXON_NAME ITN
INNER JOIN
  TAXON_LIST_ITEM TLI ON
  ITN.TAXON_LIST_ITEM_KEY = TLI.TAXON_LIST_ITEM_KEY
INNER JOIN
  TAXON_VERSION TXV ON
  TLI.TAXON_VERSION_KEY = TXV.TAXON_VERSION_KEY
INNER JOIN
  TAXON_GROUP TXG ON
  TXV.OUTPUT_GROUP_KEY = TXG.TAXON_GROUP_KEY
WHERE
  TXG.TAXON_GROUP_NAME = 'bird'