use NBNData;
select 
  txo.TAXON_OCCURRENCE_KEY
  ,sa.VAGUE_DATE_START
  ,sa.VAGUE_DATE_END
  ,sa.VAGUE_DATE_TYPE
  ,rendered_date  = dbo.LCReturnVagueDateShort(sa.VAGUE_DATE_START, sa.VAGUE_DATE_END, sa.VAGUE_DATE_TYPE)
from
  TAXON_OCCURRENCE txo
inner join
  SAMPLE sa
  on txo.SAMPLE_KEY = sa.SAMPLE_KEY
where
  sa.VAGUE_DATE_TYPE = '-Y'
  and
  sa.VAGUE_DATE_START = sa.VAGUE_DATE_END
order by
  VAGUE_DATE_START desc;