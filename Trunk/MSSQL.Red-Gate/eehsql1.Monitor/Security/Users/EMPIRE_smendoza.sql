IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'EMPIRE\smendoza')
CREATE LOGIN [EMPIRE\smendoza] FROM WINDOWS
GO
CREATE USER [EMPIRE\smendoza] FOR LOGIN [EMPIRE\smendoza] WITH DEFAULT_SCHEMA=[EMPIRE\smendoza]
GO
REVOKE CONNECT TO [EMPIRE\smendoza]
