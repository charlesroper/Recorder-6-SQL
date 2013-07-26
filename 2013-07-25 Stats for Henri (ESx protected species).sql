use NBNData
go

IF object_ID('NBNReporting.dbo.StatsForHenri_protected') IS NOT NULL
	DROP TABLE NBNReporting.dbo.StatsForHenri_protected

select distinct
  ROWID = identity(int,1,1)
	,SCI_NAME = itnr.PREFERRED_NAME
	,COM_NAME = case 
	  when itnr.PREFERRED_NAME = itnr.COMMON_NAME then
		  txg.TAXON_GROUP_NAME
	  else
		  itnr.COMMON_NAME
	  end -- [COM_NAME]
	,txg.TAXON_GROUP_NAME
	,tds.Title
  ,txg.SORT_ORDER
  ,X = dbo.LCReturnEastings_c(REPLACE(SA.SPATIAL_REF, ' ', ''), SA.SPATIAL_REF_SYSTEM)
	,Y = dbo.LCReturnNorthings_c(REPLACE(SA.SPATIAL_REF, ' ', ''), SA.SPATIAL_REF_SYSTEM)
into NBNReporting.dbo.StatsForHenri_protected
from
	INDEX_TAXON_NAME itn
join
	INDEX_TAXON_NAME itnr ON
	itn.RECOMMENDED_TAXON_LIST_ITEM_KEY = itnr.TAXON_LIST_ITEM_KEY
join
  TAXON_DETERMINATION txd on
  itn.TAXON_LIST_ITEM_KEY = txd.TAXON_LIST_ITEM_KEY
join
  TAXON_OCCURRENCE txo on
  txd.TAXON_OCCURRENCE_KEY = txo.TAXON_OCCURRENCE_KEY
join
  SAMPLE sa on
  txo.SAMPLE_KEY = sa.SAMPLE_KEY
join
  VW_TAXON_GROUP txg on
  txd.TAXON_LIST_ITEM_KEY = txg.TAXON_LIST_ITEM_KEY
left join
  VW_DESIGNATIONS d on
  itnr.TAXON_LIST_ITEM_KEY = d.TAXON_LIST_ITEM_KEY
join
  Taxon_Designation_Set_Item tdsi on
  d.TAXON_DESIGNATION_TYPE_KEY = tdsi.Taxon_Designation_Type_Key
join
  Taxon_Designation_Set tds on
  tdsi.Taxon_Designation_Set_Key = tds.Taxon_Designation_Set_Key
where
  tds.Taxon_Designation_Set_Key = 'SYSTEM0000000002' -- All Legally Protected
  or tds.Taxon_Designation_Set_Key = 'SYSTEM0000000005' -- BAP (2007)