SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [FT].[vwIndentedBOM_with_SetUpData]
as
select	FinishedGood = XRt.TopPart,
	BOM = Space(XRt.BOMLevel * 5) + XRt.ChildPart,
	BOMDescription = part.name,
	Commodity = part.commodity,
	BOMQty = BOM.quantity,
	BOMUnit = BOM.unit_measure,
	BOMScrapFactor = BOM.scrap_factor,
	FlowRouterMachine = PM.machine,
	FlowRouterPPH = PM.parts_per_hour,
	FlowRouterActivityCode = AR.code,
	FlowRouterMachineMfgLot = pm.mfg_lot_size,
	FlowRouterMachinePPH = pm.parts_per_hour,
	FlowRouterMachineLaborCode = pm.labor_code,
	SmallSetupsLaborRate =  l.current_rate,
	FlowRouterSetUpTime =  PM.setup_time,
	FlowRouterCrewSize =  PM.crew_size,	
	PartStanadrdMaterialCum = material_cum,
	PartStandardBOMExtendedMaterialCUM = material_cum* BOM.quantity,
	PartStandardCostCum = cost_cum,
	PartStanadrdBOMExtendedCostCum = cost_cum*BOM.Quantity,
	PartSetupPrimaryVendor = default_vendor,	
	PartClassification = (CASE WHEN class = 'P' THEN 'Purchased' WHEN class = 'M' THEN 'Manufactured' ELSE 'Other' END)
from	FT.XRt XRT with(nolock)
	join part with(nolock) on XRt.ChildPart = part.part
	JOIN part_online with(nolock) on part.part = part_online.part
	JOIN	part_standard with(nolock) ON part.part = part_standard.part
	left join dbo.bill_of_material_ec BOM with(nolock) on XRt.BOMID = BOM.ID
	left join dbo.part_machine PM with(nolock) on XRt.ChildPart = PM.part and
		PM.sequence = 1
	left join dbo.activity_router AR with(nolock) on XRt.ChildPart = AR.parent_part
	left join dbo.labor l  with(nolock) on pm.labor_code = l.id 

where	XRt.TopPart in (select part from dbo.part where type = 'F')  and 
			exists (select 1 from order_header where status = 'A' and blanket_part = TopPart union select 1 from object o join part p on o.part =p.part where p.type != 'R' and  o.part  in (TopPart, ChildPart))
GO
