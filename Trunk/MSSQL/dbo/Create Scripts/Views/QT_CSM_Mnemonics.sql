USE [MONITOR]
GO

/****** Object:  View [EEIUser].[QT_CSM_Mnemonics]    Script Date: 03/04/2013 11:32:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE view [EEIUser].[QT_CSM_Mnemonics]
as
select
		acn.Release_ID
	,	acn.Version
	,	acn.[Mnemonic-Vehicle]
	,	acn.[Mnemonic-Vehicle/Plant]
	,	acn.[Mnemonic-Platform]
	,	acn.Region
	,	acn.Market
	,	acn.Country
	,	acn.Plant
	,	acn.City
	,	acn.[Plant State/Province]
	,	acn.[Source Plant]
	,	acn.[Source Country]
	,	acn.[Source Region]
	,	acn.[Design Parent]
	,	acn.[Engineering Group]
	,	acn.[Manufacturing Group]
	,	acn.Manufacturer
	,	acn.[Sales Parent]
	,	acn.Brand
	,	acn.[Platform Design Owner]
	,	acn.Architecture
	,	acn.Platform
	,	acn.Program
	,	acn.Nameplate
	,	acn.SOP
	,	acn.EOP
	,	acn.[Lifecycle (Time)]
	,	acn.Vehicle
	,	acn.[Assembly Type]
	,	acn.[Strategic Group]
	,	acn.[Sales Group]
	,	acn.[Global Nameplate]
	,	EAU = coalesce([CY 2012], [CY 2013], [CY 2014], [CY 2015], [CY 2016])
	,	[CY 2012]
	,	[CY 2013]
	,	[CY 2014]
	,	[CY 2015]
	,	[CY 2016]
	,	[CY 2017]
	,	[CY 2018]
	,	[CY 2019]
from
	EEIUser.acctg_csm_NAIHS acn
where
	acn.Release_ID = (select max(Release_ID) from EEIUser.acctg_csm_NAIHS)
	and acn.Version = 'CSM'


GO

