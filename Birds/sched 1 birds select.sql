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
ORDER BY ITN.COMMON_NAME ASC
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
                'wood lark',
                'common crossbill'
              )
            )
AND         dbo.LCReturnDateShort(SA.VAGUE_DATE_START,SA.VAGUE_DATE_END,'M') >= 3
AND         dbo.LCReturnDateShort(SA.VAGUE_DATE_START,SA.VAGUE_DATE_END,'M') <= 8
AND         TXO.SURVEYORS_REF NOT LIKE 'SOS%'
ORDER BY ITN.COMMON_NAME ASC
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
ORDER BY ITN.COMMON_NAME ASC
GO

