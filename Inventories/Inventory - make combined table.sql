USE NBNReporting;

IF OBJECT_ID('FULL_COMBINED', 'U') IS NOT NULL
    DROP TABLE FULL_COMBINED;

IF OBJECT_ID('tempdb..#change_dates') IS NOT NULL
    DROP TABLE #change_dates;

/** Combine inventory tables **/
SELECT
    [TAXON_OCCURRENCE_KEY]
    ,[TAXON_VERSION_KEY] = CAST('' AS VARCHAR(16))
    ,[PREFERRED_TAXON_VERSION_KEY] = CAST('' AS VARCHAR(16))
    ,[DATE_UPDATED] = CAST('1900-01-01 00:00' AS smalldatetime)
    ,[PREFERRED_NAME]
    ,[COMMON_NAME]
    ,[AUTHORITY] = CAST('' AS VARCHAR(80))
    ,[TAXON_GROUP]
    ,[SORT_ORDER]
    ,[DATE]
    ,[SPATIAL_REF]
    ,[LOCATION]
    ,[RECORDERS]
    ,[SUM_OF_ABUNDANCE]
    ,[ABUNDANCES]
    ,'F' AS BAP
    ,'F' AS BATS
    ,'F' AS NBIRDS
    ,'F' AS PSR
    ,'F' AS RSI
    ,'F' AS SIASR
INTO FULL_COMBINED
FROM
    FULL_BAP
UNION
SELECT
    [TAXON_OCCURRENCE_KEY]
    ,[TAXON_VERSION_KEY] = CAST('' AS VARCHAR(16))
    ,[PREFERRED_TAXON_VERSION_KEY] = CAST('' AS VARCHAR(16))
    ,[DATE_UPDATED] = CAST('1900-01-01 00:00' AS smalldatetime)
    ,[PREFERRED_NAME]
    ,[COMMON_NAME]
    ,[AUTHORITY] = CAST('' AS VARCHAR(80))
    ,[TAXON_GROUP]
    ,[SORT_ORDER]
    ,[DATE]
    ,[SPATIAL_REF]
    ,[LOCATION]
    ,[RECORDERS]
    ,[SUM_OF_ABUNDANCE]
    ,[ABUNDANCES]
    ,'F' AS BAP
    ,'F' AS BATS
    ,'F' AS NBIRDS
    ,'F' AS PSR
    ,'F' AS RSI
    ,'F' AS SIASR
FROM
    FULL_BATS
UNION
SELECT
    [TAXON_OCCURRENCE_KEY]
    ,[TAXON_VERSION_KEY] = CAST('' AS VARCHAR(16))
    ,[PREFERRED_TAXON_VERSION_KEY] = CAST('' AS VARCHAR(16))
    ,[DATE_UPDATED] = CAST('1900-01-01 00:00' AS smalldatetime)
    ,[PREFERRED_NAME]
    ,[COMMON_NAME]
    ,[AUTHORITY] = CAST('' AS VARCHAR(80))
    ,[TAXON_GROUP]
    ,[SORT_ORDER]
    ,[DATE]
    ,[SPATIAL_REF]
    ,[LOCATION]
    ,[RECORDERS]
    ,''
    ,''
    ,'F' AS BAP
    ,'F' AS BATS
    ,'F' AS NBIRDS
    ,'F' AS PSR
    ,'F' AS RSI
    ,'F' AS SIASR
FROM
    FULL_NOTABLE
UNION
SELECT
    [TAXON_OCCURRENCE_KEY]
    ,[TAXON_VERSION_KEY] = CAST('' AS VARCHAR(16))
    ,[PREFERRED_TAXON_VERSION_KEY] = CAST('' AS VARCHAR(16))
    ,[DATE_UPDATED] = CAST('1900-01-01 00:00' AS smalldatetime)
    ,[PREFERRED_NAME]
    ,[COMMON_NAME]
    ,[AUTHORITY] = CAST('' AS VARCHAR(80))
    ,[TAXON_GROUP]
    ,[SORT_ORDER]
    ,[DATE]
    ,[SPATIAL_REF]
    ,[LOCATION]
    ,[RECORDERS]
    ,[SUM_OF_ABUNDANCE]
    ,[ABUNDANCES]
    ,'F' AS BAP
    ,'F' AS BATS
    ,'F' AS NBIRDS
    ,'F' AS PSR
    ,'F' AS RSI
    ,'F' AS SIASR
FROM
    FULL_PSR
