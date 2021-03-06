set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
USE NBNData
GO

/**
 *  Takes a date in the format dd/mm/yyyy and returns the number used in Recorder 6
 *  Mike Weideli  15 October 2005
 *
**/

CREATE FUNCTION [dbo].[LCToRataDie]
(@DateString varchar(10))
RETURNS int
AS
BEGIN

DECLARE @RD INT
DECLARE @Y INT
DECLARE @M INT
DECLARE @D INT
DECLARE @A INT
SET @Y = CAST(SUBSTRING(@DATESTRING,7,4) AS INT)
SET @M = CAST(SUBSTRING(@DATESTRING,4,2) AS INT)
SET @D = CAST(SUBSTRING(@DATESTRING,1,2) AS INT)

IF @M < 3
BEGIN 
	SET @M = @M + 12 
	SET @Y = @Y - 1 
END 

SET @A  = 153 * @M - 457
SET @RD = @D + @A/5 + 365 * @Y + @Y / 4 - @Y / 100 + @Y / 400 - 306
SET @RD = @RD - 693594 

RETURN @RD

RETURN ''

END

