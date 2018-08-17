SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [NSA].[BasePartMnemonics]
as
select
	aq.QuoteNumber
,	ReleaseID = acbpm.RELEASE_ID
,	VehiclePlantMnemonic = acbpm.MNEMONIC
,	BasePart = acbpm.BASE_PART
,	QtyPer = acbpm.QTY_PER
,	TakeRate = acbpm.TAKE_RATE
,	FamilyAllocation = acbpm.FAMILY_ALLOCATION
,	acn.Platform
,	acn.Program
,	Vehicle = acn.Nameplate
,	Manufacturer = acn.Brand
,	Family = acn.Manufacturer
,	SourcePlant = acn.[Source Plant]
,	SourcePlantCountry = acn.[Source Plant Country]
,	SourcePlantRegion = acn.[Source Plant Region]
,	CSM_SOP = acn.SOP
,	CSM_EOP = acn.EOP
,	EAU =
		case datepart(year, getdate())
			when 2018 then acn.[CY 2018]
			when 2019 then acn.[CY 2019]
			when 2020 then acn.[CY 2020]
			when 2021 then acn.[CY 2021]
			when 2022 then acn.[CY 2022]
			when 2023 then acn.[CY 2023]
			when 2024 then acn.[CY 2024]
			when 2025 then acn.[CY 2025]
			else null
		end * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acbpm.QTY_PER
,	QuotedEAU = ql.EAU
from
	MONITOR.EEIUser.acctg_csm_base_part_mnemonic acbpm
		join MONITOR.EEIUser.acctg_csm_NAIHS acn
			on acn.Release_ID = acbpm.RELEASE_ID
			and acn.[Mnemonic-Vehicle/Plant] = acbpm.MNEMONIC
	join NSA.AwardedQuotes aq
		join NSA.QuoteLog ql
			on ql.QuoteNumber = aq.QuoteNumber
		on ql.EEIPartNumber = acbpm.base_part
where
	acbpm.RELEASE_ID = MONITOR.dbo.fn_ReturnLatestCSMRelease('CSM')
	and acbpm.FORECAST_ID = 'C'
GO
