CREATE ROLE [aspnet_Roles_BasicAccess]
AUTHORIZATION [EEIUser]
GO
EXEC sp_addrolemember N'aspnet_Roles_BasicAccess', N'aspnet_Roles_FullAccess'
GO
