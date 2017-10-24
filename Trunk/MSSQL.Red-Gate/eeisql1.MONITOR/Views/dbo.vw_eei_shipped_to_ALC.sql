SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_shipped_to_ALC]
as
select serial from audit_trail where type = 'S' and date_stamp>= '2008-01-14' and to_loc = 'ALC' and part<> 'PALLET' and operator <> 'DR' and shipper >= '31199'
GO
