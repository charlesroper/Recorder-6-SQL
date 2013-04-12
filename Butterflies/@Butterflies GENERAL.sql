declare
	@date_start as int, @date_end  as int
	
set @date_start = dbo.LCToRataDie('01/01/2005')
set @date_end   = dbo.LCToRataDie('31/12/2009')

select distinct
	txo.TAXON_OCCURRENCE_KEY
	,itn2.PREFERRED_NAME as TAXON
	,itn2.COMMON_NAME
	,txg.TAXON_GROUP_NAME
	,dbo.FormatLocation(sa.SAMPLE_KEY) as [SITE]
	,sa.SPATIAL_REF as GRIDREF
	,dbo.LCFormatVC(sa.LOCATION_KEY) as VC
	,dbo.FormatEventRecorders(sa.SAMPLE_KEY) as RECORDERS
	,case
		when dbo.FormatEventRecorders(sa.SAMPLE_KEY) = dbo.FormatIndividual(deti.title,deti.initials,deti.FORENAME,deti.SURNAME) then
			''
		else
			dbo.FormatIndividual(deti.title,deti.initials,deti.FORENAME,deti.SURNAME)
		end as DETERMINER
	,dbo.LCReturnVagueDateShort(sa.VAGUE_DATE_START, sa.VAGUE_DATE_END, sa.VAGUE_DATE_TYPE) as [DATE]
	,txod.DATA
	,'Field Observation' as METHOD	
	,mq.SHORT_NAME as SEX
	,'' as STAGE
	,'' as [STATUS]
	,dbo.ufn_RtfToPlaintext(ltrim(rtrim(cast(txo.comment as varchar(max))))) as COMMENT
	,'[TXO_KEY:' + txo.TAXON_OCCURRENCE_KEY + ']' as COMMENT
from
	INDEX_TAXON_NAME itn
inner join
	INDEX_TAXON_NAME itn2 on
	itn.RECOMMENDED_TAXON_LIST_ITEM_KEY = itn2.TAXON_LIST_ITEM_KEY
inner join
	VW_TAXON_GROUP txg on
	itn2.TAXON_LIST_ITEM_KEY = txg.TAXON_LIST_ITEM_KEY
inner join
	TAXON_DETERMINATION txd on
	itn.TAXON_LIST_ITEM_KEY = txd.TAXON_LIST_ITEM_KEY and
	txd.PREFERRED = 1
inner join
	TAXON_OCCURRENCE txo on
	txd.TAXON_OCCURRENCE_KEY = txo.TAXON_OCCURRENCE_KEY
inner join
	[SAMPLE] sa on
	txo.SAMPLE_KEY = sa.SAMPLE_KEY
inner join
	SURVEY_EVENT_RECORDER ser on
	sa.SURVEY_EVENT_KEY = ser.SURVEY_EVENT_KEY
inner join
	INDIVIDUAL i on
	ser.NAME_KEY = i.NAME_KEY
inner join
	INDIVIDUAL deti on
	txd.DETERMINER = deti.NAME_KEY
inner join
	TAXON_OCCURRENCE_DATA txod on
	txo.TAXON_OCCURRENCE_KEY = txod.TAXON_OCCURRENCE_KEY
inner join
	MEASUREMENT_QUALIFIER mq on
	txod.MEASUREMENT_QUALIFIER_KEY = mq.MEASUREMENT_QUALIFIER_KEY
where
	txg.TAXON_GROUP_NAME like '%butterfly%'
	and sa.VAGUE_DATE_START >= @date_start
	and sa.VAGUE_DATE_END   <= @date_end
	