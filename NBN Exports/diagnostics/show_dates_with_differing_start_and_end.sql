select 
  VAGUE_DATE_TYPE
from
  SAMPLE sa
where 
  sa.VAGUE_DATE_START != sa.VAGUE_DATE_END
group by
  VAGUE_DATE_TYPE