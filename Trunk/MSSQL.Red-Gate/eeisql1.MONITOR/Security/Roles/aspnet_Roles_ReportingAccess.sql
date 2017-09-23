CREATE ROLE [aspnet_Roles_ReportingAccess]
AUTHORIZATION [EEIUser]
GO
EXEC sp_addrolemember N'aspnet_Roles_ReportingAccess', N'aspnet_Roles_FullAccess'
GO
