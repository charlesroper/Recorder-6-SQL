use nbndata;

select
	count(txo.taxon_occurrence_key)
from
	vw_taxon_group txg
inner join
	taxon_determination txd on
	txg.taxon_list_item_key = txd.taxon_list_item_key
inner join 
	taxon_occurrence txo on
	txd.taxon_occurrence_key = txo.taxon_occurrence_key
where
	txg.taxon_group_name = 'bird'
and	zero_abundance is not null
and checked is not null
and txd.preferred = 1
