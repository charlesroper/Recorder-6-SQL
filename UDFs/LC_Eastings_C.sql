set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

/*
*
*
* ***************** Version 2.5 *****************
* Original Author: Mike Weidlei
* Update by Charles Roper (centering functionality)
* Returns easting as metres centred on original square
* 1 December 2006
* Only works for OSGB
* Returns 0 if not OSGB
* Must be no spaces in spatial ref
*
*/

ALTER FUNCTION [dbo].[LCReturnEastings_c]
(@SpatialRef varchar(20), @SrType varchar(20) )
RETURNS int

AS
BEGIN

DECLARE @Eastings				INT
DECLARE @LetA						CHAR(1)
DECLARE @LetB						CHAR(1)
DECLARE @LenS						INT
DECLARE @ReturnEastings	INT
DECLARE @NumericPart		VARCHAR(6)
DECLARE @Offset					INT
DECLARE @DINTY          VARCHAR(1)

SET @ReturnEastings = 0

IF @SRType = 'OSGB'

  BEGIN
  -- set @spatialRef = left(@SpatialRef,2) + '00'
    SET @LetA = LEFT(@SpatialRef,1)
    SET @Eastings = 500000

    IF @LetA = 'S' OR @LetA = 'N' OR @LetA = 'H'
    BEGIN
      SET @Eastings = 0
    END

    SET @LetB = SUBSTRING(@SpatialRef,2,1)

    IF @Letb < 'I' BEGIN
      SET @offset = 0
    END
    ELSE
      SET @offset = -1

    SET @Eastings = (((ASCII(@LetB)+@offset)%5) * 100000) + @Eastings
    SET @LenS = (LEN(@SpatialRef)-2)/2
    SET @Numericpart = SUBSTRING(@SpatialRef, 3, @LenS)

    IF ISNUMERIC(@Numericpart) = 1 BEGIN
      SET @ReturnEastings = @Eastings + LEFT(CAST(@numericpart AS VARCHAR) + '55555', 5)
    END

    IF CHARINDEX(RIGHT(@SpatialRef, 1), 'ABCDEFGHIJKLMNPQRSTUVWXYZ') != 0 BEGIN
      SET @DINTY = CASE RIGHT(@SpatialRef, 1)
        WHEN 'A' THEN '1'
        WHEN 'B' THEN '1'
        WHEN 'C' THEN '1'
        WHEN 'D' THEN '1'
        WHEN 'E' THEN '1'
        WHEN 'F' THEN '3'
        WHEN 'G' THEN '3'
        WHEN 'H' THEN '3'
        WHEN 'I' THEN '3'
        WHEN 'J' THEN '3'
        WHEN 'K' THEN '5'
        WHEN 'L' THEN '5'
        WHEN 'M' THEN '5'
        WHEN 'N' THEN '5'
        WHEN 'P' THEN '5'
        WHEN 'Q' THEN '7'
        WHEN 'R' THEN '7'
        WHEN 'S' THEN '7'
        WHEN 'T' THEN '7'
        WHEN 'U' THEN '7'
        WHEN 'V' THEN '9'
        WHEN 'W' THEN '9'
        WHEN 'X' THEN '9'
        WHEN 'Y' THEN '9'
        WHEN 'Z' THEN '9'
      END
      SET @ReturnEastings = @Eastings + LEFT(CAST(@NumericPart AS VARCHAR) + @DINTY + '0000', 5)
    END

END

RETURN @ReturnEastings

END
