IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'EMPIREELECT\gchavez')
CREATE LOGIN [EMPIREELECT\gchavez] FROM WINDOWS
GO
CREATE USER [EMPIREELECT\gchavez] FOR LOGIN [EMPIREELECT\gchavez] WITH DEFAULT_SCHEMA=[EMPIREELECT\gchavez]
GO
REVOKE CONNECT TO [EMPIREELECT\gchavez]
