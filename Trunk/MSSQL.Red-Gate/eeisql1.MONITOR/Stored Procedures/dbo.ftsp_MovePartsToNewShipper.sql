SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








-- exec dbo.ftsp_MovePartsToNewShipper '84818', 'BULBED ES3 COMPONENTS'


CREATE 	procedure [dbo].[ftsp_MovePartsToNewShipper] @ShipperID int, @ProductLine varchar(50)
as
begin


declare @NextShipperID int

select  @NextShipperID = shipper from parameters
update	 dbo.parameters set shipper = shipper+1

insert dbo.shipper
        ( id ,
          destination ,
          shipping_dock ,
          ship_via ,
          status ,
          date_shipped ,
          aetc_number ,
          freight_type ,
          printed ,
          bill_of_lading_number ,
          model_year_desc ,
          model_year ,
          customer ,
          location ,
          staged_objs ,
          plant ,
          type ,
          invoiced ,
          invoice_number ,
          freight ,
          tax_percentage ,
          total_amount ,
          gross_weight ,
          net_weight ,
          tare_weight ,
          responsibility_code ,
          trans_mode ,
          pro_number ,
          notes ,
          time_shipped ,
          truck_number ,
          invoice_printed ,
          seal_number ,
          terms ,
          tax_rate ,
          staged_pallets ,
          container_message ,
          picklist_printed ,
          dropship_reconciled ,
          date_stamp ,
          platinum_trx_ctrl_num ,
          posted ,
          scheduled_ship_time ,
          currency_unit ,
          show_euro_amount ,
          cs_status ,
          bol_ship_to ,
          bol_carrier ,
          operator
        )
select 

		@NextShipperID ,
          destination,
          shipping_dock ,
          ship_via ,
          status ,
          date_shipped ,
          aetc_number ,
          freight_type ,
          printed ,
          bill_of_lading_number ,
          model_year_desc ,
          model_year ,
          customer ,
          location ,
          staged_objs ,
          plant ,
          type ,
          invoiced ,
          @NextShipperID ,
          freight ,
          tax_percentage ,
          total_amount ,
          gross_weight ,
          net_weight ,
          tare_weight ,
          responsibility_code ,
          trans_mode ,
          pro_number ,
          notes ,
          time_shipped ,
          truck_number ,
          invoice_printed ,
          seal_number ,
          terms ,
          tax_rate ,
          staged_pallets ,
          container_message ,
          picklist_printed ,
          dropship_reconciled ,
          date_stamp ,
          platinum_trx_ctrl_num ,
          'N' ,
          scheduled_ship_time ,
          currency_unit ,
          show_euro_amount ,
          cs_status ,
          bol_ship_to ,
          bol_carrier ,
          operator
from
	dbo.shipper
where
	id = @ShipperID
	
insert	dbo.shipper_detail
        ( shipper ,
          part ,
          qty_required ,
          qty_packed ,
          qty_original ,
          accum_shipped ,
          order_no ,
          customer_po ,
          release_no ,
          release_date ,
          type ,
          price ,
          account_code ,
          salesman ,
          tare_weight ,
          gross_weight ,
          net_weight ,
          date_shipped ,
          assigned ,
          packaging_job ,
          note ,
          operator ,
          boxes_staged ,
          pack_line_qty ,
          alternative_qty ,
          alternative_unit ,
          week_no ,
          taxable ,
          price_type ,
          cross_reference ,
          customer_part ,
          dropship_po ,
          dropship_po_row_id ,
          dropship_oe_row_id ,
          suffix ,
          part_name ,
          part_original ,
          total_cost ,
          group_no ,
          dropship_po_serial ,
          dropship_invoice_serial ,
          stage_using_weight ,
          alternate_price ,
          old_suffix ,
          old_shipper
        )
select	@NextShipperID ,
        sd.part ,
        qty_required ,
        qty_packed ,
        qty_original ,
        accum_shipped ,
        order_no ,
        customer_po ,
        release_no ,
        release_date ,
        sd.type ,
        price ,
        account_code ,
        salesman ,
        tare_weight ,
        gross_weight ,
        net_weight ,
        date_shipped ,
        assigned ,
        packaging_job ,
        note ,
        operator ,
        boxes_staged ,
        pack_line_qty ,
        alternative_qty ,
        alternative_unit ,
        week_no ,
        taxable ,
        price_type ,
        cross_reference ,
        customer_part ,
        dropship_po ,
        dropship_po_row_id ,
        dropship_oe_row_id ,
        suffix ,
        part_name ,
        part_original ,
        total_cost ,
        group_no ,
        dropship_po_serial ,
        dropship_invoice_serial ,
        stage_using_weight ,
        alternate_price ,
        old_suffix ,
        old_shipper
from		dbo.shipper_detail sd
join		part  p on sd.part_original = p.part
where	shipper = @ShipperID and
			product_line = @ProductLine
			
			

delete dbo.shipper_detail
from
	dbo.shipper_detail
join
	part on dbo.shipper_detail.part_original = dbo.part.part
where
	shipper = @ShipperID and product_line = @ProductLine
	
select	* from shipper_detail where shipper = @NextShipperId
select	* from	shipper_detail where	shipper = @ShipperId

end






GO
