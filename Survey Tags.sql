select
  s.ITEM_NAME
  ,t.Item_Name
  ,st.Survey_Tag_Key
from
  SURVEY s
left join
  Survey_Tag st on
  s.SURVEY_KEY = st.Survey_Key
left join
  Concept c on
  st.Concept_Key = c.Concept_Key
left join
  Term t on
  c.Term_Key = t.Term_Key
where
  t.Item_Name like '%[_][_]%' -- anything beginning with two underscores