;with cte
  as (select *, ROW_NUMBER() over (PARTITION by 
      [RecordKey]
     order by (select 0)) RN
  FROM [NBNReporting].[dbo].[ALL_NBN])
delete from cte where RN > 1  
GO


