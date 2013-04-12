-- Select SOS-supplied Goshawk record which occur during January.

USE NBNData
GO
SELECT
            TXO.TAXON_OCCURRENCE_KEY,
            TXO.CONFIDENTIAL,
            ITN.COMMON_NAME,
            dbo.LCReturnDateShort(SA.VAGUE_DATE_START,SA.VAGUE_DATE_END,'F') AS [DATE],
            dbo.LCReturnDateShort(SA.VAGUE_DATE_START,SA.VAGUE_DATE_END,'M') AS [MONTH],
            SA.ENTRY_DATE,
            TXO.SURVEYORS_REF,
            TXO.COMMENT
FROM        INDEX_TAXON_NAME ITN
INNER JOIN  TAXON_DETERMINATION TXD ON
            ITN.TAXON_LIST_ITEM_KEY = TXD.TAXON_LIST_ITEM_KEY
INNER JOIN  TAXON_OCCURRENCE TXO ON
            TXD.TAXON_OCCURRENCE_KEY = TXO.TAXON_OCCURRENCE_KEY
INNER JOIN  SAMPLE SA ON
            TXO.SAMPLE_KEY = SA.SAMPLE_KEY
WHERE       ITN.RECOMMENDED_TAXON_LIST_ITEM_KEY IN (
              SELECT DISTINCT
                      ITN.RECOMMENDED_TAXON_LIST_ITEM_KEY
              FROM    INDEX_TAXON_NAME ITN
              WHERE   ITN.COMMON_NAME IN (
				'Goshawk'                
              )
            )
AND         dbo.LCReturnDateShort(SA.VAGUE_DATE_START,SA.VAGUE_DATE_END,'M') >= 1
AND         dbo.LCReturnDateShort(SA.VAGUE_DATE_START,SA.VAGUE_DATE_END,'M') <= 2
AND         TXO.SURVEYORS_REF LIKE 'SOS%'
ORDER BY ITN.COMMON_NAME ASC
GO