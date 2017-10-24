IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'ABoulanger')
CREATE LOGIN [ABoulanger] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [ABoulanger] FOR LOGIN [ABoulanger]
GO
