USE [NBNReporting];

ALTER TABLE ALL_NBN_geo ADD CONSTRAINT PK_RecordKey
PRIMARY KEY CLUSTERED (RecordKey);

CREATE SPATIAL INDEX [IDX_Geo] ON [dbo].[ALL_NBN_geo] 
(
	[Geo]
)USING  GEOMETRY_GRID 
WITH (
-- BOUNDING_BOX =(471414, 90053, 603609.899826, 144473.399976), GRIDS =(LEVEL_1 = MEDIUM,LEVEL_2 = MEDIUM,LEVEL_3 = MEDIUM,LEVEL_4 = MEDIUM), 
BOUNDING_BOX =(471414, 90054, 603610, 144473), GRIDS =(LEVEL_1 = MEDIUM,LEVEL_2 = MEDIUM,LEVEL_3 = MEDIUM,LEVEL_4 = MEDIUM), 
CELLS_PER_OBJECT = 16, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON);