select
	s.ITEM_NAME		as [Survey Name]
	,dbo.LCReturnVagueDateShort(se.VAGUE_DATE_START, se.VAGUE_DATE_END, se.VAGUE_DATE_TYPE) as [Date Surveyed]
	,ln.ITEM_NAME	as [Location Name]
	,l.FILE_CODE	as [File Code]
	,l.SPATIAL_REF  as [Central Grid Ref]
	,lft.LONG_NAME	as [Feature Type]
	,lft.SHORT_NAME as [Feature Type Code]
	,lf.ITEM_NAME	as [Feature Name]
	,lfg.LONG_NAME  as [Feature Grading]
	,lfg.SHORT_NAME as [Feature Grading Code]
	,dbo.ufn_RtfToPlaintext(lf.COMMENT) as [Feature Comment]
from
	SURVEY s
inner join
	SURVEY_EVENT se on
	s.SURVEY_KEY = se.SURVEY_KEY
inner join
	LOCATION l on
	se.LOCATION_KEY = l.LOCATION_KEY
inner join
	LOCATION_NAME ln on
	l.LOCATION_KEY = ln.LOCATION_KEY and
	ln.PREFERRED = 1
inner join
	LOCATION_FEATURE lf on
	l.LOCATION_KEY = lf.LOCATION_KEY
inner join
	LOCATION_FEATURE_GRADING lfg on
	lf.FEATURE_GRADING_KEY = lfg.FEATURE_GRADING_KEY
inner join
	LOCATION_FEATURE_TYPE lft on
	lfg.LOCATION_FEATURE_TYPE_KEY = lft.LOCATION_FEATURE_TYPE_KEY
	
where
	s.SURVEY_KEY = 'THU0000200000069'
--	and	ln.ITEM_NAME = 'findon place'
order by
	[Location Name], [Feature Type Code]