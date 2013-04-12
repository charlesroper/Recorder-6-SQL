SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

/*
*
* ***************** Version 2.5 *****************
* Original Author: Mike Weidlei
* Update by Charles Roper (centering functionality)
* Returns northings as metres centred on original square
* 1 December 2006
* Only works for OSGB
* Returns 0 if not OSGB
* Must be no spaces in spatial ref
*
*/

ALTER FUNCTION [dbo].[LCReturnNorthings_c]
(@SpatialRef VARCHAR(20), @SrType VARCHAR(20) )
RETURNS  INT

--	PARAMETERS
--	@SpatialRef			A valid UK spatial ref
--  @SrType         Spatial ref type, e.g. OSGB

AS
BEGIN
--****************************************************************************************************
--constants

DECLARE @Northings				INT
DECLARE @LetA							CHAR(1)
DECLARE @LetB							CHAR(1)
DECLARE @LenS							INT
DECLARE @ReturnNorthings	INT
DECLARE @NumericPart			VARCHAR(6)
DECLARE @Offset						INT
DECLARE @DINTY            VARCHAR(1)

SET @ReturnNorthings = 0

IF @SRType = 'OSGB' BEGIN
  -- used for testing only
  -- set @SpatialRef = left(@spatialref,2)	 + "00"
  SET @LetA = LEFT(@SpatialRef,1)
  SET @Northings = 0

  IF  @LetA = 'N' OR @LetA = 'O' SET @Northings = 500000

  IF  @LetA = 'H' OR @LetA = 'J' SET @Northings = 1000000

  SET @LetB = substring(@SpatialRef,2,1)

  IF @LetB < 'I' SET @Offset = 65
  ELSE SET @Offset = 66

  SET @Northings = (((FLOOR(((ASCII(@letb)-@offset)/5)))-4) * -100000) + @Northings
  SET @LenS = (LEN(@SpatialRef)-2)/2
  SET @Numericpart = SUBSTRING(@SpatialRef,   @LenS + 3,@LenS)

  IF ISNUMERIC (@Numericpart) = 1	BEGIN
    SET @returnnorthings = @northings + LEFT(CAST(@numericpart AS VARCHAR) + '55555', 5)
  END

  IF CHARINDEX(RIGHT(@SpatialRef, 1), 'ABCDEFGHIJKLMNPQRSTUVWXYZ') != 0 BEGIN
    SET @DINTY = CASE RIGHT(@SpatialRef, 1)
      WHEN 'A' THEN '1'
      WHEN 'B' THEN '3'
      WHEN 'C' THEN '5'
      WHEN 'D' THEN '7'
      WHEN 'E' THEN '9'
      WHEN 'F' THEN '1'
      WHEN 'G' THEN '3'
      WHEN 'H' THEN '5'
      WHEN 'I' THEN '7'
      WHEN 'J' THEN '9'
      WHEN 'K' THEN '1'
      WHEN 'L' THEN '3'
      WHEN 'M' THEN '5'
      WHEN 'N' THEN '7'
      WHEN 'P' THEN '9'
      WHEN 'Q' THEN '1'
      WHEN 'R' THEN '3'
      WHEN 'S' THEN '5'
      WHEN 'T' THEN '7'
      WHEN 'U' THEN '9'
      WHEN 'V' THEN '1'
      WHEN 'W' THEN '3'
      WHEN 'X' THEN '5'
      WHEN 'Y' THEN '7'
      WHEN 'Z' THEN '9'
    END
    SET @returnNorthings = @northings + LEFT(CAST(@NumericPart AS VARCHAR) + @DINTY + '0000', 5)
  END

END

RETURN   @ReturnNorthings

END




