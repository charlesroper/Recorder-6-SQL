select distinct
  itn2.taxon_list_item_key,
  itn2.preferred_name,
  itn2.sort_order,
  itn1.recommended_taxon_list_item_key
from
  index_taxon_name itn1
inner join
  index_taxon_name itn2 on
  itn1.recommended_taxon_list_item_key = itn2.taxon_list_item_key
inner join
  vw_designations d on
  itn2.taxon_list_item_key = d.taxon_list_item_key
where
  status_kind = 'SxRSI'
order by
  itn2.sort_order
go

select distinct
  itn.preferred_name,
  itn.common_name,
  txg.taxon_group_name,
  itn.sort_order
from
  index_taxon_name itn
inner join
  #rsi_list rsi on
  itn.taxon_list_item_key = rsi.taxon_list_item_key
inner join
  vw_taxon_group txg on
  itn.taxon_list_item_key = txg.taxon_list_item_key
order by
  itn.sort_order
go

drop table #rsi_list