UNION
SELECT
    [TAXON_OCCURRENCE_KEY]
    ,[TAXON_VERSION_KEY] = CAST('' AS VARCHAR(16))
    ,[PREFERRED_TAXON_VERSION_KEY] = CAST('' AS VARCHAR(16))
    ,[DATE_UPDATED] = CAST('1900-01-01 00:00' AS smalldatetime)
    ,[PREFERRED_NAME]
    ,[COMMON_NAME]
    ,[AUTHORITY] = CAST('' AS VARCHAR(80))
    ,[TAXON_GROUP]
    ,[SORT_ORDER]
    ,[DATE]
    ,[SPATIAL_REF]
    ,[LOCATION]
    ,[RECORDERS]
    ,[SUM_OF_ABUNDANCE]
    ,[ABUNDANCES]
    ,'F' AS BAP
    ,'F' AS BATS
    ,'F' AS NBIRDS
    ,'F' AS PSR
    ,'F' AS RSI
    ,'F' AS SIASR
FROM
    FULL_RSI
UNION
SELECT
    [TAXON_OCCURRENCE_KEY]
    ,[TAXON_VERSION_KEY] = CAST('' AS VARCHAR(16))
    ,[PREFERRED_TAXON_VERSION_KEY] = CAST('' AS VARCHAR(16))
    ,[DATE_UPDATED] = CAST('1900-01-01 00:00' AS smalldatetime)
    ,[PREFERRED_NAME]
    ,[COMMON_NAME]
    ,[AUTHORITY] = CAST('' AS VARCHAR(80))
    ,[TAXON_GROUP]
    ,[SORT_ORDER]
    ,[DATE]
    ,[SPATIAL_REF]
    ,[LOCATION]
    ,[RECORDERS]
    ,[SUM_OF_ABUNDANCE]
    ,[ABUNDANCES]
    ,'F' AS BAP
    ,'F' AS BATS
    ,'F' AS NBIRDS
    ,'F' AS PSR
    ,'F' AS RSI
    ,'F' AS SIASR
FROM
    FULL_SIASR;


/** Add inventory flags **/
UPDATE  FULL_COMBINED
SET     BAP = 'T'
FROM    FULL_COMBINED AS fc
JOIN    FULL_BAP fb
        ON fc.TAXON_OCCURRENCE_KEY = fb.TAXON_OCCURRENCE_KEY;

UPDATE  FULL_COMBINED
SET     BATS = 'T'
FROM    FULL_COMBINED AS fc
JOIN    FULL_BATS fb
        ON fc.TAXON_OCCURRENCE_KEY = fb.TAXON_OCCURRENCE_KEY;

UPDATE  FULL_COMBINED
SET     NBIRDS = 'T'
FROM    FULL_COMBINED AS fc
JOIN    FULL_NOTABLE fb
        ON fc.TAXON_OCCURRENCE_KEY = fb.TAXON_OCCURRENCE_KEY;

UPDATE  FULL_COMBINED
SET     PSR = 'T'
FROM    FULL_COMBINED AS fc
JOIN    FULL_PSR fb
        ON fc.TAXON_OCCURRENCE_KEY = fb.TAXON_OCCURRENCE_KEY;

UPDATE  FULL_COMBINED
SET     RSI = 'T'
FROM    FULL_COMBINED AS fc
JOIN    FULL_RSI fb
        ON fc.TAXON_OCCURRENCE_KEY = fb.TAXON_OCCURRENCE_KEY;

UPDATE  FULL_COMBINED
SET     SIASR = 'T'
FROM    FULL_COMBINED AS fc
JOIN    FULL_SIASR fb
        ON fc.TAXON_OCCURRENCE_KEY = fb.TAXON_OCCURRENCE_KEY;


/** Add in changed dates, initial pass **/
UPDATE
    fc
SET
    fc.DATE_UPDATED = c.CHANGED_DATE
FROM
    FULL_COMBINED fc
INNER JOIN
    (
        SELECT
            fc.TAXON_OCCURRENCE_KEY
            ,[CHANGED_DATE] = (
                SELECT MAX(isnull(N,0)) FROM (
                    VALUES
                         (txo.ENTRY_DATE)
                        ,(txo.CHANGED_DATE)
                        ,(sa.ENTRY_DATE)
                        ,(sa.CHANGED_DATE)
                        ,(txd.ENTRY_DATE)
                        ,(txd.CHANGED_DATE)
                ) AS T(N)
            ) -- [CHANGED_DATE]
        FROM
            FULL_COMBINED fc
        INNER JOIN
            NBNData.dbo.TAXON_DETERMINATION txd
            ON fc.TAXON_OCCURRENCE_KEY = txd.TAXON_OCCURRENCE_KEY
        INNER JOIN
            NBNData.dbo.DETERMINATION_TYPE dt
            ON txd.DETERMINATION_TYPE_KEY = dt.DETERMINATION_TYPE_KEY
        INNER JOIN
            NBNData.dbo.TAXON_OCCURRENCE txo
            ON fc.TAXON_OCCURRENCE_KEY = txo.TAXON_OCCURRENCE_KEY
        INNER JOIN
            NBNData.dbo.SAMPLE sa
            ON txo.SAMPLE_KEY = sa.SAMPLE_KEY
        WHERE
            (txd.PREFERRED = 1 AND dt.Verified != 1)
            AND txo.ZERO_ABUNDANCE = 0
            AND txo.CONFIDENTIAL = 0
            AND txo.CHECKED = 1
    ) AS c
    ON fc.TAXON_OCCURRENCE_KEY = c.TAXON_OCCURRENCE_KEY;


