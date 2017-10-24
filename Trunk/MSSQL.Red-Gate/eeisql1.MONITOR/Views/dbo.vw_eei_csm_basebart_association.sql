SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_eei_csm_basebart_association]
as
SELECT	dbo.fn_ReturnCSMEOPDate(SOP) as CSMSOP,
		dbo.fn_ReturnCSMEOPDate(EOP)as CSMEOP,
		BPMnemonic.FORECAST_ID,
		NACSM.Release_ID,
		NACSM.MNEMONIC,
		BASE_PART,
		FAMILY,
		CUSTOMER,
		EMPIRE_MARKET_SEGMENT,
		EMPIRE_APPLICATION,
		QTY_PER,
		TAKE_RATE,
		FAMILY_ALLOCATION,
		EMPIRE_SOP,
		EMPIRE_EOP,
		Sales_parent,
		Badge,
		Program,
		Assembly_plant,
		namePlate
  FROM MONITOR.EEIUser.acctg_csm_base_part_mnemonic BPMnemonic
  join	MONITOR.EEIUser.acctg_csm_NACSM  NACSM on BPMnemonic.Mnemonic = NACSM.Mnemonic
  where	NACSM.Release_ID = (SELECT [MONITOR].[dbo].[fn_ReturnLatestCSMRelease] ( 'CSM')) and
		forecast_id = 'C' and take_rate>0
GO
