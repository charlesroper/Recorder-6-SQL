use nbndata
go

select distinct
	itn_rec.preferred_name
	,itn_rec.common_name
	,itn_rec.sort_order
	,txg.taxon_group_name
from
	index_taxon_name itn_all
inner join
	index_taxon_name itn_rec on
	itn_all.recommended_taxon_list_item_key = itn_rec.taxon_list_item_key
inner join
	vw_taxon_group txg on
	itn_rec.taxon_list_item_key = txg.taxon_list_item_key
where
	txg.taxon_group_name like '%butterfly%'
order by
	itn_rec.sort_order