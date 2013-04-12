use nbndata;
select
	txd.taxon_list_item_key
	,dbo.LCReturnTetrad(
		replace(sa.spatial_ref, ' ', ''), sa.spatial_ref_system) as tetrad
from
	sample sa
inner join 
	taxon_occurrence txo on
	sa.sample_key = txo.taxon_occurrence_key
inner join
	taxon_determination txd on
	txo.taxon_occurrence_key = txd.taxon_occurrence_key
where
	dbo.LCReturnTetrad(
		replace(sa.spatial_ref, ' ', ''), sa.spatial_ref_system) != ''
group by
	dbo.LCReturnTetrad(
		replace(sa.spatial_ref, ' ', ''), sa.spatial_ref_system)
	,txd.taxon_list_item_key
order by
	dbo.LCReturnTetrad(
		replace(sa.spatial_ref, ' ', ''), sa.spatial_ref_system)