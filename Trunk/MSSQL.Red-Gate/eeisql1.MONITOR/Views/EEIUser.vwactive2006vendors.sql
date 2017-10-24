SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EEIUser].[vwactive2006vendors] as

select distinct(ap_applications.vendor), vendors.vendor_name from ap_applications, vendors where vendors.vendor = ap_applications.vendor and applied_date >= '2006-01-01' and applied_date < '2007-01-01'
GO
