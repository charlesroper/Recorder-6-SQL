USE [NBNData]
GO

/****** Object:  UserDefinedFunction [dbo].[FormatLocation]    Script Date: 03/29/2012 16:57:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Charles Roper, Sussex Biodiversity Record Centre, charles.roper@sxbrc.org.uk
-- Description:	Concatenates the Location and Location Name of a Sample in a sensible way.
-- =============================================
CREATE FUNCTION [dbo].[FormatLocation]
(
	@sample_key   char(16)
)
RETURNS varchar(1000)
AS
BEGIN
	DECLARE @result_var as varchar(1000)

	SELECT @result_var =
		CASE
		WHEN SA.LOCATION_NAME IS NOT NULL AND LN.ITEM_NAME IS NOT NULL THEN
			CASE
			WHEN SA.LOCATION_NAME = LN.ITEM_NAME THEN
				LN.ITEM_NAME
			WHEN LTRIM(RTRIM(SA.LOCATION_NAME)) = '' THEN
				LN.ITEM_NAME
			ELSE
				LN.ITEM_NAME + ': ' + SA.LOCATION_NAME
			END
		WHEN SA.LOCATION_NAME IS NULL AND LN.ITEM_NAME IS NOT NULL THEN
			LN.ITEM_NAME
		ELSE
			SA.LOCATION_NAME
		END
	FROM
		SAMPLE sa
	FULL JOIN
		LOCATION_NAME ln on
		sa.LOCATION_KEY = ln.LOCATION_KEY
	WHERE
		sa.SAMPLE_KEY = @sample_key
		AND (ln.PREFERRED IS NULL OR ln.PREFERRED = 1)

	RETURN @result_var

END

GO

