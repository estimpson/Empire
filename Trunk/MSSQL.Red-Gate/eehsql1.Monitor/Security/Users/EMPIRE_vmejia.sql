IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'EMPIRE\vmejia')
CREATE LOGIN [EMPIRE\vmejia] FROM WINDOWS
GO
CREATE USER [EMPIRE\vmejia] FOR LOGIN [EMPIRE\vmejia] WITH DEFAULT_SCHEMA=[EMPIRE\vmejia]
GO
REVOKE CONNECT TO [EMPIRE\vmejia]