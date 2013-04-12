use nbndata
go

select distinct
	case when itnp.preferred_name = itnp.common_name then
		''
	else
		itnp.common_name
	end as [Common Name],
	itnp.preferred_name,
	txg.taxon_group_name,
	itnp.sort_order
from
	index_taxon_name itn
inner join
	index_taxon_name itnp on
	itn.recommended_taxon_list_item_key = itnp.taxon_list_item_key
inner join
	vw_taxon_group txg on
	itnp.taxon_list_item_key = txg.taxon_list_item_key
where
	txg.taxon_group_name = 'insect - butterfly' or
	txg.taxon_group_name = 'insect - moth'
order by
	itnp.sort_order