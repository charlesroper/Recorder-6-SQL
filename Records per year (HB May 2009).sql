select
	count(txo.taxon_occurrence_key) as Record_Count
	,dbo.LCReturnDateShort(txd.vague_date_start,txd.vague_date_end,'Y') as Year
from 
	taxon_determination as txd
inner join
	taxon_occurrence as txo on
	txd.taxon_occurrence_key = txo.taxon_occurrence_key

group by dbo.LCReturnDateShort(txd.vague_date_start,txd.vague_date_end,'Y')
order by dbo.LCReturnDateShort(txd.vague_date_start,txd.vague_date_end,'Y')