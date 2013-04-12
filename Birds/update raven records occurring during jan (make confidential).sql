-- Make all SOS-supplied Red Kite records occurring in Jan-Feb confidential
-- Change Rollback Tran to Commit Tran to apply the update

USE NBNData
GO

BEGIN TRAN

UPDATE TXO
SET         TXO.CONFIDENTIAL = 1,
            TXO.COMMENT = CASE 
			WHEN CAST(TXO.COMMENT AS VARCHAR(MAX)) != '' THEN
              CAST((CAST(TXO.COMMENT AS VARCHAR(1024)) + ' // This record has been marked as confidential in line with SOS agreement, May 2006 (2009 update) (Schedule 1 species that could potentially breed in Sussex).') AS TEXT)
            ELSE
              'This record has been marked as confidential in line with SOS agreement, May 2006 (2009 update) (Schedule 1 species that could potentially breed in Sussex).'
            END
OUTPUT INSERTED.*
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
				'Raven'
              )
            )
AND         dbo.LCReturnDateShort(SA.VAGUE_DATE_START,SA.VAGUE_DATE_END,'M') = 1
--AND         dbo.LCReturnDateShort(SA.VAGUE_DATE_START,SA.VAGUE_DATE_END,'M') <= 2
AND         TXO.SURVEYORS_REF LIKE 'SOS%'


ROLLBACK TRAN

GO