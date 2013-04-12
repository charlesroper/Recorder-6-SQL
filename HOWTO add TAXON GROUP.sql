-- QUERY TO RETURN THE TAXON GROUP OF A TAXON LIST ITEM.

USE NBNDATA
GO

SELECT 
  TLI.TAXON_LIST_ITEM_KEY,
  TXG.TAXON_GROUP_NAME,
  itn.ACTUAL_NAME
FROM
  TAXON_GROUP TXG
right JOIN
  TAXON_VERSION TXV ON
  TXG.TAXON_GROUP_KEY = TXV.OUTPUT_GROUP_KEY
INNER JOIN
  TAXON_LIST_ITEM TLI ON
  TXV.TAXON_VERSION_KEY = TLI.TAXON_VERSION_KEY
inner join
  INDEX_TAXON_NAME itn on
  TLI.TAXON_LIST_ITEM_KEY = itn.TAXON_LIST_ITEM_KEY
WHERE
  txv.TAXON_VERSION_KEY = 'THU00002001896F7'
  
select * from TAXON_VERSION where TAXON_VERSION_KEY = 'THU00002001896F7'
