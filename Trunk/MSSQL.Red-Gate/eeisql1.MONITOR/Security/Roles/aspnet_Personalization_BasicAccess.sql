CREATE ROLE [aspnet_Personalization_BasicAccess]
AUTHORIZATION [EEIUser]
GO
EXEC sp_addrolemember N'aspnet_Personalization_BasicAccess', N'aspnet_Personalization_FullAccess'
GO
