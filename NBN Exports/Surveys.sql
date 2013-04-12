use NBNData;
select
   SurveyKey  = s.SURVEY_KEY
  ,SurveyName = dbo.ufn_TrimWhiteSpaces(s.ITEM_NAME)
from
  SURVEY s
left join
  Survey_Tag st on
  s.SURVEY_KEY = st.Survey_Key
left join
  Concept c on
  st.Concept_Key = c.Concept_Key
left join
  Term on
  c.Term_Key = Term.Term_Key
where
  Term.Item_Name not like '[_][_]%' -- Exclude anything that begins with two underscores
order by
  SurveyKey;
