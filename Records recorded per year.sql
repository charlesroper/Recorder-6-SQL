use nbndata
go

select
	[year] = dbo.FormatDatePart(sa.VAGUE_DATE_START, sa.VAGUE_DATE_END, sa.VAGUE_DATE_TYPE, 0)
	,[recorded per year] = COUNT(txo.TAXON_OCCURRENCE_KEY)
from
	TAXON_OCCURRENCE txo
join
	TAXON_DETERMINATION txd on
	txo.TAXON_OCCURRENCE_KEY = txd.TAXON_OCCURRENCE_KEY and
	txd.PREFERRED = 1
join
	SAMPLE sa on
	txo.SAMPLE_KEY = sa.SAMPLE_KEY
group by
	dbo.FormatDatePart(sa.VAGUE_DATE_START, sa.VAGUE_DATE_END, sa.VAGUE_DATE_TYPE, 0)
order by
	dbo.FormatDatePart(sa.VAGUE_DATE_START, sa.VAGUE_DATE_END, sa.VAGUE_DATE_TYPE, 0)