set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[LCWorkOutValue]
(@INCHAR as varchar(10))
RETURNS int

--
--	DESCRIPTION
--	Function to return a value for field which may contain charcters and nulls-	
--
--	PARAMETERS
--	NAME				DESCRIPTION
--	
--
--
--	AUTHOR:	Mike Weideli
--	CREATED: 08/12/2005
--	UPDATED BY: Charles Roper on 5/5/2006

AS
BEGIN

DECLARE @RVALUE INT
SET @RVALUE = 0
IF (ISNUMERIC(@INCHAR)) = 1
BEGIN
	IF PATINDEX('%[0-9]%', @INCHAR) <> 1 BEGIN
		SET @RVALUE = ''
	END ELSE
		SET @RVALUE = CAST(FLOOR(@INCHAR) AS INT)
	END
	RETURN @RVALUE
END