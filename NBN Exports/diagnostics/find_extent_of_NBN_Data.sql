use NBNReporting;
select
   minY  = MIN(a.Y)
  ,minX  = MIN(a.X)
  ,maxY  = MAX(a.Y)
  ,maxX  = MAX(a.X)
from ALL_NBN a

-- Find records that are far out to sea
select * from all_nbn where (x > 471414 and y < 90053) and LEN(GridReference) > 4
