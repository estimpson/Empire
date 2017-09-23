SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




Create function [FT].[fn_LaborBurdenAudit] ()
returns @Audit table
(	FinishedGood  varchar(25),
	BOM  varchar(1000),
	Part_Machine_machine__aFlowRouter__A  varchar(50),
	Part_Machine_parts_per_hour__aFlowRouter__B  numeric(20,6),
	Part_Machine_crew_size__aFlowRouter__C  numeric(20,6),
	Part_Machine_mfg_lot_size__aFlowRouter__D numeric(20,6),
	Part_Machine_crew_size__aFlowRouter__E numeric(20,6),
	Part_Machine_setup_time__aFlowRouter__F numeric(20,6),
	Part_machine_labor_code__aFlowRoyter_F1 varchar(25),
	Labor_standard_rate__aSmallSetupsLabor_G numeric(20,6),
	Machine_standard_rate__aCostingBurden_H numeric(20,6),
	CalcLabor__GdividebyBtimesC numeric(20,6),
	CalcBurden__HdividebyBtimesC numeric(20,6)
	)
as
begin
	insert	 @Audit
				
	        (	FinishedGood ,
				BOM ,
				Part_Machine_machine__aFlowRouter__A ,
				Part_Machine_parts_per_hour__aFlowRouter__B ,
				Part_Machine_crew_size__aFlowRouter__C ,
				Part_Machine_mfg_lot_size__aFlowRouter__D ,
				Part_Machine_crew_size__aFlowRouter__E ,
				Part_Machine_setup_time__aFlowRouter__F ,
				Part_machine_labor_code__aFlowRoyter_F1,
				Labor_standard_rate__aSmallSetupsLabor_G,
	            Machine_standard_rate__aCostingBurden_H ,
				CalcLabor__GdividebyBtimesC ,
				CalcBurden__HdividebyBtimesC
	          
	        )
	
	
	select	
	FinishedGood = XRt.TopPart,
	BOM = Space(XRt.BOMLevel * 2) + XRt.ChildPart,
	Part_Machine_machine__aFlowRouter__A = PM.machine,
	Part_Machine_parts_per_hour__aFlowRouter__B = PM.parts_per_hour,
	Part_Machine_crew_size__aFlowRouter__C = PM.crew_size,
	Part_Machine_mfg_lot_size__aFlowRouter__D = PM.mfg_lot_size,
	Part_Machine_crew_size__aFlowRouter__E = PM.crew_size,
	Part_Machine_setup_time__aFlowRouter__F = PM.setup_time,
	Part_machine_labor_code__aFlowRoyter_F1 = PM.labor_code,
	Labor_standard_rate__aSmallSetupsLabor_G = L.standard_rate,
	Machine_standard_rate__aCostingBurden_H = M.standard_rate,
	CalcLabor__GdividebyBtimesC=(L.standard_rate/PM.parts_per_hour*PM.crew_size),
	CalcBurden__HdividebyBtimesC=(M.standard_rate/PM.parts_per_hour*PM.crew_size)
	
	
from	FT.XRt XRT
	join part on XRt.ChildPart = part.part
	left join dbo.bill_of_material_ec BOM on XRt.BOMID = BOM.ID
	left join dbo.part_machine PM on XRt.ChildPart = PM.part and
		PM.sequence = 1
	left join dbo.activity_router AR on XRt.ChildPart = AR.parent_part
	left join labor L on PM.labor_code = L.id
	left join machine M  on PM.machine = M.machine_no
where	XRt.TopPart in (select part from dbo.part where type = 'F') and
			XRt.ChildPart not in (select part from dbo.part where type = 'R')  /*and
			XRt.TopPart != XRt.ChildPart */
order by
	XRt.TopPart,
	Xrt.BOMLevel,
	XRt.Sequence
	return
end



GO
