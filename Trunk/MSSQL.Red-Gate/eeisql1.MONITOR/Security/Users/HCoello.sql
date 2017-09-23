IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'HCoello')
CREATE LOGIN [HCoello] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [HCoello] FOR LOGIN [HCoello]
GO
