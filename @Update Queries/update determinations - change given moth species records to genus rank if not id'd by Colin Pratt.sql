use nbndata;

if object_ID('tempdb..#jncc_newdata') is not null
    drop table tempdb..#jncc_newdata

/*
Re-determine moths that require genital determination
=====================================================

Several moth taxa require genital determination before records for them will
be accepted by the Sussex County Moth Recorder (Colin Pratt). These taxa are:

NHMSYS0000497250 November moth               = NHMSYS0000497247 Epirrita
NHMSYS0000495147 Grey Dagger                 = NHMSYS0000495136 Acronicta
NHMSYS0000498534 Common Rustic               = NHMSYS0000498530 Mesapamea
NHMSYS0000498531 Lesser Common Rustic        = NHMSYS0000498530 Mesapamea
NHMSYS0000495347 Copper Underwing            = NHMSYS0000495344 Amphipyra
NHMSYS0000550481 Svennson's Copper Underwing = NHMSYS0000495344 Amphipyra
NHMSYS0000495346 Svennson's subsp.           = NHMSYS0000495344 Amphipyra

The records to be changed should be in 2011 and 2012.

Use these attributes for new determination:

* comment:      No gen. det. so changed to genus.
* determiner:   Colin Pratt   [THU00002000001T6]
* date:         Today
* start date:   2011-01-01
* end date:     2012-12-12
* det status:   Correct       [NBNSYS0000000012]
* current user: Charles Roper [THU00002000001TP]

## Actions

Re-determine all moth records in above list that have not already been
determined by Colin Pratt and that fall within 2011 and 2012.

Steps:

    1.  Create temp table to hold new determination keys
    2.  Insert current determination keys into temp table where:
          - Determination is preferred
          - Determination is NOT by Colin Pratt
          - Taxon (TAXON_LIST_ITEM_KEY) is one of the above taxa
          - Sample date is in 2011 or 2012
    3.  Populate temp table with newly generated determination keys, joining
        to selected current det. keys
    4.  Insert new determinations and attributes into the TAXON_DETERMINATION
        table
    5.  Update the VERIFIED flag in the taxon occurrence
    6.  Remove the PREFERRED flag from the old determinations
*/

begin transaction
    declare
        @date                   datetime
        ,@new_determiner        char(16)
        ,@new_det_role          char(16)
        ,@new_det_type          char(16)
        ,@old_taxon             char(16)
        ,@new_taxon             char(16)
        ,@determination_comment varchar(max)
        ,@current_user          char(16)
        ,@start_date            char(10)
        ,@end_date              char(10)

    set @date                   = GETDATE()
    set @new_determiner         = 'THU00002000001T6' -- Colin Pratt
    set @new_det_role           = (select top 1 DETERMINER_ROLE_KEY from TAXON_DETERMINATION where DETERMINER = @new_determiner and PREFERRED = 1)
    set @new_det_type           = 'NBNSYS0000000012' -- Correct
    set @old_taxon              = 'NHMSYS0000497250' -- Epirrita dilutata
    set @new_taxon              = 'NHMSYS0000497247' -- Epirrita [genus]
    set @determination_comment  = 'No gen. det. so changed to genus.'
    set @current_user           = 'THU00002000001TP' -- Charles Roper
    set @start_date             = dbo.LCToRataDie('01/01/2011')
    set @end_date               = dbo.LCToRataDie('31/12/2011')

print '';
print 'Creating TEMP table...';
print '';

    -- Create temp table to hold new determination keys
    create table #jncc_newdata (
        orig_txd_key                char(16) collate SQL_Latin1_General_CP1_CI_AS
        ,taxon_determination_key    char(16) collate SQL_Latin1_General_CP1_CI_AS
    )

print '';
print 'Finding determination keys...';
print '';

    -- Insert all existing preferred determination keys where determiner is not Colin Pratt into temp table.
    insert into
        #jncc_newdata (orig_txd_key)
    select distinct
        txd.TAXON_DETERMINATION_KEY
    from
        TAXON_DETERMINATION txd
    join
        TAXON_OCCURRENCE txo on
        txd.TAXON_OCCURRENCE_KEY = txo.TAXON_OCCURRENCE_KEY
    join SAMPLE sa on
        txo.SAMPLE_KEY = sa.SAMPLE_KEY
    join SURVEY_EVENT_RECORDER ser on
        sa.SURVEY_EVENT_KEY = ser.SURVEY_EVENT_KEY
    where
        (txd.DETERMINER != @new_determiner and txd.PREFERRED = 1)
        and (sa.VAGUE_DATE_START >= @start_date and sa.VAGUE_DATE_END <= @end_date)
        and (txd.TAXON_LIST_ITEM_KEY IN (SELECT
                                      ITN_3.TAXON_LIST_ITEM_KEY AS [Other TLI]
                                    FROM
                                      INDEX_TAXON_NAME ITN_1
                                    INNER JOIN
                                      INDEX_TAXON_NAME ITN_2 ON
                                      ITN_1.RECOMMENDED_TAXON_LIST_ITEM_KEY = ITN_2.TAXON_LIST_ITEM_KEY
                                    INNER JOIN
                                      INDEX_TAXON_NAME ITN_3 ON
                                      ITN_2.TAXON_LIST_ITEM_KEY = ITN_3.RECOMMENDED_TAXON_LIST_ITEM_KEY
                                    WHERE
                                      ITN_1.TAXON_LIST_ITEM_KEY = @old_taxon))

