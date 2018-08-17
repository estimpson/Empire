SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [Programs].[SETUP_ExternalOEM_Mappings]
as
select
	xName = xom.Name
,	om.Status
,	om.Type
,	xom.LastEOP
,	xom.FirstRelease
,	xom.LastRelease
,	xom.CurrentProgramFlag
,	xom.CurrentReleaseFlag
,	ActiveFlag = case when om.Status = 0 then 1 else 0 end
,	PrimaryFlag = case when om.Name = xom.Name then 1 else 0 end
,	AlternateFlag = case when om.Name != xom.Name then 1 else 0 end
,	iName = om.Name
,	om.RowID
,	om.RowCreateDT
,	om.RowCreateUser
,	om.RowModifiedDT
,	om.RowModifiedUser
from
	Programs.xOEMs xom
	left join Programs.OEMs om
		join Programs.OEM_xRefs oxr
			on oxr.OEM = om.RowID
		on oxr.xName = xom.Name
GO
