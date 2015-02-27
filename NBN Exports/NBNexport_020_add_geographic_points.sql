use NBNReporting;
IF OBJECT_ID('NBNReporting.dbo.ALL_NBN_geo', 'U') IS NOT NULL
  DROP TABLE NBNReporting.dbo.ALL_NBN_geo; 

-- Add geometry points and create new table
-- Note: "27700" is the EPSG code for the OSGB1936 spatial reference system
-- See here: http://spatialreference.org/ref/epsg/osgb-1936-british-national-grid/
select
  *
  ,Geo = geometry::Point(X, Y, 27700)
into
  ALL_NBN_geo
from
  ALL_NBN;
