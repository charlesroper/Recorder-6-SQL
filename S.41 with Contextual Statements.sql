use NBNData;

/*

  TODO:

  - Some contextuals aren't appearing. Need to do a taxon 
    expansion an bring in the fact where it exists.
  
  - Try Curlew (Numenius arquata). Example record is:
    THU0000200030OS9.

*/

with s41
as
(
select distinct --top 1000
  RecordKey =
    txo.TAXON_OCCURRENCE_KEY

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

  ,[Date] =
    dbo.LCReturnVagueDateShort(sa.VAGUE_DATE_START, sa.VAGUE_DATE_END, sa.VAGUE_DATE_TYPE)

  ,GridReference =
    replace(sa.SPATIAL_REF, ' ', '')

  ,Confidential =
    CASE CONFIDENTIAL
      WHEN 1 THEN 'T'
      ELSE 'F'
    END

  ,SiteName =
    ISNULL(dbo.FormatLocation(sa.SAMPLE_KEY), '')

  ,SampleMethod =
    st.SHORT_NAME

  ,Recorder =
    dbo.FormatEventRecorders(sa.SAMPLE_KEY)

  ,Determiner =
    dbo.ufn_GetFormattedName(txd.DETERMINER)

  ,Abundance =
    ISNULL(dbo.LCFormatAbundanceData(txo.TAXON_OCCURRENCE_KEY), '')

  ,Comment =
	case 
	  when LEN(ISNULL(dbo.ufn_RtfToPlaintext(dbo.ufn_TrimWhiteSpaces(CAST(txo.COMMENT as varchar(max)))), '')) < 2 then ''
	  else ISNULL(dbo.ufn_RtfToPlaintext(dbo.ufn_TrimWhiteSpaces(CAST(txo.COMMENT as varchar(max)))), '')
	end	  

  ,Designation =
    txdt.SHORT_NAME

  ,Contextual =
    isnull(dbo.ufn_TrimWhiteSpaces(cast(txf.DATA as varchar(max))), '')

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
  and txf.TITLE = 'SxBRC Facts'

inner join
  [sample] sa
  on txo.SAMPLE_KEY = sa.SAMPLE_KEY

inner join
  SURVEY_EVENT se
  on sa.SURVEY_EVENT_KEY = se.SURVEY_EVENT_KEY

inner join
  SURVEY s
  on se.SURVEY_KEY = s.SURVEY_KEY

left join
  survey_tag stag
  on s.SURVEY_KEY = stag.Survey_Key

left join
  Concept c
  on stag.Concept_Key = c.Concept_Key

left join
  Term
  on c.Term_Key = Term.Term_Key

inner join
  SAMPLE_TYPE st
  on  sa.SAMPLE_TYPE_KEY = st.SAMPLE_TYPE_KEY

left outer join
  LOCATION_NAME ln
  on sa.LOCATION_KEY = ln.LOCATION_KEY

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
  and dt.Verified != 1
  and sa.SPATIAL_REF is not null
  and sa.SPATIAL_REF_SYSTEM = 'OSGB'
  and sa.VAGUE_DATE_TYPE != 'U'
  and (ln.PREFERRED IS NULL OR ln.PREFERRED = 1)
  and txo.CONFIDENTIAL = 0
  and txdt.TAXON_DESIGNATION_TYPE_KEY = 'NBNSYS0100000013'
  --and (txf.TITLE = 'SxBRC Facts' or txf.TITLE is null)
  --and itn.TAXON_LIST_ITEM_KEY = 'NHMSYS0000332699'
  --and itn.PREFERRED_NAME = 'Sciurus vulgaris'
  --and txo.TAXON_OCCURRENCE_KEY = 'THU0000200009GL9'

  -- Excludes
  -- and dbo.ufn_TrimWhiteSpaces(Term.Item_Name) not like '[_][_]%' -- Exclude anything that begins with two underscores
  -- and dbo.ufn_TrimWhiteSpaces(s.ITEM_NAME) not like '[_][_]%'
)
select
  RecordKey
  ,SortOrder
  ,ScientificName
  ,CommonName
  ,TaxonGroup
  ,Date
  ,GridReference
  ,Confidential
  ,SiteName
  ,SampleMethod
  ,Recorder
  ,Determiner
  ,Abundance
  ,Comment
  ,Designation
  ,Contextual = max(Contextual)
from
  s41
group by
  RecordKey
  ,SortOrder
  ,ScientificName
  ,CommonName
  ,TaxonGroup
  ,Date
  ,GridReference
  ,Confidential
  ,SiteName
  ,SampleMethod
  ,Recorder
  ,Determiner
  ,Abundance
  ,Comment
  ,Designation
order by
  SortOrder