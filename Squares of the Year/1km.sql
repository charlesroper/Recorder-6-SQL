Use NBNData;

if object_ID('NBNReporting.dbo._temp_SOTY') is not null
	drop table NBNReporting.dbo._temp_SOTY;

select distinct --top 100
	rowid = identity(int,1,1)
	,spatial_ref
	,dbo.FormatGridRef(spatial_ref,spatial_ref_system,1) as [1km]
	,dbo.LCReturnECentre1Km(spatial_ref,'OSGB') as X
	,dbo.LCReturnNCentre1Km(spatial_ref,'OSGB') as Y
	,taxon_group_name
into
	NBNReporting.dbo._temp_SOTY
from
	sample sa
inner join
	taxon_occurrence txo on
	sa.sample_key = txo.sample_key
inner join
	taxon_determination txd on
	txo.taxon_occurrence_key = txd.taxon_occurrence_key
inner join
	vw_taxon_group txg on
	txd.taxon_list_item_key = txg.taxon_list_item_key
where
	len(spatial_ref) >= 6
	--and txd.preferred = 1
	--and taxon_group_name != 'bird';

use NBNReporting;

alter table _temp_SOTY
add primary key (rowid)