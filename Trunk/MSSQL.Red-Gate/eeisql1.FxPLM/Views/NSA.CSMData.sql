SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [NSA].[CSMData]
as
select
	ReleaseID = acn.RELEASE_ID
,	VehiclePlantMnemonic = acn.[Mnemonic-Vehicle/Plant]
,	acn.Platform
,	acn.Program
,	Vehicle = acn.Nameplate
,	Manufacturer = acn.Brand
,	SourcePlant = acn.[Source Plant]
,	SourcePlantCountry = acn.[Source Plant Country]
,	SourcePlantRegion = acn.[Source Plant Region]
,	CSM_SOP = acn.SOP
,	CSM_EOP = acn.EOP
,	RowID = isnull(row_number() over (order by acn.[Mnemonic-Vehicle/Plant]), -1)
--,	abp.BasePart
--,	ActiveFlag = case when bpm.BasePart is not null then 1 else 0 end
from
	MONITOR.EEIUser.acctg_csm_NAIHS acn
	--cross join
	--	NSA.ActiveBaseParts abp
	--left join NSA.BasePartMnemonics bpm
	--	on bpm.VehiclePlantMnemonic = acn.[Mnemonic-Vehicle/Plant]
	--	and bpm.BasePart = abp.BasePart
where
	acn.RELEASE_ID = MONITOR.dbo.fn_ReturnLatestCSMRelease('CSM')
	and acn.Version = 'CSM'
GO
