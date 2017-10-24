IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'EEIUser')
CREATE LOGIN [EEIUser] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [EEIUser] FOR LOGIN [EEIUser]
GO
