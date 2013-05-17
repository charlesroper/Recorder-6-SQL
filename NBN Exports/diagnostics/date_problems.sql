use NBNData;
select 
  txo.TAXON_OCCURRENCE_KEY
  ,sa.VAGUE_DATE_START
  ,sa.VAGUE_DATE_END
  ,sa.VAGUE_DATE_TYPE
  ,rendered_date  = dbo.LCReturnVagueDateShort(sa.VAGUE_DATE_START, sa.VAGUE_DATE_END, sa.VAGUE_DATE_TYPE)
from
  TAXON_OCCURRENCE txo
inner join
  SAMPLE sa
  on txo.SAMPLE_KEY = sa.SAMPLE_KEY
where
  sa.VAGUE_DATE_TYPE = '-Y'
  --txo.TAXON_OCCURRENCE_KEY in
  --(
  --   'THU000020001JWXI'
  --  ,'THU000020000DPG8'
  --  ,'THU000890000008P'
  --  ,'THU00089000000XW'
  --  ,'THU000890000015X'
  --  ,'THU000890000015Y'
  --  ,'THU000890000015Z'
  --  ,'THU0008900000160'
  --  ,'THU0008900000161'
  --  ,'THU0008900000162'
  --  ,'THU0008900000163'
  --  ,'THU0008900000164'
  --  ,'THU0008900000165'
  --  ,'THU0008900000166'
  --  ,'THU0008900000167'
  --  ,'THU0008900000168'
  --  ,'THU0008900000169'
  --  ,'THU000890000016A'
  --  ,'THU000890000016B'
  --  ,'THU000890000016C'
  --  ,'THU000890000016D'
  --  ,'THU000890000016E'
  --  ,'THU000890000016F'
  --  ,'THU000890000016G'
  --  ,'THU000890000016H'
  --  ,'THU000890000016J'
  --  ,'THU000890000016K'
  --  ,'THU000890000016L'
  --  ,'THU000890000016M'
  --  ,'THU000890000016N'
  --  ,'THU000890000016O'
  --  ,'THU000890000016P'
  --  ,'THU000890000016Q'
  --  ,'THU000890000016R'
  --  ,'THU000890000016S'
  --  ,'THU000890000016T'
  --  ,'THU000890000016U'
  --  ,'THU000890000016V'
  --  ,'THU000890000016W'
  --  ,'THU000890000016X'
  --  ,'THU00089000001JP'
  --  ,'THU00089000001JQ'
  --  ,'THU00089000001JR'
  --  ,'THU00089000001JS'
  --  ,'THU00089000001JT'
  --  ,'THU000890000008O'
  --)
  order by
    VAGUE_DATE_START desc;