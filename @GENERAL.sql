USE NBNData
GO

SELECT DISTINCT -- TOP 100
	TXO.TAXON_OCCURRENCE_KEY,
	ITN2.PREFERRED_NAME,
	CASE WHEN ITN2.PREFERRED_NAME = ITN2.COMMON_NAME THEN
		TXG.TAXON_GROUP_NAME
	ELSE
		ITN2.COMMON_NAME
	END AS [COMMON NAME],
	TXG.TAXON_GROUP_NAME AS TAXON_GROUP,
	ITN2.SORT_ORDER,
	dbo.LCReturnVagueDateShort(SE.VAGUE_DATE_START, SE.VAGUE_DATE_END, SE.VAGUE_DATE_TYPE) AS DATE,
	SE.VAGUE_DATE_START,
	SE.VAGUE_DATE_END,
	SE.VAGUE_DATE_TYPE,
	REPLACE(SA.SPATIAL_REF, ' ', '') AS SPATIAL_REF,
	LEN(REPLACE(SA.SPATIAL_REF, ' ', '')) AS SPATIAL_PRECISION,
	CASE
	WHEN SA.LOCATION_NAME != '' AND LN.ITEM_NAME != '' THEN
		CASE
		WHEN SA.LOCATION_NAME = LN.ITEM_NAME THEN
			LN.ITEM_NAME
		ELSE
			SA.LOCATION_NAME + ', ' + LN.ITEM_NAME
		END
	WHEN SA.LOCATION_NAME IS NULL AND LN.ITEM_NAME IS NOT NULL THEN
		LN.ITEM_NAME
	WHEN LN.ITEM_NAME IS NULL AND SA.LOCATION_NAME IS NOT NULL THEN
		SA.LOCATION_NAME
	END AS LOCATION,
	dbo.FormatEventRecorders(SA.SAMPLE_KEY) AS RECORDERS,
	CASE WHEN dbo.LCAbundanceCount(TXO.TAXON_OCCURRENCE_KEY) != 0 THEN
		dbo.LCAbundanceCount(TXO.TAXON_OCCURRENCE_KEY)
	ELSE
		NULL
	END AS SUM_OF_ABUNDANCE,
	dbo.LCFormatAbundanceData(TXO.TAXON_OCCURRENCE_KEY) AS ABUNDANCES,
	S.ITEM_NAME AS SURVEY_NAME,
	DES.STATUS_KIND,
	dbo.LCReturnEastings_c(REPLACE(SA.SPATIAL_REF, ' ', ''), SA.SPATIAL_REF_SYSTEM) AS X,
	dbo.LCReturnNorthings_c(REPLACE(SA.SPATIAL_REF, ' ', ''), SA.SPATIAL_REF_SYSTEM) AS Y
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
INNER JOIN
	VW_DESIGNATIONS [DES] ON
	ITN.TAXON_LIST_ITEM_KEY = DES.TAXON_LIST_ITEM_KEY
WHERE
	TXO.ZERO_ABUNDANCE = 0
	AND TXO.CHECKED = 1
	AND	TXD.PREFERRED = 1
	AND	LN.PREFERRED = 1
	--AND (DES.STATUS_KIND = 'SxRSI' OR DES.STATUS_KIND = 'SxPSR')
ORDER BY
	ITN2.SORT_ORDER ASC
GO
