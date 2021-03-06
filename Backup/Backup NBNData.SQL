BACKUP DATABASE [NBNData] TO  DISK = N'I:\BRC_SQL\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Backup\NBNData.bak' WITH NOFORMAT, INIT,  NAME = N'NBNData-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N'NBNData' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'NBNData' )
if @backupSetId is null begin raiserror(N'Verify failed. Backup information for database ''NBNData'' not found.', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N'I:\BRC_SQL\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Backup\NBNData.bak' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO
