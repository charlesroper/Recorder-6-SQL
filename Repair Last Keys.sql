DECLARE @TableName sysname
DECLARE cur_lastkey CURSOR FOR
SELECT TABLE_NAME FROM LAST_KEY
OPEN cur_lastkey
FETCH NEXT FROM cur_lastkey INTO @TableName
WHILE @@FETCH_STATUS = 0
BEGIN
  IF EXISTS(SELECT TOP 1 TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @TableName)
  BEGIN
    IF @TableName != 'USER'
    BEGIN
      PRINT 'Repairing Lastkey for ' + @TableName
      EXEC dbo.spRepairLastKey @TableName
    END
  END
  FETCH NEXT FROM cur_lastkey INTO @TableName
END
CLOSE cur_lastkey
DEALLOCATE cur_lastkey