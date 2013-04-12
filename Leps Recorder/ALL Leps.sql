use nbndata
select *
from
	index_taxon_name itn
inner join
	vw_taxon_group txg on
	itn.taxon_list_item_key = txg.taxon_list_item_key
where
	(txg.taxon_group_name = 'insect - moth' or
	txg.taxon_group_name = 'insect - butterfly')
	