IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'EMPIRE\psabido')
CREATE LOGIN [EMPIRE\psabido] FROM WINDOWS
GO
CREATE USER [EMPIRE\psabido] FOR LOGIN [EMPIRE\psabido] WITH DEFAULT_SCHEMA=[EMPIRE\psabido]
GO
REVOKE CONNECT TO [EMPIRE\psabido]