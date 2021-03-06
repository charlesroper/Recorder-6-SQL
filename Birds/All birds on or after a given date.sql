USE NBNData
GO

DECLARE @date char(10)
SET @date = '2012-02-03'

SELECT DISTINCT
	 TXO.TAXON_OCCURRENCE_KEY
	,S.ITEM_NAME AS SURVEY
	,TXO.ENTRY_DATE AS OBS_ENTRY
	,TXO.CHANGED_DATE AS OBS_CHANGED
	,SA.ENTRY_DATE AS SAMPLE_ENTRY
	,SA.CHANGED_DATE AS SAMPLE_CHANGED
	,TXO.CHECKED AS CHECKED
	,ITN2.PREFERRED_NAME
	,CASE WHEN ITN2.PREFERRED_NAME = ITN2.COMMON_NAME THEN
		'-'
	ELSE
		ITN2.COMMON_NAME
	END AS [COMMON NAME]
	,TXG.TAXON_GROUP_NAME AS TAXON_GROUP
	,ITN2.SORT_ORDER
	,dbo.LCReturnVagueDateShort(SE.VAGUE_DATE_START, SE.VAGUE_DATE_END, SE.VAGUE_DATE_TYPE) AS DATE
	,dbo.LCReturnDateShort(SE.VAGUE_DATE_START,SE.VAGUE_DATE_TYPE,'Y') AS YEAR_START
	,dbo.LCReturnDateShort(SE.VAGUE_DATE_END,SE.VAGUE_DATE_TYPE,'Y') AS YEAR_END
	,REPLACE(SA.SPATIAL_REF, ' ', '') AS SPATIAL_REF
	,dbo.LCRectifyGR(SA.SPATIAL_REF, SA.SPATIAL_REF_SYSTEM, 1) AS KM
	,dbo.FormatLocation(sa.sample_key) AS LOCATION
	,dbo.FormatEventRecorders(SA.SAMPLE_KEY) AS RECORDERS
	,CASE WHEN dbo.LCAbundanceValue(TXO.TAXON_OCCURRENCE_KEY) != 0 THEN
		dbo.LCAbundanceValue(TXO.TAXON_OCCURRENCE_KEY)
	ELSE
		NULL
	END AS SUM_OF_ABUNDANCE
	,dbo.LCFormatAbundanceData(TXO.TAXON_OCCURRENCE_KEY) AS ABUNDANCES
	,dbo.ufn_RtfToPlaintext(CAST(TXO.COMMENT AS VARCHAR(MAX))) AS COMMENT
	,dbo.LCReturnEastings_c(REPLACE(SA.SPATIAL_REF, ' ', ''), SA.SPATIAL_REF_SYSTEM) AS X
	,dbo.LCReturnNorthings_c(REPLACE(SA.SPATIAL_REF, ' ', ''), SA.SPATIAL_REF_SYSTEM) AS Y
FROM
	INDEX_TAXON_NAME ITN
INNER JOIN
	INDEX_TAXON_NAME ITN2 ON
	ITN.RECOMMENDED_TAXON_LIST_ITEM_KEY = ITN2.TAXON_LIST_ITEM_KEY
INNER JOIN
	TAXON_LIST_ITEM TLI ON
	ITN.TAXON_LIST_ITEM_KEY = TLI.TAXON_LIST_ITEM_KEY
INNER JOIN
	TAXON_VERSION TXV ON
	TLI.TAXON_VERSION_KEY = TXV.TAXON_VERSION_KEY
INNER JOIN
	TAXON_GROUP TXG ON
	TXV.OUTPUT_GROUP_KEY = TXG.TAXON_GROUP_KEY
INNER JOIN
	TAXON_DETERMINATION TXD ON
	ITN.TAXON_LIST_ITEM_KEY = TXD.TAXON_LIST_ITEM_KEY
INNER JOIN
	TAXON_OCCURRENCE TXO ON
	TXD.TAXON_OCCURRENCE_KEY = TXO.TAXON_OCCURRENCE_KEY
INNER JOIN
	SAMPLE SA ON
	TXO.SAMPLE_KEY = SA.SAMPLE_KEY
INNER JOIN
	SURVEY_EVENT SE ON
	SA.SURVEY_EVENT_KEY = SE.SURVEY_EVENT_KEY
INNER JOIN
	LOCATION_NAME LN ON
	SE.LOCATION_KEY = LN.LOCATION_KEY
INNER JOIN
	TAXON_OCCURRENCE_DATA TXOD ON
	TXO.TAXON_OCCURRENCE_KEY = TXOD.TAXON_OCCURRENCE_KEY
INNER JOIN
	SURVEY S ON
	SE.SURVEY_KEY = S.SURVEY_KEY
LEFT JOIN
  SURVEY_TAG STAG
  ON SE.SURVEY_KEY = STAG.SURVEY_KEY
LEFT JOIN
  CONCEPT C
  ON STAG.CONCEPT_KEY = C.CONCEPT_KEY
LEFT JOIN
  TERM
  ON C.TERM_KEY = TERM.TERM_KEY
WHERE
	TXO.ZERO_ABUNDANCE = 0
	AND	TXD.PREFERRED = 1
	AND	LN.PREFERRED = 1
	AND TXG.TAXON_GROUP_KEY = 'NHMSYS0000080039' -- birds
	AND TERM.ITEM_NAME NOT LIKE 'Horsham District%' 
	AND (
	  TXO.ENTRY_DATE >= CONVERT(smalldatetime, @date)
	  OR TXO.CHANGED_DATE >= CONVERT(smalldatetime, @date)
	  OR SA.ENTRY_DATE >= CONVERT(smalldatetime, @date)
	  OR SA.CHANGED_DATE >= CONVERT(smalldatetime, @date)
	)
	
ORDER BY
	ITN2.SORT_ORDER ASC
GO
