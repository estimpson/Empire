IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'EMPIREELECT\svc_empower')
CREATE LOGIN [EMPIREELECT\svc_empower] FROM WINDOWS
GO
CREATE USER [EMPIREELECT\svc_empower] FOR LOGIN [EMPIREELECT\svc_empower]
GO
