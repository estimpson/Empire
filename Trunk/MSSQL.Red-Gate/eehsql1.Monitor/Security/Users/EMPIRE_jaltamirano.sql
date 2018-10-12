IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'EMPIRE\jaltamirano')
CREATE LOGIN [EMPIRE\jaltamirano] FROM WINDOWS
GO
CREATE USER [EMPIRE\jaltamirano] FOR LOGIN [EMPIRE\jaltamirano] WITH DEFAULT_SCHEMA=[EMPIRE\jaltamirano]
GO
REVOKE CONNECT TO [EMPIRE\jaltamirano]
