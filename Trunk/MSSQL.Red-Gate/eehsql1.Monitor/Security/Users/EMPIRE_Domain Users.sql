IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'EMPIRE\Domain Users')
CREATE LOGIN [EMPIRE\Domain Users] FROM WINDOWS
GO
CREATE USER [EMPIRE\Domain Users] FOR LOGIN [EMPIRE\Domain Users]
GO
