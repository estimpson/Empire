SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FT].[fn_ShippingDockListLineItem_Shipper]
(	@ShipperID int)
returns @Results table
(	shipper int,
	part varchar (35),
	description varchar (100),
	qty_required numeric (20,6),
	qty_packed numeric (20,6),
	pack_unit char (2),
	boxes_staged int,
	gross_weight numeric (20,6),
	note varchar (254),
	customer_part varchar (30),
	box_label varchar (25),
	pallet_label varchar (25),
	part_original varchar (25),
	standard_qty numeric (20,6),
	stage_using_weight char(1))
as
begin
	insert	@Results
	select	shipper_detail.shipper,
		shipper_detail.part,
		part.name,
		shipper_detail.qty_required,
		shipper_detail.qty_packed,
		shipper_detail.alternative_unit,
		shipper_detail.boxes_staged,
		shipper_detail.gross_weight,
		shipper_detail.note,
		shipper_detail.customer_part,
		SalesOrderLabelInfo.BoxLabel,
		SalesOrderLabelInfo.PalletLabel,
		shipper_detail.part_original,
		shipper_detail.alternative_qty,
		shipper_detail.stage_using_weight
	from	shipper_detail
		left join
		(	select	OrderNo = order_detail.order_no,
				PartNumber = order_detail.part_number,
				Suffix = order_detail.suffix,
				BoxLabel = min (coalesce (order_detail.box_label, order_header.box_label, part_inventory.label_format)),
				PalletLabel = min (isnull (order_detail.pallet_label, order_header.pallet_label))
			from	order_detail
				join order_header on order_detail.order_no = order_header.order_no
				join part_inventory on order_detail.part_number = part_inventory.part
			group by
				order_detail.order_no,
				order_detail.part_number,
				order_detail.suffix) SalesOrderLabelInfo on shipper_detail.order_no = SalesOrderLabelInfo.OrderNo and
					shipper_detail.part_original = SalesOrderLabelInfo.PartNumber and
					isnull (shipper_detail.suffix, 0) = isnull (SalesOrderLabelInfo.Suffix, 0)
		join part on shipper_detail.part_original = part.part
	where	shipper = @ShipperID

	return
end
GO
