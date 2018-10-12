SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[eeisp_rpt_materials_CSM_RawPart_Demand_testDoNotUse]
as
begin


--Get part List to obtain best possible BOM Structure
Create table #ActiveTopPart (Part varchar(25), primary key (part))
insert	#ActiveTopPart
Select	Max(part) from [EEISQL1].[Monitor].[dbo].part  part where left(part,7) in (Select	left(part.part,7)
from		 [EEISQL1].[Monitor].[dbo].part_eecustom part_eecustom
join		 [EEISQL1].[Monitor].[dbo].part part on part_eecustom.part = part.part and part.type = 'F'
where	part.part in (Select part_number from  [EEISQL1].[Monitor].[dbo].order_detail order_detail where quantity>1 and due_date > dateadd(dd, -30, getdate()) union select part_original from  [EEISQL1].[Monitor].[dbo].shipper_detail shipper_detail where date_shipped >= dateadd(dd, -365, getdate()))
group by left(part.part,7)
having    max(isNull(currentrevlevel,'N'))= 'N')
group by left(part,7)
UNION
Select	part.part
from		 [EEISQL1].[Monitor].[dbo].part_eecustom part_eecustom
join		 [EEISQL1].[Monitor].[dbo].part  part on part_eecustom.part = part.part and part.type = 'F'
where	isNull(currentrevlevel,'N')= 'Y'

--Get BOM for Active parts

Create table #BOM (	BasePart varchar(25),
					TopPart varchar(25),
					RawPart	varchar(25),
					QtyPer numeric(20,6) Primary Key (TopPart, RawPart))

Insert	#BOM
Select	left(TopPart,7),
		TopPart,
		ChildPart,
		Quantity
from		[dbo].[vw_RawQtyPerFinPart] BOM
join		#ActiveTopPart ATP on BOM.TopPart = ATP.Part

Create table		#BasePartDemand
				 (	BasePart		varchar(25),
					DemandY1	numeric(20,6),
					DemandY2	numeric(20,6),
					AvgDemandY1Y2Y3	numeric(20,6), Primary Key (BasePart))
					
Insert	#BasePartDemand

select 	Base_Part,
		isNull(sum(total_2009),0),
		isNull(sum(total_2010),0),
		(isNull(sum(total_2009),0)+isNull(sum(total_2010),0))/2
from		[EEISQL1].[Monitor].[EEIUser].[acctg_csm_vw_select_total_demand]
group by	Base_Part

Create table		#ProgramEOP
				 (	Program			varchar(255),
					CSMEOP			datetime, Primary Key (Program))
					
Insert	#ProgramEOP

select 	program,
		max([dbo].[fn_ReturnCSMEOPDate](EOP))		
from		[EEISQL1].[Monitor].[EEIUser].[acctg_csm_NACSM]
where	release_id = (select	max(release_id) from [EEISQL1].[Monitor].[EEIUser].[acctg_csm_NACSM]) and program is not null
group by	program


Create table		#BasePartProgramDemand
				 (	SalesParent	varchar(100),
					BasePart		varchar(25),
					Program		varchar(1000),
					vehicle		varchar(1000),
					EmpireEOP	datetime,
					DemandY1	numeric(20,6),
					DemandY2	numeric(20,6),
					DemandY3	numeric(20,6), 
					Primary Key (BasePart, Program))
					
Insert			#BasePartProgramDemand

Select	sales_parent,
		base_part,
		BasePartProgram.Program,
		vehicle,
		EmpireEOP,
		isNUll(total_2009,0),
		isNull(total_2010,0),
		isNull((total_2011),0)
 from	[EEISQL1].[Monitor].[EEIUser].[acctg_csm_vw_select_total_demand_grouped_by_BP_program] BasePartProgram
left join	[EEISQL1].[Monitor].[dbo].FlatCSM CSM on BasePartProgram.base_part = CSM.basepart
order by 2

--Insert			#BasePartProgramDemand

--Select	COALESCE(CSM.oem, 'Empire Adjustment'),
--		COALESCE(CSM.basepart, EV.Base_Part),
--		COALESCE(CSM.Program  + ' - Empire Adjustment', 'Empire Adjustment'),
--		vehicle,
--		EV.EmpireEOP,
--		max(isNUll(EV.total_2009,0)),
--		max(isNull(EV.total_2010,0)),
--		max(isNull((EV.total_2011),0))
-- from	[EEISQL1].[Monitor].[EEIUser].[acctg_csm_vw_select_total_demand_grouped_by_BP_program_empireVersion] EV
--left join	[EEISQL1].[Monitor].[dbo].FlatCSM CSM on EV.base_part = CSM.basepart
--group by	COALESCE(CSM.oem, 'Empire Adjustment'),
--		COALESCE(CSM.basepart, EV.Base_Part),
--		COALESCE(CSM.Program  + ' - Empire Adjustment', 'Empire Adjustment'),
--		vehicle,
--		EV.EmpireEOP
--order by 2




Select	RawPart ,
		Part.name, 
		SalesParent,
		BPPD.Program,
		vehicle,
		EmpireEOP,
		CSMEOP,
		BPPD.BasePart,
		BPPD.DemandY1 as EAUY1,
		BPPD.DemandY2 as EAUY2,
		BPPD.DemandY3 as EAUY3,
		QtyPer,
		(QtyPer*BPPD.DemandY1) As ComponentEAUY1,
		(QtyPer*BPPD.DemandY2) As ComponentEAUY2,
		(QtyPer*BPPD.DemandY3) As ComponentEAUY3,
		default_vendor,
		standard_pack,
		isNull((FabAuthDays/7),0) as LeadTime,
		cost_cum as StandardCost,
		(CASE WHEN standard_pack> (QtyPer*BPPD.DemandY1)/12  THEN convert(varchar(1000),(standard_pack-((QtyPer*BPPD.DemandY1)/12))) ELSE 'N/A' END) as AvgMonthlyDemandExceedsStdPack,
		(CASE WHEN standard_pack> (QtyPer*BPPD.DemandY1)/12  THEN (standard_pack-((QtyPer*BPPD.DemandY1)/12)) ELSE 0 END)*cost_cum as AvgMonthlyDemandExceedsStdPackExtended,
		(CASE WHEN isNull((FabAuthDays/7),0) >= 8 THEN 'Excessive Lead Time' ELSE '' END) as LeadTimeFlag

Into		#results		
From	#BasePartProgramDemand BPPD
left join	#ProgramEOP PEOP on  BPPD.Program = PEOP.Program
join		#BOM BOM on  BPPD.BasePart =  BOM.BasePart
join		part_online on BOM.RawPart = Part_Online.Part
join		part on part_online.part = part.part
join		part_inventory on part_online.part = part_inventory.part
join		part_standard on part_online.part = part_standard.part
left join	part_vendor on part_online.part = part_vendor.part and part_online.default_vendor = part_vendor.vendor

order by 1

Select	*,
		(Select max(CSMEOP) from #results R2 where R2.Rawpart = Results.RawPart)
from		#results Results

End
GO
