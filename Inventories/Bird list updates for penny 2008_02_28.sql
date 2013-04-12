use nbndata
go

declare @fact_title varchar(100);
set @fact_title = 'Sussex bird contextual';

select distinct
	itnp.taxon_list_item_key,
	itnp.sort_order,
	itnp.preferred_name as [Latin Name],
	case when itnp.preferred_name = itnp.common_name then
		'-'
	else
		itnp.common_name
	end as [Common Name],
	txg.taxon_group_name [Group],
	txf.title [Type],
	txf.taxon_fact_key,
	convert(varchar(max),txf.data) as [Statement]
from
	index_taxon_name as itn
inner join
	index_taxon_name as itnp on
	itnp.taxon_list_item_key = itn.recommended_taxon_list_item_key
inner join
	vw_taxon_group as txg on
	itnp.taxon_list_item_key = txg.taxon_list_item_key
inner join
	taxon_list_item as tli on
	itnp.taxon_list_item_key = tli.taxon_list_item_key
inner join
	taxon_fact as txf on
	tli.taxon_version_key = txf.taxon_version_key
where
	txf.title = @fact_title	and
	itnp.common_name IN (
		'Red-throated Diver',
		'Mediterranean Gull',
		'Mew Gull/Common Gull',
		'Little Grebe',
		'European Shag',
		'Greater Canada Goose',
		'Gadwall',
		'Long-tailed Duck',
		'Common Scoter',
		'Black-necked Grebe',
		'Glossy Ibis',
		'Common Moorhen',
		'Black-winged Stilt',
		'Pectoral Sandpiper',
		'Black-tailed Godwit',
		'Common Redshank',
		'Marsh Sandpiper',
		'Green Sandpiper',
		'Common Sandpiper',
		'Black Tern',
		'Little Auk',
		'Canada Goose',
		'Mew Gull'
	)
order by
	[Common Name]