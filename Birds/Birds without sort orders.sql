USE NBNData; 
SELECT
  ITN.TAXON_LIST_ITEM_KEY,
  ITN.COMMON_NAME,
  ITN.PREFERRED_NAME,
  ITN.SORT_ORDER,
  TXG.SORT_ORDER AS GROUP_SORT_ORDER,
  TLI.SORT_CODE
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
  ITN.SORT_ORDER IS NULL