SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_eei_Target_forcasted_sales_percent_nonService]
as
Select * from (Select *, (basePartSales/Sales)*100 as PercentofTotalSales from
(Select	sum(eeiqty*alternate_price) as BasePartSales,
		sum(eeiqty) as BasePartQty,
		substring(part.part, 1, (PATINDEX( '%-%',part.part))-1) as BasePart
from	order_detail
join		part on order_detail.part_number = part.part
join		part_eecustom on part.part = part_eecustom.part and isNULL(ServicePart, 'N') = 'N'
where	order_detail.due_date <= dateadd(dd, 90, getdate()) and
		part.part like '%-%' and part.part not like '%[#]%' and part.part not like '%-PT%' and part.part not in (select part from eeiVW_MG)
group by substring(part.part, 1, (PATINDEX( '%-%',part.part))-1) ) Partsales
cross join	(select sum(quantity*alternate_price) as Sales
				from	order_detail where order_detail.due_date <= dateadd(dd, 90, getdate())) TotalSales ) ForcastedSales
GO
