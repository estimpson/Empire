IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'APPUser')
CREATE LOGIN [APPUser] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [APPUser] FOR LOGIN [APPUser]
GO