/** Check Locations for updates **/
UPDATE
   fc
SET
    fc.DATE_UPDATED = (
        SELECT MAX(isnull(n, 0)) FROM (
            VALUES
                 (l.CHANGED_DATE)
                ,(l.ENTRY_DATE)
                ,(ln.CHANGED_DATE)
                ,(ln.ENTRY_DATE)
                ,(fc.DATE_UPDATED)
        ) AS t(n)
    )
FROM
    FULL_COMBINED fc
INNER JOIN
    NBNData.dbo.TAXON_OCCURRENCE txo
    ON fc.TAXON_OCCURRENCE_KEY = txo.TAXON_OCCURRENCE_KEY
INNER JOIN
    NBNData.dbo.SAMPLE sa
    ON txo.SAMPLE_KEY = sa.SAMPLE_KEY
INNER JOIN
    NBNData.dbo.LOCATION l
    ON sa.LOCATION_KEY = l.LOCATION_KEY
INNER JOIN
    NBNData.dbo.LOCATION_NAME ln
    ON l.LOCATION_KEY = ln.LOCATION_KEY
WHERE
    ln.PREFERRED = 1;


/** Check Recorders for updates **/
UPDATE
    fc
SET
    fc.DATE_UPDATED = (
        SELECT MAX(isnull(n, 0)) FROM (
            VALUES
                 (ser.CHANGED_DATE)
                ,(ser.ENTRY_DATE)
                ,(i.CHANGED_DATE)
                ,(i.ENTRY_DATE)
                ,(fc.DATE_UPDATED)
        ) AS t(n)
    )
FROM
    FULL_COMBINED fc
INNER JOIN
    NBNData.dbo.TAXON_OCCURRENCE txo
    ON fc.TAXON_OCCURRENCE_KEY = txo.TAXON_OCCURRENCE_KEY
INNER JOIN
    NBNData.dbo.SAMPLE sa
    ON txo.SAMPLE_KEY = sa.SAMPLE_KEY
INNER JOIN
    NBNData.dbo.SURVEY_EVENT se
    ON sa.SURVEY_EVENT_KEY = se.SURVEY_EVENT_KEY
INNER JOIN
    NBNData.dbo.SURVEY_EVENT_RECORDER ser
    ON se.SURVEY_EVENT_KEY = ser.SURVEY_EVENT_KEY
INNER JOIN
    NBNData.dbo.INDIVIDUAL i
    ON ser.NAME_KEY = i.NAME_KEY;


/* Check Taxon Occurrence Data */
UPDATE
    fc
SET
    fc.DATE_UPDATED = (
        SELECT MAX(isnull(n, 0)) FROM (
            VALUES
                 (txod.CHANGED_DATE)
                ,(txod.ENTRY_DATE)
                ,(mq.CHANGED_DATE)
                ,(mq.ENTRY_DATE)
                ,(mu.CHANGED_DATE)
                ,(mu.ENTRY_DATE)
                ,(fc.DATE_UPDATED)
        ) AS t(n)
    )
FROM
    FULL_COMBINED fc
INNER JOIN
    NBNData.dbo.TAXON_OCCURRENCE_DATA txod
    ON fc.TAXON_OCCURRENCE_KEY = txod.TAXON_OCCURRENCE_KEY
INNER JOIN
    NBNData.dbo.MEASUREMENT_QUALIFIER mq
    ON txod.MEASUREMENT_QUALIFIER_KEY = mq.MEASUREMENT_QUALIFIER_KEY
INNER JOIN
    NBNData.dbo.MEASUREMENT_UNIT mu
    ON txod.MEASUREMENT_UNIT_KEY = mu.MEASUREMENT_UNIT_KEY;


/* Add in the taxon_version_key */
UPDATE
	fc
SET
	fc.PREFERRED_TAXON_VERSION_KEY = txli2.TAXON_VERSION_KEY
	,fc.TAXON_VERSION_KEY = txli.TAXON_VERSION_KEY
FROM
    FULL_COMBINED FC
JOIN
	NBNData.dbo.TAXON_DETERMINATION txd
	ON fc.TAXON_OCCURRENCE_KEY = txd.TAXON_OCCURRENCE_KEY
