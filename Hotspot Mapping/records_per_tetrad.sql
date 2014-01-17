use NBNData
go

with tetrads_cte (records_per_tetrad, tetrad)
as
(
	select
		count(distinct txo.TAXON_OCCURRENCE_KEY) as records_per_tetrad
		,dbo.LCReturnTetrad(replace(sa.SPATIAL_REF, ' ', ''), sa.SPATIAL_REF_SYSTEM) as tetrad
	from
		TAXON_OCCURRENCE txo
	join
		TAXON_DETERMINATION txd on
		txo.TAXON_OCCURRENCE_KEY = txd.TAXON_OCCURRENCE_KEY and
		txd.PREFERRED = 1
	join
		[SAMPLE] sa on
		txo.SAMPLE_KEY = sa.SAMPLE_KEY
	where
		sa.SPATIAL_REF is not null
	group by
		dbo.LCReturnTetrad(replace(sa.SPATIAL_REF, ' ', ''), sa.SPATIAL_REF_SYSTEM)
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
	records_per_tetrad desc