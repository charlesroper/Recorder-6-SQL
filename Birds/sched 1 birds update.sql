USE NBNData
GO

UPDATE TXO
SET         TXO.CONFIDENTIAL = 1,
            TXO.COMMENT = CASE WHEN TXO.COMMENT IS NOT NULL THEN
              CAST((CAST(TXO.COMMENT AS VARCHAR(1024)) + '. This record has been marked as confidential in line with SOS agreement, May 2006 (Schedule 1 species that could potentially breed in Sussex).') AS TEXT)
            ELSE
              'This record has been marked as confidential in line with SOS agreement, May 2006 (Schedule 1 species that could potentially breed in Sussex).'
            END
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
                'bittern',
                'greylag goose',
                'pintail',
                'garganey',
                'honey buzzard',
                'hobby',
                'red kite',
                'goshawk',
                'peregrine falcon',
                'quail',
                'spotted crake',
                'avocet',
                'stone curlew',
                'little ringed plover',
                'mediterranean gull',
                'little tern',
                'barn owl',
                'kingfisher',
                'bee eater',
                'hoopoo',
                --'wood lark',
                'black redstart',
                'marsh warbler',
                'dartford warbler',
                'firecrest',
                'bearded tit',
                'golden oriole',
                'serin',
                --'common crossbill',
                'montagu''s harrier',
                'cetti''s warbler',
                'savi''s warbler'
              )
            )
AND         dbo.LCReturnDateShort(SA.VAGUE_DATE_START,SA.VAGUE_DATE_END,'M') >= 3
AND         dbo.LCReturnDateShort(SA.VAGUE_DATE_START,SA.VAGUE_DATE_END,'M') <= 8
AND         TXO.SURVEYORS_REF NOT LIKE 'SOS%'
GO

UPDATE TXO
SET         TXO.CONFIDENTIAL = 1,
            TXO.COMMENT = CASE WHEN TXO.COMMENT IS NOT NULL THEN
              CAST((CAST(TXO.COMMENT AS VARCHAR(1024)) + '. This record has been marked as confidential in line with SOS agreement, May 2006 (Schedule 1 species that could potentially breed in Sussex).') AS TEXT)
            ELSE
              'This record has been marked as confidential in line with SOS agreement, May 2006 (Schedule 1 species that could potentially breed in Sussex).'
            END
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
                'wood lark',
                'common crossbill'
              )
            )
AND         dbo.LCReturnDateShort(SA.VAGUE_DATE_START,SA.VAGUE_DATE_END,'M') >= 2
AND         dbo.LCReturnDateShort(SA.VAGUE_DATE_START,SA.VAGUE_DATE_END,'M') <= 7
AND         TXO.SURVEYORS_REF NOT LIKE 'SOS%'
GO

UPDATE TXO
SET         TXO.CONFIDENTIAL = 1,
            TXO.COMMENT = CASE WHEN TXO.COMMENT IS NOT NULL THEN
              CAST((CAST(TXO.COMMENT AS VARCHAR(1024)) + '. This record has been marked as confidential in line with SOS agreement, May 2006 (other species that are sensitive in Sussex).') AS TEXT)
            ELSE
              'This record has been marked as confidential in line with SOS agreement, May 2006 (other species that are sensitive in Sussex).'
            END
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
                'little egret',
                'ruddy duck',
                'hen harrier',
                'long-eared owl',
                'raven',
                'lesser spotted woodpecker',
                'willow tit',
                'grasshopper warbler',
                'hawfinch'
              )
            )
AND         dbo.LCReturnDateShort(SA.VAGUE_DATE_START,SA.VAGUE_DATE_END,'M') >= 3
AND         dbo.LCReturnDateShort(SA.VAGUE_DATE_START,SA.VAGUE_DATE_END,'M') <= 8
AND         TXO.SURVEYORS_REF NOT LIKE 'SOS%'
GO