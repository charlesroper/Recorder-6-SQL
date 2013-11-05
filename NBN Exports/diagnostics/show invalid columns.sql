Use NBNReporting;
select
  MIN(LEN(a.GridReference)) as GridRefMin
  ,case when MIN(LEN(a.GridReference)) <= 2 then 'INVALID' else 'Valid' end as GridRefValid
  
  ,MIN(a.StartDate) as DateMin
  ,case when MIN(a.StartDate) != '' then 'INVALID' else 'Valid' end as DateStartValid

  ,MAX(LEN(a.Recorder)) as RecorderMax
  ,case when MAX(LEN(a.Recorder)) > 140 then 'INVALID' else 'Valid' end as RecorderValid
  
  ,MAX(LEN(a.SiteName)) as SiteNameMax
  ,case when MAX(LEN(a.SiteName)) > 100 then 'INVALID' else 'Valid' end as SiteNameValid

  ,MAX(LEN(a.Abundance)) as AbundanceMax
  ,case when MAX(LEN(a.Abundance)) > 255 then 'INVALID' else 'Valid' end as AbundanceValid

  ,MAX(LEN(a.Comment)) as CommentMax
  ,case when MAX(LEN(a.Comment)) > 255 then 'INVALID' else 'Valid' end as CommentValid

  ,(select top 1 Comment from ALL_NBN
      where Comment like '%' + char(13) + '%'
      or Comment like '%' + char(10) + '%') as CommentCRLF
  ,case when (
      select Comment from ALL_NBN
      where Comment like '%' + char(13) + '%'
      or Comment like '%' + char(10) + '%'
    ) is not null then 'INVALID' else 'Valid' end as CommentCRLFValid 

from
  ALL_NBN a
