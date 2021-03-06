use NBNReporting;
go

IF OBJECT_ID('NBNReporting.dbo.ALL_NBN_clipped', 'U') IS NOT NULL
  DROP TABLE NBNReporting.dbo.ALL_NBN_clipped;

declare @sussex geometry;
set @sussex = (select ogr_geometry from allsussex_2kmbuffer);

select
  *
into
  ALL_NBN_clipped
from
  ALL_NBN_geo n with(index(IDX_Geo))
where
  @sussex.STIntersects(n.Geo) = 1
  
