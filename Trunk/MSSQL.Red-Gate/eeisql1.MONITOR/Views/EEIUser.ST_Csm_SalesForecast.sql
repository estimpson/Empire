SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [EEIUser].[ST_Csm_SalesForecast]
as
select
	isnull(acn.Release_ID, 9999) as Release_ID
,	acn.Version
,	acn.[Mnemonic-Vehicle/Plant] as MnemonicVehiclePlant
,	acn.[Mnemonic-Vehicle] as MnemonicVehicle
--,	acn.[Mnemonic-Platform] as MnemonicPlatform
,	acn.Platform
,	f.empire_application
,	acn.Program
--,	f.program as sf_program
,	f.vehicle
,	f.parent_customer
--,	f.customer
--,	acn.Nameplate
--,	f.empire_market_segment
,	f.empire_market_subsegment
--,	f.product_line
,	f.status
,	acn.SOP
--,	f.sop as sf_sop
,	acn.EOP
--,	f.eop as sf_eop
--,	f.assembly_plant
--,	f.award_category
from 
	EEIUser.acctg_csm_NAIHS acn 
	join EEIUser.acctg_csm_vw_select_sales_forecast f
		on f.mnemonic = acn.[Mnemonic-Vehicle/Plant]
GO
