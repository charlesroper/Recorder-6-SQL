use nbndata
go

declare @designation_type varchar(16);
set @designation_type = 'THU0000200000139'; -- 'Sx PSR'

select 
  [Latin Name]
  ,[Common Name]
  ,[Group]
  ,[Inventory]
  ,MIN([Statement]) as [Statement]
  ,SORT_ORDER

from (
  
  select distinct
    itnp.taxon_list_item_key,
	  itnp.sort_order,
	  itnp.preferred_name as [Latin Name],
	  case when itnp.preferred_name = itnp.common_name then
		  '-'
	  else
		  itnp.common_name
	  end as [Common Name],
	  txg.taxon_group_name as [Group],
	  convert(varchar(max),txd.detail) as [Inventory],
	  dbo.ufn_TrimWhiteSpaces(convert(varchar(max),txf.data)) as [Statement]
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
  inner join
    TAXON_DESIGNATION as txd on
    itn.TAXON_LIST_ITEM_KEY = txd.TAXON_LIST_ITEM_KEY and
    txf.TITLE = 'SxBRC Facts'
  where
	  txd.TAXON_DESIGNATION_TYPE_KEY = @designation_type and
	  convert(varchar(max),txd.detail) = 'PSR' and
	  itnp.preferred_list = '1'
 
 ) as PSRList

group by
  [Latin Name]
  ,[Common Name]
  ,[Group]
  ,[Inventory]
  ,SORT_ORDER
    
order by
  SORT_ORDER
