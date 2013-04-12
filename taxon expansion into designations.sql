-- Example of taxon expansion. The query involves two extra joins to the same table -
-- INDEX_TAXON_NAME. We join on the given TLI (ITN) to the Preferred TLI (ITN2) then join back via
-- the recommended_taxon_list_item_key (ITN3).

USE NBNData

SELECT DISTINCT
  -- These are the names of the taxon given in the WHERE clause
  ITN.COMMON_NAME [Common],
  ITN.PREFERRED_NAME [Latin],
  
  -- These are the RECOMMENDED names for the given taxon
  ITN2.TAXON_LIST_ITEM_KEY AS [Pref. TLI],
  ITN2.COMMON_NAME AS [Pref. Common],
  ITN2.PREFERRED_NAME AS [Pref. Latin],
  
  -- These are all of the other names for the given taxon, including recommended and non-recommended
  ITN3.TAXON_LIST_ITEM_KEY AS [Other TLI],
  ITN3.COMMON_NAME AS [Other Common],
  ITN3.PREFERRED_NAME AS [Other Latin]

FROM
  INDEX_TAXON_NAME ITN

INNER JOIN
  INDEX_TAXON_NAME ITN2 ON
  ITN.RECOMMENDED_TAXON_LIST_ITEM_KEY = ITN2.TAXON_LIST_ITEM_KEY

INNER JOIN
  INDEX_TAXON_NAME ITN3 ON
  ITN2.TAXON_LIST_ITEM_KEY = ITN3.RECOMMENDED_TAXON_LIST_ITEM_KEY

WHERE
  ITN.COMMON_NAME = 'Eurasian Red Squirrel'