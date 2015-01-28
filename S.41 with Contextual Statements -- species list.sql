use NBNData;

select distinct
  RecordCount =
    count(txo.TAXON_OCCURRENCE_KEY)

  ,SortOrder =
    itn2.SORT_ORDER

  ,ScientificName =
  itn2.PREFERRED_NAME

  ,CommonName =
  case
    when itn2.COMMON_NAME = itn2.PREFERRED_NAME then ''
    else itn2.COMMON_NAME
  end

  ,TaxonGroup =
    txg.TAXON_GROUP_NAME

  ,Contextual = 
    max(isnull(dbo.ufn_TrimWhiteSpaces(cast(txf.DATA as varchar(max))), ''))

  ,Designation =
    txdt.SHORT_NAME

from
  TAXON_OCCURRENCE txo

inner join
  TAXON_DETERMINATION txd
  on txo.TAXON_OCCURRENCE_KEY = txd.TAXON_OCCURRENCE_KEY

inner join
  DETERMINATION_TYPE dt
  on txd.DETERMINATION_TYPE_KEY = dt.DETERMINATION_TYPE_KEY

inner join
  INDEX_TAXON_NAME itn
  on txd.TAXON_LIST_ITEM_KEY = itn.TAXON_LIST_ITEM_KEY

inner join
  INDEX_TAXON_NAME itn2
  on itn.RECOMMENDED_TAXON_LIST_ITEM_KEY = itn2.TAXON_LIST_ITEM_KEY

inner join
  TAXON_LIST_ITEM tli
  on txd.TAXON_LIST_ITEM_KEY = tli.TAXON_LIST_ITEM_KEY

left outer join
  TAXON_FACT txf
  on tli.TAXON_VERSION_KEY = txf.TAXON_VERSION_KEY

inner join
  [sample] sa
  on txo.SAMPLE_KEY = sa.SAMPLE_KEY

inner join
  Index_Taxon_Designation itd
  on txd.TAXON_LIST_ITEM_KEY = itd.Taxon_List_Item_Key

inner join
  TAXON_DESIGNATION_TYPE txdt
  on itd.Taxon_Designation_Type_Key = txdt.TAXON_DESIGNATION_TYPE_KEY

inner join
  VW_TAXON_GROUP txg
  on itn2.TAXON_LIST_ITEM_KEY = txg.TAXON_LIST_ITEM_KEY

where
  txd.PREFERRED = 1
  and txo.CHECKED = 1
  and txo.ZERO_ABUNDANCE = 0
  and dt.Verified != 1
  and sa.SPATIAL_REF is not null
  and sa.SPATIAL_REF_SYSTEM = 'OSGB'
  and sa.VAGUE_DATE_TYPE != 'U'
  and txo.CONFIDENTIAL = 0
  and (txf.TITLE = 'SxBRC Facts' or txf.TITLE is null)
  and txdt.TAXON_DESIGNATION_TYPE_KEY = 'NBNSYS0100000013' -- NERC S.41

group by
  itn2.PREFERRED_NAME
  ,case
    when itn2.COMMON_NAME = itn2.PREFERRED_NAME then ''
    else itn2.COMMON_NAME
  end
  ,txg.TAXON_GROUP_NAME
  ,txdt.SHORT_NAME
  ,itn2.SORT_ORDER

order by
  itn2.SORT_ORDER
