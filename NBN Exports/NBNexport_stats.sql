Use NBNReporting;

select
  GridLen = LEN(GridReference)
  ,[Count] = COUNT(RecordKey)  
from
  ALL_NBN_clipped
--where
--  UpdatedOn > '2012-10-31 23:59:59' and
--  UpdatedOn <= '2013-10-31 23:59:59'
group by
  LEN(GridReference)
order by
  GridLen asc;

select
  [MinDate] = min(UpdatedOn) 
  ,[MaxDate] = max(UpdatedOn)
from
  ALL_NBN_clipped;

select count(recordkey) from ALL_NBN_clipped