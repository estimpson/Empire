IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'EMPIREELECT\backupexec')
CREATE LOGIN [EMPIREELECT\backupexec] FROM WINDOWS
GO
CREATE USER [EMPIREELECT\backupexec] FOR LOGIN [EMPIREELECT\backupexec]
GO