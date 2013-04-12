-- QUERY TO GET ALL SXRSI MARINE MAMMALS

use nbndata 
go

SELECT 
  ITN.TAXON_LIST_ITEM_KEY,
  VTG.TAXON_GROUP_NAME, 
  ITN.PREFERRED_NAME,
  ITN.COMMON_NAME,
  VD.[STATUS KIND]
FROM 
  VW_TAXON_GROUP VTG
INNER JOIN
  INDEX_TAXON_NAME ITN ON
  VTG.TAXON_LIST_ITEM_KEY = ITN.TAXON_LIST_ITEM_KEY
INNER JOIN
  VW_DESIGNATIONS VD ON
  ITN.TAXON_LIST_ITEM_KEY = VD.TAXON_LIST_ITEM_KEY
WHERE
  TAXON_GROUP_NAME = 'MARINE MAMMAL' AND
  VD.[STATUS KIND] = 'SXRSI'