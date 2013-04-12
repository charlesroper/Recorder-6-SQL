/*
Example of taxon expansion. A TLI key for the Red Squirrel is
provided in the WHERE clause. The query involves three joins to the same
table - INDEX_TAXON_NAME. We join on the given TLI (ITN) to the Preferred TLI
(ITN2) then join back via the recommended_taxon_list_item_key (ITN3). The
result is a list of all other taxon_list_items related to the one given. In
this example, we get a list of all Red Squirrel TLIs (see the Other TLI col).
*/

USE NBNData
SELECT
  ITN_1.TAXON_LIST_ITEM_KEY AS [TLI],
  ITN_1.COMMON_NAME         AS [Common],
  ITN_1.PREFERRED_NAME      AS [Latin],

  ITN_2.TAXON_LIST_ITEM_KEY AS [Pref. TLI],
  ITN_2.COMMON_NAME         AS [Pref. Common],
  ITN_2.PREFERRED_NAME      AS [Pref. Latin],

  ITN_3.TAXON_LIST_ITEM_KEY AS [Other TLI],
  ITN_3.COMMON_NAME         AS [Other Common],
  ITN_3.PREFERRED_NAME      AS [Other Latin]

FROM
  INDEX_TAXON_NAME ITN_1
INNER JOIN
  INDEX_TAXON_NAME ITN_2 ON
  ITN_1.RECOMMENDED_TAXON_LIST_ITEM_KEY = ITN_2.TAXON_LIST_ITEM_KEY
INNER JOIN
  INDEX_TAXON_NAME ITN_3 ON
  ITN_2.TAXON_LIST_ITEM_KEY = ITN_3.RECOMMENDED_TAXON_LIST_ITEM_KEY
WHERE
  ITN_1.TAXON_LIST_ITEM_KEY = 'NBNSYS0000136457'