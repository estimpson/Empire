SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create View [EDI].[EDITradingPartners] as
Select	
	Trading_partner_Code,
	EDIMapCode
From
	edi_setups
GO
