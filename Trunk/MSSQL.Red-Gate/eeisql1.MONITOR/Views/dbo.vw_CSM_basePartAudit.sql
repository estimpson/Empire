SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_CSM_basePartAudit]

as 
Select	BASE_PART,
		CSMSOP,
		(Select max(prod_start) from part_eecustom where left(part,7) = Base_part and prod_start is not null) as EmpireSOP,
		CSMEOP,
		(Select max(prod_end) from part_eecustom where left(part,7) = Base_part and prod_end is not null) as EmpireEOP,
		FORECAST_ID,
		Release_ID,
		MNEMONIC,
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
		NamePlate
		
from	vw_eei_csm_basebart_association 

GO
