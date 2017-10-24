IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'EMPIREELECT\svc_empowersupport')
CREATE LOGIN [EMPIREELECT\svc_empowersupport] FROM WINDOWS
GO
CREATE USER [EMPIREELECT\svc_empowersupport] FOR LOGIN [EMPIREELECT\svc_empowersupport]
GO
