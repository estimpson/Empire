IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'EMPIREELECT\Domain Users')
CREATE LOGIN [EMPIREELECT\Domain Users] FROM WINDOWS
GO
CREATE USER [EMPIREELECT\Domain Users] FOR LOGIN [EMPIREELECT\Domain Users]
GO