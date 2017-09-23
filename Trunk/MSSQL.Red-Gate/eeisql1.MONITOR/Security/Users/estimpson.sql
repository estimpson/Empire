IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'estimpson')
CREATE LOGIN [estimpson] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [estimpson] FOR LOGIN [estimpson]
GO
