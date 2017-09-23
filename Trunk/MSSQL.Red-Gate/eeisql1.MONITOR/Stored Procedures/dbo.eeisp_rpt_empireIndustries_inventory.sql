SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[eeisp_rpt_empireIndustries_inventory] as
Begin    
Select	part.part,  			
			part.name,  			
			part_inventory.standard_pack,  			
			isNULL((select count(1) from order_header where order_header.blanket_part = part.part),0) as no_of_blanketorders,  			
			object.part,  			
			object.serial,  			
			object.location,  			
			object.quantity,  			
			(select sum(order_detail.quantity) from order_detail where order_detail.part_number = part.part and due_date <=  dateadd(dd,7,getdate())) as ordersduefornextweek ,
			(select max(scheduler) from destination, customer , part_customer where destination.customer = customer.customer and part_customer.customer = customer.customer and part_customer.part = part.part) as scheduler,
			(case  when  isNULL(object.shipper,1) >1 then 0 else object.quantity end) as availableinventory,
			part.cross_ref
 from		part
			join part_inventory
				on part.part=part_inventory.part
			left join object
				on part.part=object.part
where		 	part.product_line like '%EEM%'   and
				part.class = 'P' and 
				part.type = 'F'

 End
GO
