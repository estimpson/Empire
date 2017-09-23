SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[eeivw_master_ship]
as
select	order_header.order_no as order_header_order_no,
	order_header.customer as order_header_customer,
	order_header.customer_po as order_header_customer_po,
	order_detail.destination as order_detail_destination,    
	order_detail.part_number as order_detail_part_number, 
	order_detail.price as order_detail_price,  
	part.cross_ref as part_cross_ref,   
	order_detail.due_date as order_detail_due_date,   
	order_detail.quantity as order_detail_quantity,   
	part_online.on_hand as part_online_on_hand,
	part_inventory.eau as part_inventory_eau,
	destination.scheduler as destination_scheduler,
	ceeiinventory = Inventory.EEIInventory,
	ELPASOinventory = Inventory.ElPasoInventory,
	ELPASOinventoryonhold = Inventory.ElPasoInventoryOnHold,
	ceehinventory = Inventory.EEHInventory,
	conhold = Inventory.OnHoldInventory,
	clostinventory = Inventory.LostInventory,
	part_inventory.standard_pack as part_inventory_standard_pack,
	customer.salesrep as customer_salesrep,
	customer.sales_manager_code as customer_sales_manager_code,
	min_onhand as part_online_min_onhand,
	part_inventory.unit_weight as part_inventory_unit_weight,
	part_eecustom.prod_end as part_eecustom_prod_end,
	order_detail.committed_qty  as order_detail_committed_qty,
	isNULL(order_detail.eeiqty,0) as orderqty
from	order_header
	join order_detail on order_detail.order_no = order_header.order_no   
	join part on order_detail.part_number = part.part
 	join part_online on order_detail.part_number = part_online.part
	join part_inventory on order_detail.part_number = part_inventory.part
	join destination on order_header.destination = destination.destination
	join customer on order_header.customer = customer.customer
	left join part_eecustom on order_detail.part_number = part_eecustom.part
	left join
	(	select	Part = object.part,
		EEIInventory = sum (
			case	when isnull (location.plant, case when object.location like 'TRAN%' then 'INTRANSIT' else 'EEI' end) in( 'EEI', 'ES3') and
				object.location not like '%LOST%' and
				object.status = 'A'
					then std_quantity
				else 0
			end),
		ElPasoInventory = sum (
			case	when isnull (location.plant, case when object.location like 'TRAN%' then 'INTRANSIT' else 'EEI' end) = 'EEP' and
				object.location not like '%LOST%' and
				object.status = 'A'
					then std_quantity
				else 0
			end),
		ElPasoInventoryOnHold = sum (
			case	when isnull (location.plant, case when object.location like 'TRAN%' then 'INTRANSIT' else 'EEI' end) = 'EEP' and
				object.location not like '%LOST%' and
				object.status != 'A'
					then std_quantity
				else 0
			end),
		EEHInventory = sum (
			case	when isnull (location.plant, case when object.location like 'TRAN%' then 'INTRANSIT' else 'EEI' end) = 'EEH' and
				object.location not like '%LOST%' and
				object.status = 'A'
					then std_quantity
				else 0
			end),
		OnHoldInventory = sum (
			case	when isnull (location.plant, case when object.location like 'TRAN%' then 'INTRANSIT' else 'EEI' end) in( 'EEI', 'ES3') and
				object.location not like '%LOST%' and
				object.status != 'A'
					then std_quantity
				else 0
			end),
		LostInventory = sum (
			case	when isnull (location.plant, case when object.location like 'TRAN%' then 'INTRANSIT' else 'EEI' end) in('EEI' , 'ES3')and
				object.location like '%LOST%'
					then std_quantity
				else 0
			end),
		EEAInventory = sum (
			case	when isnull (location.plant, case when object.location like 'TRAN%' then 'INTRANSIT' else 'EEI' end) in('EEA')and
				object.location not like '%LOST%'
					then std_quantity
				else 0
			end)
	from	object
		left join location on object.location = location.code
	where	isNULL(secured_location, 'N') <> 'Y'
	group by
		object.part) Inventory on order_detail.part_number = Inventory.Part
where	order_detail.due_date <= dateadd(wk, 12, getdate()) and order_detail.part_number not in (select part from eeiVW_MG)
GO
