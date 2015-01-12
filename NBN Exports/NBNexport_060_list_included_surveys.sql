use NBNData;
select distinct
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
join
  -- ALL
  --NBNReporting.dbo.ALL_NBN_clipped as n
  --on s.SURVEY_KEY = n.SurveyKey

  -- 2014-03-14 to 2014-10-10
  NBNReporting.dbo.ALL_NBN_140314_141010 as n
  on s.SURVEY_KEY = n.SurveyKey
  
order by
  SurveyName;
