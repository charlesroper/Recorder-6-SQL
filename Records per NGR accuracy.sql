use NBNData

select 
  LEN(sa.SPATIAL_REF) as Grid
  ,count(txo.TAXON_OCCURRENCE_KEY) as Record_Count
from
  SAMPLE sa
join
  TAXON_OCCURRENCE txo on
  sa.SAMPLE_KEY = txo.SAMPLE_KEY
group by
  LEN(sa.SPATIAL_REF)
order by
  LEN(sa.SPATIAL_REF)