select
  TaxonList = tl.ITEM_NAME
  ,itn.*
from 
  TAXON_LIST tl
join
  TAXON_LIST_VERSION tlv
  on tl.TAXON_LIST_KEY = tlv.TAXON_LIST_KEY
join
  TAXON_LIST_ITEM tli
  on tlv.TAXON_LIST_VERSION_KEY = tli.TAXON_LIST_VERSION_KEY
join
  INDEX_TAXON_NAME itn
  on tli.TAXON_LIST_ITEM_KEY = itn.TAXON_LIST_ITEM_KEY
where
  tl.ITEM_NAME = 'List of additional names'
order by
  tl.ITEM_NAME

  