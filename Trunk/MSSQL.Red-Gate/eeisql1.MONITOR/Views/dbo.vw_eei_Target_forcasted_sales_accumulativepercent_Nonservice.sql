SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_eei_Target_forcasted_sales_accumulativepercent_Nonservice]
as
Select	BasePartSales,
		BasePartQty,
		BasePart,
		Sales,
		PercentofTotalSales,
		(Select sum(percentofTotalSales) from vw_eei_Target_forcasted_sales_percent_nonservice sp2 where sp2.PercentofTotalSales>= vw_eei_Target_forcasted_sales_percent_nonservice.percentofTotalSales)  as AccumulativePercent,
		isNULL((select max(standard_pack) from part_inventory where part like '%-%' and substring(part_inventory.part, 1, ISNULL((PATINDEX( '%-%',part_inventory.part)),0)-1)= BasePart),1) as StdPack,
		isNULL((select sum(Quantity) from object join location on object.location = location.code where isNULL(location.secured_location,'N') <>'Y' and location not like '%LOST%' and part like '%-%' and substring(object.part, 1, ISNULL((PATINDEX( '%-%',object.part)),0)-1) = BasePart),1) as Inventory,
		ISNULL((Select max(sales_manager_code.description) from sales_manager_code join part_eecustom on part_eecustom.team_no = sales_manager_code.code where part like '%-%' and substring(part_eecustom.part, 1, ISNULL((PATINDEX( '%-%',part_eecustom.part)),0)-1) = BasePart),'No Team Defined') as Team,
		isNULL((Select max (customer) 
						from	part_customer
						where	part_customer.part like '%-%' and
								substring(part_customer.part, 1, ISNULL((PATINDEX( '%-%',part_customer.part)),0)-1) = BasePart and
								part_customer.customer not in ('EEH', 'EEI')), '_Customer not specified for part') as customerCode,
		isNULL((Select max		(UPPER(scheduler)) 
						from	destination,
								part_customer
						where	part_customer.part like '%-%' and
								substring(part_customer.part, 1, ISNULL((PATINDEX( '%-%',part_customer.part)),0)-1) = BasePart and
								part_customer.customer not in ('EEH', 'EEI') and
								part_customer.customer = destination.customer), 'Scheduler not specified') as scheduler,
		isNULL((select max(material) from part_standard join part_eecustom on part_standard.part = part_eecustom.part and isNULL(currentRevLevel, 'N') = 'Y' where part_standard.part like '%-%' and substring(part_standard.part, 1, ISNULL((PATINDEX( '%-%',part_standard.part)),0)-1)= BasePart),1) as UnitCostAccum,
		(select min(MinDaysDemandOnHand) from part_eecustom where isNULL(currentRevLevel, 'N') = 'Y' and part_eecustom.part like '%-%' and substring(part_eecustom.part, 1, ISNULL((PATINDEX( '%-%',part_eecustom.part)),0)-1)= BasePart) as MinDaysFixed,
		(select min(MaxDaysDemandOnHand) from part_eecustom where isNULL(currentRevLevel, 'N') = 'Y' and part_eecustom.part like '%-%' and substring(part_eecustom.part, 1, ISNULL((PATINDEX( '%-%',part_eecustom.part)),0)-1)= BasePart) as MaxDaysFixed
from	vw_eei_Target_forcasted_sales_percent_nonservice
GO
