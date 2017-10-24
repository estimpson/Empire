create index ix_location_2 on dbo.location (plant, code, secured_location)
go

create index ix_object_4 on dbo.object (location, part, std_quantity)
go

create index ix_order_detail_2 on dbo.order_detail (order_no, part_number, packaging_type, quantity, due_date, type, id, destination, std_qty)
go

create index ix_order_detail_3 on dbo.order_detail (part_number, order_no, packaging_type, quantity, due_date, type, id, destination, std_qty)
go

create index ix_part_inventory_1 on dbo.part_inventory (part, standard_pack)
go

create index ix_part_machine_2 on dbo.part_machine (sequence, machine, part)
go

create index ix_shipper_1 on dbo.shipper (id, status, type)
go

create index ix_shipper_detail_1 on dbo.shipper_detail (part_original, order_no, shipper, qty_required)
go

