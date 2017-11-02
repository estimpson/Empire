SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_eei_inventory_InTransit]

as
select	ISNULL(sales_manager_code.description ,'No Team Defined') as Team,
		lastshipdate = last_date,
		object.serial,
		object.quantity,
		object.location,
		object.part,
		isNULL((Select max (customer) 
						from part_customer
						where part_customer.part = part.part and
						part_customer.customer not in ('EEH', 'EEI')), '_Customer not specified for part') as customer_code,
		isNULL((Select max (scheduler) 
						from destination,
								part_customer
						where part_customer.part = part.part and
						part_customer.customer not in ('EEH', 'EEI') and
						part_customer.customer = destination.customer), 'Scheduler not specified') as scheduler,
		part_standard.cost_cum,
				isNULL((Select max (custom2) 
						from 	customer,
								part_customer
						where part_customer.part = part.part and
								part_customer.customer = customer.customer and
								part_customer.customer not in ('EEH', 'EEI')), '_Customer Group Not Specified') as customer_group,
		part.description_long,
			substring(part.part, 1, (PATINDEX( '%-%',part.part))-1) as base_part,
			isNULL((select sum(quantity) from order_detail where order_detail.part_number = part.part and
			order_detail.due_date <= dateadd(wk,4, getdate())),0) as four_week_demand,
		location.plant
		
		
from	object
	join	part_standard on object.part = part_standard.part
	join part on object.part = part.part and
		part.class in ( 'P' )and
		part.type = 'F'
	join part_eecustom on object.part = part_eecustom.part
	left outer join sales_manager_code on part_eecustom.team_no = sales_manager_code.code
	join location on object.location = location.code and (location.code like ( '%TRAN%') or location.code like '%AIR%')

GO