print '';
print 'Populating TEMP table with new det. keys...';
print '';

    -- Populate temp table with new determination keys
    declare
        @original_key   char(16)
        ,@new_key       char(16)

    declare csr_new_txd_key cursor for
        select orig_txd_key from #jncc_newdata
        open csr_new_txd_key
        fetch next from csr_new_txd_key into @original_key
        while @@FETCH_STATUS = 0
        begin
            exec spNextKey 'TAXON_DETERMINATION', @new_key output
            update
                #jncc_newdata
            set
                taxon_determination_key = @new_key
            where
                orig_txd_key = @original_key
            fetch next from csr_new_txd_key into @original_key
        end
    close csr_new_txd_key
    deallocate csr_new_txd_key

print '';
print 'Inserting new det. keys...';
print '';

    -- Insert new determinations into the TAXON_DETERMINATION table
    insert into TAXON_DETERMINATION (
        TAXON_DETERMINATION_KEY
        ,TAXON_LIST_ITEM_KEY
        ,TAXON_OCCURRENCE_KEY
        ,VAGUE_DATE_START
        ,VAGUE_DATE_END
        ,VAGUE_DATE_TYPE
        ,COMMENT
        ,PREFERRED
        ,DETERMINER
        ,DETERMINATION_TYPE_KEY
        ,DETERMINER_ROLE_KEY
        ,ENTERED_BY
        ,ENTRY_DATE
    )
    select
        j.taxon_determination_key   -- TAXON_DETERMINATION_KEY
        ,@new_taxon                 -- TAXON_LIST_ITEM_KEY
        ,txd.TAXON_OCCURRENCE_KEY   -- TAXON_OCCURRENCE_KEY
        ,CAST(@date as int) + 1     -- VAGUE_DATE_START
        ,CAST(@date as int) + 1     -- VAGUE_DATE_END
        ,'D'                        -- VAGUE_DATE_TYPE
        ,@determination_comment     -- COMMENT
        ,1                          -- PREFERRED
        ,@new_determiner            -- DETERMINER
        ,@new_det_type              -- DETERMINATION_TYPE_KEY
        ,@new_det_role              -- DETERMINER_ROLE_KEY
        ,@current_user              -- ENTERED_BY
        ,@date                      -- ENTRY_DATE

    from
        #jncc_newdata j
    inner join
        TAXON_DETERMINATION txd on
        j.orig_txd_key = txd.TAXON_DETERMINATION_KEY

    -- Update the VERIFIED flag in the taxon occurrence
    update
        txo
    set
        txo.VERIFIED = dt.Verified
    from
        TAXON_OCCURRENCE txo
    inner join
        TAXON_DETERMINATION txd on
        txo.TAXON_OCCURRENCE_KEY = txd.TAXON_OCCURRENCE_KEY
    inner join
        DETERMINATION_TYPE dt on
        txd.DETERMINATION_TYPE_KEY = dt.DETERMINATION_TYPE_KEY
    inner join
        #jncc_newdata j on
        txd.TAXON_DETERMINATION_KEY = j.taxon_determination_key

    -- Remove the PREFERRED flag from the old determinations
    update
        txd
    set
        PREFERRED = 0
    from
        TAXON_DETERMINATION txd
    inner join
        #jncc_newdata j on
        txd.TAXON_DETERMINATION_KEY = j.orig_txd_key
        
    -- Test changes
    select
        itn.PREFERRED_NAME
        ,itn.COMMON_NAME
        ,txd.*
        ,txo.VERIFIED
    from
        TAXON_DETERMINATION txd
    inner join
        #jncc_newdata j on
        j.taxon_determination_key = txd.TAXON_DETERMINATION_KEY
    inner join
        TAXON_OCCURRENCE txo on
        txd.TAXON_OCCURRENCE_KEY = txo.TAXON_OCCURRENCE_KEY
    inner join
        INDEX_TAXON_NAME itn on
        txd.TAXON_LIST_ITEM_KEY = itn.TAXON_LIST_ITEM_KEY

    select
        itn.PREFERRED_NAME
        ,itn.COMMON_NAME
        ,txd.*
    from
        TAXON_DETERMINATION txd
    inner join
        #jncc_newdata j on
        txd.TAXON_DETERMINATION_KEY = j.orig_txd_key
    inner join
        INDEX_TAXON_NAME itn on
        txd.TAXON_LIST_ITEM_KEY = itn.TAXON_LIST_ITEM_KEY
rollback transaction
