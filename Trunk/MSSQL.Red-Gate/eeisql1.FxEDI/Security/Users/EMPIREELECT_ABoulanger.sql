IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'EMPIREELECT\ABoulanger')
CREATE LOGIN [EMPIREELECT\ABoulanger] FROM WINDOWS
GO
CREATE USER [EMPIREELECT\ABoulanger] FOR LOGIN [EMPIREELECT\ABoulanger]
GO
