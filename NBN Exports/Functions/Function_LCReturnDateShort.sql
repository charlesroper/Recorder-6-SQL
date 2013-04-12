USE [NBNData]
GO

/****** Object:  UserDefinedFunction [dbo].[LCReturnDateShort]    Script Date: 03/29/2012 16:58:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[LCReturnDateShort]
(@VagueDate int, @VagueDateType varchar(2), @DatePart varchar(1)) RETURNS nvarchar(10)

/* Returns a date or date part for a given vague date field
    Author Michael Weideli - Littlefield Consultanct 14 October 2005
    F RETURNS FULL dd/mm/yyyy
    D RETURNS DAY
    Y RETURNS YEAR
    M RETURNS MONTH
    vague date type of U does not return anything

    EXAMPLE USAGE:
      LCReturnDate(VAGUE_DATE_START, VAGUE_DATE_END, 'F')
*/
AS
BEGIN
declare @MM1  nvarchar(9)
declare @MM2  nvarchar(9)
declare @RP1  nvarchar(10)
declare @Z    int
declare @G    int
declare @H    int
declare @A    int
declare @B    int
declare @Y    int
declare @C    int
declare @M    int
declare @D    int
declare @RD   int
declare @Y4   int
declare @RD1  int
declare @RM1  int
declare @RY1  int
declare @RDS1 nvarchar(2)
declare @RDS2 nvarchar(2)
declare @RD2  int
declare @RM2  int
declare @RY2  int
declare @RMS1 nvarchar(2)
declare @RMS2 nvarchar(2)
set @RD = @VagueDate + 693594
set @Z  = @RD + 306
set @H  = 100 * @Z - 25
set @A  = FLOOR(@H / 3652425)
set @B  = @A - FLOOR(@A / 4)
set @Y  = FLOOR((100 * @B + @H) / 36525)
set @C  = @B + @Z - 365 * @Y - FLOOR(@Y / 4)
set @M  = (5 * @C + 456) / 153
set @G  = (153 * @M - 457) / 5
set @D  = @C - @G
if @M >12 begin
  set @Y = @Y+1
  set @M = @M-12
end
set @RD1 = @D
set @RM1 = @M
set @RY1 = @Y
if @RD1 < 10 begin
  set @RDS1 = '0' + str(@RD1,1,0)
end
else begin
  set @RDS1 = str(@RD1,2,0)
end
if @RM1 < 10 begin
  set @RMS1 = '0' + str(@RM1,1,0)
end
else begin
  set @RMS1 = str(@RM1,2,0)
end
if @VagueDatetype <> 'U' begin
  set @RP1 = case @Datepart
    when 'D' then str(@RD1,2,0)
    when 'M' then str(@RM1,2,0)
    when 'Y' then str(@RY1,4,0)
    when 'F' then @RDS1 + '/'	 + @RMS1 + '/' + str(@RY1,4,0)
  end
end

return @RP1

RETURN ''

END
GO