JOIN
	NBNData.dbo.INDEX_TAXON_NAME itn
	ON txd.TAXON_LIST_ITEM_KEY = itn.TAXON_LIST_ITEM_KEY
JOIN
	NBNData.dbo.INDEX_TAXON_NAME itn2
	ON itn.RECOMMENDED_TAXON_LIST_ITEM_KEY = itn2.TAXON_LIST_ITEM_KEY
JOIN
	NBNData.dbo.TAXON_LIST_ITEM txli
	ON txd.TAXON_LIST_ITEM_KEY = txli.TAXON_LIST_ITEM_KEY
JOIN
	NBNData.dbo.TAXON_LIST_ITEM txli2
	ON itn2.TAXON_LIST_ITEM_KEY = txli2.TAXON_LIST_ITEM_KEY;


/* Update the taxon names to preferred names */
UPDATE
	fc
SET
	fc.PREFERRED_NAME = itn.PREFERRED_NAME
	,fc.COMMON_NAME   = itn.COMMON_NAME
	,fc.AUTHORITY     = itn.AUTHORITY
FROM
	FULL_COMBINED fc
JOIN
	NBNData.dbo.TAXON_LIST_ITEM txli
	on fc.PREFERRED_TAXON_VERSION_KEY = txli.TAXON_VERSION_KEY
JOIN
	NBNData.dbo.INDEX_TAXON_NAME itn
	on txli.TAXON_LIST_ITEM_KEY = itn.TAXON_LIST_ITEM_KEY;


/* Create Dictionary of Preferred Taxa */
IF OBJECT_ID('DICT_OF_INVENTORIES', 'U') IS NOT NULL
    DROP TABLE DICT_OF_INVENTORIES;

SELECT DISTINCT
	fc.PREFERRED_TAXON_VERSION_KEY
	,fc.PREFERRED_NAME
	,COMMON_NAME = CASE
		WHEN fc.COMMON_NAME = fc.PREFERRED_NAME THEN ''
		ELSE fc.COMMON_NAME
	END
	,fc.AUTHORITY
	,fc.TAXON_GROUP
	,itn.SORT_ORDER
	,DATE_UPDATED = CAST('1900-01-01 00:00' AS smalldatetime)
INTO
	DICT_OF_INVENTORIES
FROM
	FULL_COMBINED AS fc
JOIN
	NBNData.dbo.TAXON_LIST_ITEM AS txli
	ON fc.TAXON_VERSION_KEY = txli.TAXON_VERSION_KEY
JOIN
	NBNData.dbo.INDEX_TAXON_NAME itn
	ON txli.TAXON_LIST_ITEM_KEY = itn.TAXON_LIST_ITEM_KEY
WHERE
	-- Exclude some weird taxa.
	fc.PREFERRED_TAXON_VERSION_KEY NOT IN (
		 'NBNSYS0000019904' -- Pyrenula macrospora (Weigel) Ach.
		,'NHMSYS0020001356' -- Pipistrellus pipistrellus (Schreber, 1774) / **no common name**
		,'NBNSYS0000007518' -- Laccophilus poecilus	Westhoff, 1881 / Diving Beetle
		,'NBNSYS0000015533' -- Calicium glaucellum Pers.
	);

ALTER TABLE DICT_OF_INVENTORIES ALTER COLUMN PREFERRED_TAXON_VERSION_KEY VARCHAR(16) NOT NULL;
ALTER TABLE DICT_OF_INVENTORIES ADD PRIMARY KEY (PREFERRED_TAXON_VERSION_KEY);


/* Add DATE_UPDATED to Dictionary */
UPDATE
	dict
SET
	dict.DATE_UPDATED = (
        SELECT MAX(isnull(n, 0)) FROM (
            VALUES
                 (txli.CHANGED_DATE)
                ,(txli.ENTRY_DATE)
                ,(txlv.CHANGED_DATE)
                ,(txlv.ENTRY_DATE)
                ,(tx.CHANGED_DATE)
                ,(tx.ENTRY_DATE)
        ) AS t(n)
    )
FROM
	DICT_OF_INVENTORIES AS dict
JOIN
	NBNData.dbo.TAXON_LIST_ITEM AS txli
	ON dict.PREFERRED_TAXON_VERSION_KEY = txli.TAXON_VERSION_KEY
JOIN
	NBNData.dbo.TAXON_LIST_VERSION AS txlv
	ON txli.TAXON_LIST_VERSION_KEY = txlv.TAXON_LIST_VERSION_KEY
JOIN
	NBNData.dbo.TAXON_VERSION AS txv
	ON txli.TAXON_VERSION_KEY = txv.TAXON_VERSION_KEY
JOIN
	NBNData.dbo.TAXON AS tx
	ON txv.TAXON_KEY = tx.TAXON_KEY
