use NBNData
go

with tetrads_cte (species_per_tetrad, tetrad)
as
(
	select
		count(distinct txd.TAXON_LIST_ITEM_KEY)
		,dbo.LCReturnTetrad(sa.SPATIAL_REF, sa.SPATIAL_REF_SYSTEM) as tetrad
	from
		VW_TAXON_GROUP txg
	join
		TAXON_DETERMINATION txd on
		txg.TAXON_LIST_ITEM_KEY = txd.TAXON_LIST_ITEM_KEY and
		txd.PREFERRED = 1
	join
		TAXON_OCCURRENCE txo on
		txo.TAXON_OCCURRENCE_KEY = txd.TAXON_OCCURRENCE_KEY
	join
		[SAMPLE] sa on
		txo.SAMPLE_KEY = sa.SAMPLE_KEY
	group by
		dbo.LCReturnTetrad(sa.SPATIAL_REF, sa.SPATIAL_REF_SYSTEM)
)
select
	*
	,dbo.LCReturnEastingsV2(tetrad, 'OSGB', 1)   as x
	,dbo.LCReturnNorthingsV2(tetrad, 'OSGB', 1)  as y
from
	tetrads_cte
where
	tetrad != ''
order by
	species_per_tetrad desc