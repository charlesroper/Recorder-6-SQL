SELECT
  COUNT(TXO.TAXON_OCCURRENCE_KEY)
FROM
  TAXON_OCCURRENCE AS TXO
  INNER JOIN
  TAXON_DETERMINATION AS TXD ON
  TXO.TAXON_OCCURRENCE_KEY = TXD.TAXON_OCCURRENCE_KEY
  INNER JOIN
  VW_TAXON_GROUP AS TXG ON
  TXD.TAXON_LIST_ITEM_KEY = TXD.TAXON_LIST_ITEM_KEY
WHERE
  TXG.TAXON_GROUP_NAME LIKE '%beetle%' AND
  TXD.PREFERRED = 'False' AND
  TXO.ZERO_ABUNDANCE = 'False' AND
  TXO.CHECKED = 'True' AND
  TXO.CONFIDENTIAL = 'False'