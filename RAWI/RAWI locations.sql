use NBNData
go

select
	su.ITEM_NAME			[Survey Name]
	,dbo.LCReturnVagueDateShort(
		se.VAGUE_DATE_START,
		se.VAGUE_DATE_END,
		se.VAGUE_DATE_TYPE) [Date Surveyed]
	,locn.LOCATION_KEY      [KEY]
	,locnam.ITEM_NAME       [locnam]
	,locn.ITEM_NAME			[Location Name]
	,loc.FILE_CODE			[File Code]
	,loc.SPATIAL_REF		[Central Grid Ref]
	,locft.LONG_NAME		[Feature Type]
	,locft.SHORT_NAME		[Feature Type Code]
	,locf.ITEM_NAME			[Feature Name]
	,locfg.LONG_NAME		[Feature Grading]
	,locfg.SHORT_NAME		[Feature Grading Code]
	,dbo.ufn_RtfToPlaintext(locf.COMMENT)                            [Feature Comment]
	,CAST(dbo.ufn_RtfToPlaintext(loc.DESCRIPTION) as VARCHAR(MAX))   [DESCRIPTION]
	,dbo.LCReturnEastings_c(loc.SPATIAL_REF,loc.SPATIAL_REF_SYSTEM)  [Eastings]
	,dbo.LCReturnNorthings_c(loc.SPATIAL_REF,loc.SPATIAL_REF_SYSTEM) [Northings]
from
	SURVEY su
inner join
	SURVEY_EVENT se on
	su.SURVEY_KEY = se.SURVEY_KEY
inner join
	LOCATION loc on
	se.LOCATION_KEY = loc.LOCATION_KEY
inner join
	LOCATION_NAME locn on
	se.LOCATION_KEY = locn.LOCATION_KEY
inner join
	LOCATION_NAME locnam on
	locn.LOCATION_KEY = locnam.LOCATION_KEY and locnam.PREFERRED = 1
inner join
	LOCATION_FEATURE locf on
	se.LOCATION_KEY = locf.LOCATION_KEY
inner join
	LOCATION_FEATURE_GRADING locfg on
	locf.FEATURE_GRADING_KEY = locfg.FEATURE_GRADING_KEY
inner join
	LOCATION_FEATURE_TYPE locft on
	locfg.LOCATION_FEATURE_TYPE_KEY = locft.LOCATION_FEATURE_TYPE_KEY
where
	su.ITEM_NAME like 'Revised Ancient Woodland Survey - %'
	and locn.ITEM_NAME != locnam.ITEM_NAME
order by
	locnam.ITEM_NAME