IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'EMPIRE\hcoello')
CREATE LOGIN [EMPIRE\hcoello] FROM WINDOWS
GO
CREATE USER [EMPIRE\hcoello] FOR LOGIN [EMPIRE\hcoello] WITH DEFAULT_SCHEMA=[EMPIRE\hcoello]
GO
REVOKE CONNECT TO [EMPIRE\hcoello]
