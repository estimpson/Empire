SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_ShippingDockListLineItems_Shipper]
(	@ShipperID int)
as
select	shipper_detail.qty_required,
	shipper_detail.qty_packed,
	shipper_detail.note,
	shipper_detail.boxes_staged,
	shipper_detail.alternative_qty,
	shipper_detail.alternative_unit,
	shipper_detail.customer_part,
	shipper_detail.suffix,
	shipper_detail.part_original,
	shipper_detail.stage_using_weight,
	shipper_detail.gross_weight,
	orig_required = Convert (numeric (20,6), qty_required),
	shipper_detail.shipper,
	shipper_detail.part,
	shipper_detail.order_no,
	standard_pack = IsNull (order_header.standard_pack, IsNull (FirstRelease.StandardPack, IsNull (part_customer.customer_standard_pack, part_inventory.standard_pack))),
	FirstRelease.DueDT
from	shipper_detail
	left join order_header on shipper_detail.order_no = order_header.order_no
	left join
	(	select	OrderNo = order_detail.order_no,
			Part = order_detail.part_number,
			Suffix = order_detail.suffix,
			DueDT = min (order_detail.due_date),
			StandardPack = min (part_packaging.quantity)
		from	order_detail
			left join part_packaging on order_detail.part_number = part_packaging.part and
				order_detail.packaging_type = part_packaging.code
		group by
			order_detail.order_no,
			order_detail.part_number,
			order_detail.suffix) FirstRelease on shipper_detail.order_no = FirstRelease.OrderNo and
		shipper_detail.part_original = FirstRelease.Part and
		IsNull (shipper_detail.suffix, 0) = IsNull (FirstRelease.Suffix, 0)
	left join part_customer on shipper_detail.part_original = part_customer.part and
		order_header.customer = part_customer.customer
	join part_inventory on shipper_detail.part_original = part_inventory.part
where	shipper_detail.shipper = @ShipperID
GO
