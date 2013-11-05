use NBNReporting;
IF OBJECT_ID('NBNReporting.dbo.ALL_NBN_geo', 'U') IS NOT NULL
  DROP TABLE NBNReporting.dbo.ALL_NBN_geo; 

-- Add geometry points and create new table
select
  *
  ,Geo = geometry::Point(X, Y, 27700)
into
  ALL_NBN_geo
from
  ALL_NBN;