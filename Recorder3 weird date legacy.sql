use NBNData;
go

select distinct
	su.SURVEY_KEY
	,su.ITEM_NAME
	,SURVEY_TAG = dbo.ufn_GetSurveyTagString(su.SURVEY_KEY)
	,sa.SAMPLE_KEY
	,[DATE] = dbo.LCReturnVagueDateShort(sa.VAGUE_DATE_START, sa.VAGUE_DATE_END, sa.VAGUE_DATE_TYPE)
	,[YEAR] = dbo.FormatDatePart(sa.VAGUE_DATE_START, sa.VAGUE_DATE_END, sa.VAGUE_DATE_TYPE, 0)
	,sa.VAGUE_DATE_START
	,sa.VAGUE_DATE_END
	,sa.VAGUE_DATE_TYPE
from
	SURVEY su
join
	SURVEY_EVENT se
	on su.SURVEY_KEY = se.SURVEY_KEY
join
	SAMPLE sa
	on se.SURVEY_EVENT_KEY = sa.SURVEY_EVENT_KEY	
where
	dbo.ufn_GetSurveyTagString(su.SURVEY_KEY) = 'Recorder 3 Records'
	and dbo.FormatDatePart(sa.VAGUE_DATE_START, sa.VAGUE_DATE_END, sa.VAGUE_DATE_TYPE, 0) < '1900'
order by
	sa.VAGUE_DATE_START asc
