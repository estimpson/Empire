IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'EEHDATA3\Troy Domain USers')
CREATE LOGIN [EEHDATA3\Troy Domain USers] FROM WINDOWS
GO
CREATE USER [EEHDATA3\Troy Domain USers] FOR LOGIN [EEHDATA3\Troy Domain USers]
GO
