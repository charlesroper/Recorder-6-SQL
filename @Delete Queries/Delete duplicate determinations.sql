use NBNData;

begin tran
    
    delete from TAXON_DETERMINATION
    where TAXON_DETERMINATION_KEY NOT IN
    (
        select MIN(taxon_determination_key)
        from TAXON_DETERMINATION txd
        group by
        txd.TAXON_OCCURRENCE_KEY
        ,txd.TAXON_LIST_ITEM_KEY
        ,txd.DETERMINER
        ,txd.DETERMINATION_TYPE_KEY
        ,txd.VAGUE_DATE_START
    ) 
    and PREFERRED != 1 

commit tran