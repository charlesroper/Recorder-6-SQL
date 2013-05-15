begin tran
use NBNData;

select
  *
from
  SAMPLE sa
where
  VAGUE_DATE_START is null

update
  SAMPLE
set
  VAGUE_DATE_START = 0
from
  SAMPLE 
where
  VAGUE_DATE_START is null

update
  SAMPLE
set
  VAGUE_DATE_END = 0
from
  SAMPLE 
where
  VAGUE_DATE_END = null
  
select
  *
from
  SAMPLE sa
where
  VAGUE_DATE_START is null

commit tran