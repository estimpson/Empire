SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[eeisp_rpt_materials_CSM_RawPart_DemandDoNotUse]
as
begin

--[dbo].[eeisp_rpt_materials_CSM_RawPart_Demand]

--Get part List to obtain best possible BOM Structure

--print 'insert #Active Part'

Create table #ActiveTopPart (Part varchar(25), primary key (part))
insert	#ActiveTopPart
--Commented by Andre S. Boulanger 10/07/2010 Schedulers are now maintaining active revision level on sales orders
/*Select	Max(part) from [EEISQL1].[Monitor].[dbo].part  part where left(part,7) in (Select	left(part.part,7)
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
where	isNull(currentrevlevel,'N')= 'Y'*/

SELECT	DISTINCT blanket_part
FROM	 [EEISQL1].[Monitor].[dbo].order_header order_header
WHERE	status = 'A'
/*UNION
SELECT	DISTINCT part_number
FROM	 [EEISQL1].[Monitor].[dbo].order_detail order_detail
WHERE	order_detail.due_date >= DATEADD(dd,-21, GETDATE()) AND
			LEFT(part_number,7) NOT IN (SELECT	DISTINCT LEFT(blanket_part,7)
														FROM	 [EEISQL1].[Monitor].[dbo].order_header order_header
														WHERE	status = 'A')*/
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

--SELECT* FROM #BOM
--WHERE	BasePart = 'ALC0031'




SELECT	base_part,
			part.name,
			Program,
			Manufacturer,
			Badge,
			vehicle,
			Status,
			CSM_eop_display,
			Total_2010_Totaldemand,
			Total_2011_Totaldemand,
			Total_2012_Totaldemand,
			Cal13_Totaldemand as FGDemand2013,
			Cal14_Totaldemand as FGDemand2014,
			Cal15_Totaldemand as FGDemand2015,
			Cal16_Totaldemand as FGDemand2016,
			RawPart,
			QtyPer,
			QtyPer*Total_2010_Totaldemand RawPartDemand2010,
			QtyPer*Total_2011_Totaldemand RawPartDemand2011,
			QtyPer*Total_2012_Totaldemand RawPartDemand2012,
			QtyPer*Cal13_Totaldemand RawPartDemand2013,
			QtyPer*Cal14_Totaldemand RawPartDemand2014,
			QtyPer*Cal15_Totaldemand RawPartDemand2015,
			QtyPer*Cal16_Totaldemand RawPartDemand2016,
			default_vendor,
			standard_pack,
			isNull((FabAuthDays/7),0) as LeadTime,
			cost_cum as StandardCost,
			(CASE WHEN isNull((FabAuthDays/7),0) >= 8 THEN 'Excessive Lead Time' ELSE '' END) as LeadTimeFlag
				
Into		#results				
FROM	[EEISQL1].[MONITOR].[EEIUser].acctg_csm_vw_select_csmdemandwitheeiadjustments_dw2 AS CSMDemand
LEFT		JOIN #BOM BOM ON CSMDemand.base_part = BOM.BasePart
join		part_online on BOM.RawPart = Part_Online.Part
join		part on part_online.part = part.part
join		part_inventory on part_online.part = part_inventory.part
join		part_standard on part_online.part = part_standard.part
left join	part_vendor on part_online.part = part_vendor.part and part_online.default_vendor = part_vendor.vendor



Select	*,
		(Select max(CSM_eop_display) from #results R2 where R2.Rawpart = Results.RawPart) as MaxCSMEOPforRawPart,
		(Select sum(std_quantity) from object where object.part = Results.RawPart) as AllRawPartInventory,
		(CASE WHEN  Standard_pack-(Select sum(RawpartDemand2010) from #Results R where R.RawPart = Results.Rawpart)> 0 THEN  Standard_pack-(Select sum(RawpartDemand2010) from #Results R where R.RawPart = Results.Rawpart) ELSE 0 END) as Standard_pack_exceeds_one_month,
		(CASE WHEN  Standard_pack-(Select sum(RawpartDemand2010) from #Results R where R.RawPart = Results.Rawpart)> 0 THEN  Standard_pack-(Select sum(RawpartDemand2010) from #Results R where R.RawPart = Results.Rawpart) ELSE 0 END) as Standard_pack_exceeds_three_months
from		#results Results
order by 1,2


End





GO
