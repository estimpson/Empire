CREATE ROLE [aspnet_Profile_ReportingAccess]
AUTHORIZATION [EEIUser]
GO
EXEC sp_addrolemember N'aspnet_Profile_ReportingAccess', N'aspnet_Profile_FullAccess'
GO
