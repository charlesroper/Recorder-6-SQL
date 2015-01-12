use NBNData;

if object_ID('tempdb..#txos_with_count') is not null
    drop table #txos_with_count
    
if object_ID('tempdb..#ranked') is not null
    drop table #ranked

begin transaction

-- Create a temp table (#txos_with_count) that lists all TAXON_OCCURRENCE_KEYS
-- and counts how many times each occurs. A TXOK will get counted more than 
-- once if there is more that one preferred TAXON_DETERMINATION related to it.
    select
        txo.TAXON_OCCURRENCE_KEY
        ,count(txd.TAXON_DETERMINATION_KEY) as txd_count
    into
        #txos_with_count
    from
        TAXON_DETERMINATION txd
    join
        TAXON_OCCURRENCE txo on
        txd.TAXON_OCCURRENCE_KEY = txo.TAXON_OCCURRENCE_KEY
    where
        txd.PREFERRED = 1
    group by
        txo.TAXON_OCCURRENCE_KEY

-- Rank the TAXON_OCCURRENCE_KEYS that have 2 preferred determinations by newest first (desc)
-- then set anthing but the newest as preferred = 0. This update will cascade to the source 
-- tables. In this case, we're setting txd.PREFERRED = 0.
    ;with two_prefs (TAXON_DETERMINATION_KEY, TAXON_OCCURRENCE_KEY, PREF, [RANK]) AS
    (
        select
            txd.TAXON_DETERMINATION_KEY
            ,#txoc.TAXON_OCCURRENCE_KEY
            ,txd.PREFERRED
            ,rank() over (partition by txd.TAXON_OCCURRENCE_KEY order by txd.VAGUE_DATE_START desc) as [rank]
        from
            #txos_with_count #txoc
        inner join
            TAXON_DETERMINATION txd
            on #txoc.taxon_occurrence_key = txd.TAXON_OCCURRENCE_KEY
        where
            #txoc.txd_count > 1
    )
    update two_prefs
    set pref = 0
    where [RANK] > 1;

commit tran