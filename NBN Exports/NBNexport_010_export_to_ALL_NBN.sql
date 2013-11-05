use NBNData;

IF OBJECT_ID('NBNReporting.dbo.ALL_NBN', 'U') IS NOT NULL
  DROP TABLE NBNReporting.dbo.ALL_NBN;

select distinct
  RecordKey =
    txo.TAXON_OCCURRENCE_KEY

  ,TaxonVersionKey =
    tli.TAXON_VERSION_KEY

  ,SurveyKey =
    se.SURVEY_KEY

  ,SampleKey =
    sa.SAMPLE_KEY

  ,StartDate =
    dbo.LCReturnDateShort(sa.VAGUE_DATE_START, sa.VAGUE_DATE_TYPE, 'f')

  ,EndDate =
    dbo.LCReturnDateShort(sa.VAGUE_DATE_END, sa.VAGUE_DATE_TYPE, 'f')

  ,DateType =
    sa.VAGUE_DATE_TYPE

  ,GridReference =
    sa.SPATIAL_REF

  ,Projection =
    sa.SPATIAL_REF_SYSTEM

  ,[Precision] =
    CASE sa.SPATIAL_REF_SYSTEM
    WHEN 'OSGB' THEN
      CASE LEN(sa.SPATIAL_REF)
        WHEN 4 THEN 10000
        WHEN 5 THEN 2000
        WHEN 6 THEN 1000
        WHEN 8 THEN 100
        WHEN 10 THEN 10
        ELSE 1 END
    WHEN 'OSNI' THEN
      CASE LEN(sa.SPATIAL_REF)
        WHEN 3 THEN 10000
        WHEN 4 THEN 2000
        WHEN 5 THEN 1000
        WHEN 7 THEN 100
        WHEN 9 THEN 10
        ELSE 1
      END
    END

  ,X = dbo.LCReturnEastings(sa.SPATIAL_REF, sa.SPATIAL_REF_SYSTEM)
  ,Y = dbo.LCReturnNorthings(sa.SPATIAL_REF, sa.SPATIAL_REF_SYSTEM)

  ,Sensitive =
    CASE CONFIDENTIAL
      WHEN 1 THEN 'T'
      ELSE 'F'
    END

  ,ZeroAbundance =
    CASE ZERO_ABUNDANCE
      WHEN 1 THEN 'T'
      ELSE 'F'
    END

  ,SiteKey =
    ISNULL(sa.LOCATION_KEY, '')

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
    ISNULL(dbo.ufn_RtfToPlaintext(CAST(txo.COMMENT AS VARCHAR(8000))), '')

into
  NBNReporting.dbo.ALL_NBN

from
  TAXON_OCCURRENCE txo

inner join
  TAXON_DETERMINATION txd
  on txo.TAXON_OCCURRENCE_KEY = txd.TAXON_OCCURRENCE_KEY

inner join
  DETERMINATION_TYPE dt
  on txd.DETERMINATION_TYPE_KEY = dt.DETERMINATION_TYPE_KEY

inner join
  TAXON_LIST_ITEM tli
  on txd.TAXON_LIST_ITEM_KEY = tli.TAXON_LIST_ITEM_KEY

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

where
  txd.PREFERRED = 1
  and txo.CHECKED = 1
  and dt.Verified != 1
  and sa.SPATIAL_REF is not null
  and sa.SPATIAL_REF_SYSTEM = 'OSGB'
  and sa.VAGUE_DATE_TYPE != 'U'
  and (ln.PREFERRED IS NULL OR ln.PREFERRED = 1)
  and txo.CONFIDENTIAL = 0
  -- Excludes
  and dbo.ufn_TrimWhiteSpaces(Term.Item_Name) not like '[_][_]%' -- Exclude anything that begins with two underscores
  and dbo.ufn_TrimWhiteSpaces(s.ITEM_NAME) not like '[_][_]%'
  and stag.Concept_Key not in (
    'THU0000200000013'  -- Francis Rose
    ,'THU000020000000I' -- Patrick Roper
    )
