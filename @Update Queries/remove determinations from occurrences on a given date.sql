use NBNData;

if object_ID('tempdb..#jncc_newdata') is not null
    drop table tempdb..#jncc_newdata

begin transaction


    select
        txd.TAXON_DETERMINATION_KEY
        ,txo.TAXON_OCCURRENCE_KEY
        ,txd.ENTERED_BY
        ,txd.ENTRY_DATE
    into
        #jncc_newdata
    from
        TAXON_DETERMINATION txd
    join
        TAXON_OCCURRENCE txo on
        txd.TAXON_OCCURRENCE_KEY = txo.TAXON_OCCURRENCE_KEY
    where
        (txo.COMMENT NOT LIKE 'gen.%' or txo.COMMENT NOT LIKE 'genitally determined')
        and (txd.TAXON_LIST_ITEM_KEY = 'NHMSYS0000495136')
        --and (txd.PREFERRED = 1)
        and (convert(date,txd.ENTRY_DATE) = '2012-05-25')
        
    select *
    from
        #jncc_newdata
        
    select *
    from TAXON_DETERMINATION txd
    where txd.TAXON_OCCURRENCE_KEY in (select TAXON_OCCURRENCE_KEY from #jncc_newdata)
    and txd.ENTRY_DATE != (select MAX(txd.entry_date) from TAXON_DETERMINATION txd join #jncc_newdata j on txd.taxon_occurrence_key = j.taxon_occurrence_key );
    
    -- Need to fix this: it will mark multiple determinations
    update TAXON_DETERMINATION
    set preferred = 1
    from TAXON_DETERMINATION txd
    where txd.TAXON_OCCURRENCE_KEY in (select TAXON_OCCURRENCE_KEY from #jncc_newdata)
    and txd.ENTRY_DATE != (select MAX(txd.entry_date) from TAXON_DETERMINATION txd join #jncc_newdata j on txd.taxon_occurrence_key = j.taxon_occurrence_key );

    update TAXON_DETERMINATION
    set preferred = 0
    from TAXON_DETERMINATION txd
    where txd.TAXON_OCCURRENCE_KEY in (select TAXON_OCCURRENCE_KEY from #jncc_newdata)
    and txd.ENTRY_DATE = (select MAX(txd.entry_date) from TAXON_DETERMINATION txd join #jncc_newdata j on txd.taxon_occurrence_key = j.taxon_occurrence_key );
    
    delete from TAXON_DETERMINATION 
    where TAXON_OCCURRENCE_KEY in (select TAXON_OCCURRENCE_KEY from #jncc_newdata)
    and PREFERRED = 0
    
    select *
    from TAXON_DETERMINATION txd
    where txd.TAXON_OCCURRENCE_KEY in (select TAXON_OCCURRENCE_KEY from #jncc_newdata)
    
        
commit tran