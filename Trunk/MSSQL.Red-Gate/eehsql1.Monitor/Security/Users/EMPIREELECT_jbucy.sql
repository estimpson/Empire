IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'EMPIREELECT\jbucy')
CREATE LOGIN [EMPIREELECT\jbucy] FROM WINDOWS
GO
CREATE USER [EMPIREELECT\jbucy] FOR LOGIN [EMPIREELECT\jbucy] WITH DEFAULT_SCHEMA=[EMPIREELECT\jbucy]
GO
REVOKE CONNECT TO [EMPIREELECT\jbucy]