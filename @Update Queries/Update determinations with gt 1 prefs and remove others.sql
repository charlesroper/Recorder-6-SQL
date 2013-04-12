use NBNData;

if object_ID('tempdb..#jncc_newdata') is not null
    drop table tempdb..#jncc_newdata
    
if object_ID('tempdb..#ranked') is not null
    drop table tempdb..#ranked

begin transaction

    select
        txo.TAXON_OCCURRENCE_KEY
        ,count(txd.TAXON_DETERMINATION_KEY) as txd_count
    into
        #jncc_newdata
    from
        TAXON_DETERMINATION txd
    join
        TAXON_OCCURRENCE txo on
        txd.TAXON_OCCURRENCE_KEY = txo.TAXON_OCCURRENCE_KEY
    where
        txd.PREFERRED = 1
    group by
        txo.TAXON_OCCURRENCE_KEY
        
    ;with two_prefs (TAXON_DETERMINATION_KEY, TAXON_OCCURRENCE_KEY, PREF, [RANK]) AS
    (
        select
            txd.TAXON_DETERMINATION_KEY
            ,jn.TAXON_OCCURRENCE_KEY
            ,txd.PREFERRED
            ,rank() over (partition by txd.TAXON_OCCURRENCE_KEY order by txd.VAGUE_DATE_START desc) as [rank]
        from
            #jncc_newdata jn
        inner join
            TAXON_DETERMINATION txd
            on jn.taxon_occurrence_key = txd.TAXON_OCCURRENCE_KEY
        where
            jn.txd_count > 1
    )
    update two_prefs
    set pref = 0
    where [RANK] > 1;

    select
        txd.TAXON_DETERMINATION_KEY
        ,jn.TAXON_OCCURRENCE_KEY
        ,txd.PREFERRED
        ,txd.ENTRY_DATE
        ,txd.VAGUE_DATE_START
        ,rank() over (partition by txd.TAXON_OCCURRENCE_KEY order by txd.VAGUE_DATE_START desc) as [rank]
    into #ranked
    from
        #jncc_newdata jn
    inner join
        TAXON_DETERMINATION txd
        on jn.taxon_occurrence_key = txd.TAXON_OCCURRENCE_KEY
    where
        jn.txd_count > 1
        
        
    -- use another cte to remove the preferred status from row != 1
    ;with cte (row, txo_key, txd_key, pref) as
    (
    select 
        row_number() over(partition by taxon_occurrence_key order by rank asc) as row
        ,taxon_occurrence_key
        ,taxon_determination_key
        ,preferred
    from #ranked
    )
    update TAXON_DETERMINATION
    set PREFERRED = 0
    from TAXON_DETERMINATION txd
    join cte
    on txd.TAXON_DETERMINATION_KEY = cte.txd_key
    where cte.row != 1
    
    ;with cte (row, txo_key, txd_key, pref) as
    (
    select 
        row_number() over(partition by taxon_occurrence_key order by rank asc) as row
        ,taxon_occurrence_key
        ,taxon_determination_key
        ,preferred
    from #ranked
    )
    select * 
    from cte
    join TAXON_DETERMINATION txd 
    on cte.txd_key = txd.TAXON_DETERMINATION_KEY
    where row != 1
      
rollback tran