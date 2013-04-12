use NBNData;
go

select
	[YEAR] = dbo.FormatDatePart(sa.VAGUE_DATE_START, sa.VAGUE_DATE_END, sa.VAGUE_DATE_TYPE, 0)
from
	SAMPLE sa
where
	sa.vague_date_start is not null
	and dbo.FormatDatePart(sa.VAGUE_DATE_START, sa.VAGUE_DATE_END, sa.VAGUE_DATE_TYPE, 0) = '1695'
order by
	dbo.FormatDatePart(sa.VAGUE_DATE_START, sa.VAGUE_DATE_END, sa.VAGUE_DATE_TYPE, 0) asc

