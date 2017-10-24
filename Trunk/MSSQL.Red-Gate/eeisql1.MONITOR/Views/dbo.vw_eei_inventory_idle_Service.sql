SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE view  [dbo].[vw_eei_inventory_idle_Service]

as
select	ISNULL(sales_manager_code.description ,'No Team Defined') as Team,
		lastshipdate = (select max (date_shipped) from shipper_detail where part_original = object.part),
		oldinv.firstdate, 
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
			substring(part.part, 1, (CASE WHEN PATINDEX( '%-%',part.part) = 0 then 25 else PATINDEX( '%-%',part.part)-1 END)) as base_part,
			isNULL((select sum(quantity) from order_detail where order_detail.part_number = part.part and
			order_detail.due_date <= dateadd(wk,4, getdate())),0) as four_week_demand,
		location.plant
		
		
from	object
	join	part_standard on object.part = part_standard.part
	join part on object.part = part.part and
	--	part.class in( 'P') and
		part.type = 'F'
	join part_eecustom on object.part = part_eecustom.part and
		isnull(nullif(servicePart,''), 'N') = 'Y'
	left outer join sales_manager_code on part_eecustom.team_no = sales_manager_code.code
	left join location on object.location = location.code ---AND
	join
	(Select min(firstdate) firstdate,
			serial
		From	(	select	serial,
			firstdate = min (date_stamp)
		from	audit_trail
		where	type = 'U' and
			date_stamp <= DateAdd (day, -45, getdate())
		group by
			audit_trail.serial
		union
		select	serial,
			firstdate = min (date_stamp)
		from	audit_trail
		where	type = 'J' and
			date_stamp <= DateAdd (day, -45, getdate())
		group by
			audit_trail.serial
		union
		select	serial,
			firstdate = min (date_stamp)
		from	audit_trail
		where	type = 'A' and
			date_stamp <= DateAdd (day, -45, getdate())
		group by
			audit_trail.serial
		union
		select	serial,
			firstdate = min (date_stamp)
		from	audit_trail
		where	type = 'B' and
			date_stamp <= DateAdd (day, -45, getdate())
		group by
			audit_trail.serial
		union
		select	audit_trail.serial,
			firstdate = min (date_stamp)
		from	audit_trail
		where	audit_trail.type = 'R' and
			audit_trail.date_stamp <= DateAdd (day, -45, getdate ())
		group by
			audit_trail.serial) oldinv2 where exists (Select 1 from object where object.serial = oldinv2.serial) group by oldinv2.serial ) oldinv on oldinv.serial = object.serial
			
UNION

select	ISNULL(sales_manager_code.description ,'No Team Defined') as Team,
	lastshipdate = (select max (date_shipped) from shipper_detail where part_original = object.part),
	object.last_date, 
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
		case when part.part like '%-%' then substring(part.part, 1, (PATINDEX( '%-%',part.part))-1) else part.part end as base_part,
		isNULL((select sum(quantity) from order_detail where order_detail.part_number = part.part and
		order_detail.due_date <= dateadd(wk,4, getdate())),0) as four_week_demand,
	location.plant
from	object
	join	part_standard on object.part = part_standard.part
	join part on object.part = part.part and
	--	part.class in ( 'P' )and
		part.type = 'F' 
	join part_eecustom on object.part = part_eecustom.part and
		isnull(nullif(servicePart,''), 'N') = 'Y'
	left outer join sales_manager_code on part_eecustom.team_no = sales_manager_code.code
	LEFT join location on object.location = location.code
Where	not exists (Select 1 from audit_trail where audit_trail.serial = object.serial and audit_trail.type in ('U','J','A','B','R')) and location not like '%PREOBJECT%'
/*where	isNULL(location.secured_location,'N') <> 'Y'  /* and not exists
	(	select	1
		from	audit_trail shp
		where	type = 'S' and
				part = object.part and
				date_stamp >= DateAdd (day, -30, getdate ())) and part.part not in (select part from eeiVW_MG)*/
*/






GO
