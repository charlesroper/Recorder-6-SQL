use nbndata;
select
	count(dbo.LCReturnTetrad(sa.spatial_ref, sa.spatial_ref_system)) as recs
	,dbo.LCReturnTetrad(
		replace(sa.spatial_ref, ' ', ''), sa.spatial_ref_system) as tetrad
	,dbo.LCReturnNorthings_c(dbo.LCReturnTetrad(
		replace(sa.spatial_ref, ' ', ''), sa.spatial_ref_system),sa.spatial_ref_system) as y
	,dbo.LCReturnEastings_c(dbo.LCReturnTetrad(
		replace(sa.spatial_ref, ' ', ''), sa.spatial_ref_system),sa.spatial_ref_system) as x
from
	sample sa
where
	replace(sa.spatial_ref, ' ', '') is not null and
	len(replace(sa.spatial_ref, ' ', '')) > 4
group by
	dbo.LCReturnTetrad(
		replace(sa.spatial_ref, ' ', ''), sa.spatial_ref_system),
	dbo.LCReturnNorthings_c(
		dbo.LCReturnTetrad(
			replace(sa.spatial_ref, ' ', ''), sa.spatial_ref_system),
				sa.spatial_ref_system),
	dbo.LCReturnEastings_c(
			dbo.LCReturnTetrad(
				replace(sa.spatial_ref, ' ', ''), sa.spatial_ref_system),
					sa.spatial_ref_system)

