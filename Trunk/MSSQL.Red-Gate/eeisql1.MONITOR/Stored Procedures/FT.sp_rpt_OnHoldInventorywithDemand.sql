SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [FT].[sp_rpt_OnHoldInventorywithDemand]
as

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
 
declare	@Date		date

select		@Date =getdate()

select	part,
			sum(quantity) as NonApprovedInventory,
			isNull(( select sum(quantity) from object where object.part = o.part and status ='A'),0) as ApprovedInventory,
			isNull((select sum(quantity) from order_detail where part_number = o.part and due_date < dateadd(dd,15,@date) and quantity >1),0) TotalDemand,
			isNull((select sum(quantity) from order_detail where part_number = o.part and due_date < dateadd(dd,0,@date) and quantity >1),0) PastDueDemand,
			isNull((select sum(quantity) from order_detail where part_number = o.part and  due_date >= dateadd(dd,0,@date) and due_date < dateadd(dd,1,@date) and quantity >1),0) CurrentDayDemand,
			isNull((select sum(quantity) from order_detail where part_number = o.part and  due_date >= dateadd(dd,1,@date) and due_date < dateadd(dd,2,@date) and quantity >1),0) Day1Demand,
			isNull((select sum(quantity) from order_detail where part_number = o.part and  due_date >= dateadd(dd,2,@date) and due_date < dateadd(dd,3,@date) and quantity >1),0) Day2Demand,
			isNull((select sum(quantity) from order_detail where part_number = o.part and  due_date >= dateadd(dd,3,@date) and due_date < dateadd(dd,4,@date) and quantity >1),0) Day3Demand,
			isNull((select sum(quantity) from order_detail where part_number = o.part and  due_date >= dateadd(dd,4,@date) and due_date < dateadd(dd,5,@date) and quantity >1),0) Day4Demand,
			isNull((select sum(quantity) from order_detail where part_number = o.part and  due_date >= dateadd(dd,5,@date) and due_date < dateadd(dd,6,@date) and quantity >1),0) Day5Demand,
			isNull((select sum(quantity) from order_detail where part_number = o.part and  due_date >= dateadd(dd,6,@date) and due_date < dateadd(dd,7,@date) and quantity >1),0) Day6Demand,
			isNull((select sum(quantity) from order_detail where part_number = o.part and  due_date >= dateadd(dd,7,@date) and due_date < dateadd(dd,8,@date) and quantity >1),0) Day7Demand,
			isNull((select sum(quantity) from order_detail where part_number = o.part and  due_date >= dateadd(dd,8,@date) and due_date < dateadd(dd,9,@date) and quantity >1),0) Day8Demand,
			isNull((select sum(quantity) from order_detail where part_number = o.part and  due_date >= dateadd(dd,9,@date) and due_date < dateadd(dd,10,@date) and quantity >1),0) Day9Demand,
			isNull((select sum(quantity) from order_detail where part_number = o.part and  due_date >= dateadd(dd,10,@date) and due_date < dateadd(dd,11,@date) and quantity >1),0) Day10Demand,
			isNull((select sum(quantity) from order_detail where part_number = o.part and  due_date >= dateadd(dd,11,@date) and due_date < dateadd(dd,12,@date) and quantity >1),0) Day11Demand,
			isNull((select sum(quantity) from order_detail where part_number = o.part and  due_date >= dateadd(dd,12,@date) and due_date < dateadd(dd,13,@date) and quantity >1),0) Day12Demand,
			isNull((select sum(quantity) from order_detail where part_number = o.part and  due_date >= dateadd(dd,13,@date) and due_date < dateadd(dd,14,@date) and quantity >1),0) Day13Demand,
			isNull((select sum(quantity) from order_detail where part_number = o.part and  due_date >= dateadd(dd,14,@date) and due_date < dateadd(dd,15,@date) and quantity >1),0) Day14Demand
from		dbo.object o
where	status!= 'A' and exists (select 1 from order_detail where part_number = o.part and due_date < dateadd(dd,15,@date) and quantity >1)
group by o.part

GO
