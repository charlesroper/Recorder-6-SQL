use NBNData;
select
   SurveyKey  = s.SURVEY_KEY
  ,SurveyName = dbo.ufn_TrimWhiteSpaces(s.ITEM_NAME)
  --,SurveyTag = Term.Item_Name
  --,ConceptKey = stag.Concept_Key
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
  dbo.ufn_TrimWhiteSpaces(Term.Item_Name) not like '[_][_]%' -- Exclude anything that begins with two underscores
  and dbo.ufn_TrimWhiteSpaces(s.ITEM_NAME) not like '[_][_]%'
  and stag.Concept_Key not in (
    'THU0000200000013'  -- Francis Rose
    ,'THU000020000000I' -- Patrick Roper
    )
order by
  SurveyName;
