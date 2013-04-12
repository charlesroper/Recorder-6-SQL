if object_id ('#rsi', 'u') is not null
drop table #rsi;
go

select distinct
	itn2.recommended_taxon_list_item_key
	,itn2.preferred_name as scientific_name
	,case when itn2.preferred_name = itn2.common_name then
		''
	else
		itn2.common_name
	end as [common_name]
	,txg.taxon_group_name
	,itn.sort_order
	,dbo.ufn_GetDesignations(itn2.taxon_list_item_key,1,'THU0000200000001',null) as Designations
into #rsi
from
	index_taxon_designation itd
inner join
	index_taxon_name itn on
	itd.taxon_list_item_key = itn.taxon_list_item_key
inner join
	index_taxon_name itn2 on
	itn.recommended_taxon_list_item_key = itn2.taxon_list_item_key
inner join
	vw_taxon_group txg on
	itd.taxon_list_item_key = txg.taxon_list_item_key
where 
	taxon_designation_type_key = 'THU0000200000138'
order by
	itn.sort_order;
go

select count(*) from #rsi

select distinct
	rsi.scientific_name
	,rsi.common_name
	,rsi.taxon_group_name
	,rsi.sort_order
	,rsi.designations
	,cast(txf.data as varchar(8000)) as [statement]
from 
	#rsi rsi
inner join
	taxon_list_item tli on
	rsi.recommended_taxon_list_item_key = tli.taxon_list_item_key
left outer join
	taxon_fact txf on
	(tli.taxon_version_key = txf.taxon_version_key) and txf.title = 'SxBRC Facts'
--where
--	(txf.title = 'SxBRC Facts') or (txf.title is null)
order by
	sort_order
go

select count(scientific_name) as c, scientific_name
from #stemp group by scientific_name order by c desc

select
	rsi.*
from 
	#rsi rsi
inner join
	taxon_list_item tli on
	rsi.recommended_taxon_list_item_key = tli.taxon_list_item_key