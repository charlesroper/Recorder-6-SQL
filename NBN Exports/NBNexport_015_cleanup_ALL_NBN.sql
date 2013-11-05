use NBNReporting;

begin tran

-- Delete any 100km records
delete from ALL_NBN
output deleted.*
where LEN(GridReference) <= 2;

-- 1. Set -Y start dates to '' (an empty string)
update ALL_NBN
set StartDate = ''
output inserted.StartDate, inserted.EndDate, inserted.DateType
where DateType = '-Y'

-- 2. Truncate SiteName that are >100 and put ... on the end
update ALL_NBN
set SiteName = LEFT(SiteName, 100-3) + '...'
output inserted.SiteName
where LEN(SiteName) > 100;

-- Truncate Abundance> 255 and put ... on the end
update ALL_NBN
set Abundance = LEFT(Abundance, 255-3) + '...'
output inserted.Abundance
where LEN(Abundance) > 255;

-- Truncate Recorder > 140
update ALL_NBN
set Recorder = LEFT(Recorder, 140-3) + '...'
output inserted.Recorder
where LEN(Recorder) > 140;

-- Remove carriage returns and line feeds from Commennts
update ALL_NBN
set Comment = REPLACE(REPLACE(Comment, char(13), ''), char(10), '')
output inserted.Comment
where Comment like '%' + char(13) + '%'
or Comment like '%' + char(10) + '%'

-- Truncate all Comments > 255 and put ... on the end
update ALL_NBN
set Comment = LEFT(Comment, 255-3) + '...'
output inserted.Comment
where LEN(Comment) > 255;

commit tran