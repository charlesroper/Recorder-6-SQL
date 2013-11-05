use NBNData;
select
   SurveyKey  = s.SURVEY_KEY
  ,SurveyTag = Term.Item_Name
  ,SurveyName = dbo.ufn_TrimWhiteSpaces(s.ITEM_NAME)
from
  SURVEY s
join
  survey_tag stag
  on s.SURVEY_KEY = stag.Survey_Key
join
  Concept c
  on stag.Concept_Key = c.Concept_Key
join
  Term
  on c.Term_Key = Term.Term_Key
where
  dbo.ufn_TrimWhiteSpaces(Term.Item_Name) like '[_][_]%' -- Exclude anything that begins with two underscores
  or dbo.ufn_TrimWhiteSpaces(s.ITEM_NAME) like '[_][_]%'
  or stag.Concept_Key in (
    'THU0000200000013'  -- Francis Rose
    ,'THU000020000000I' -- Patrick Roper
    )
order by
  SurveyTag, SurveyName;