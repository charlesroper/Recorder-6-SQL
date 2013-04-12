select
	txo.zero_abundance
	,txod.data
--update 
--	taxon_occurrence
--set
--	zero_abundance = '1'
from
	taxon_occurrence as txo
inner join
	taxon_occurrence_data as txod on
	txo.taxon_occurrence_key = txod.taxon_occurrence_key
where
	data = '0' and zero_abundance != '1'
	