-- Update all non-confidential Otter records
USE NBNData

SELECT
  TXO.TAXON_OCCURRENCE_KEY,
  ITN.COMMON_NAME,
  TXO.CONFIDENTIAL
-- UPDATE
--   TAXON_OCCURRENCE
-- SET
--   CONFIDENTIAL = 'TRUE'
FROM
  INDEX_TAXON_NAME ITN
INNER JOIN
  TAXON_DETERMINATION TXD ON
  ITN.TAXON_LIST_ITEM_KEY = TXD.TAXON_LIST_ITEM_KEY
INNER JOIN
  TAXON_OCCURRENCE TXO ON
  TXD.TAXON_OCCURRENCE_KEY = TXO.TAXON_OCCURRENCE_KEY
WHERE
  ITN.PREFERRED_NAME = 'Lutra lutra' AND
  TXO.CONFIDENTIAL = 'FALSE';
