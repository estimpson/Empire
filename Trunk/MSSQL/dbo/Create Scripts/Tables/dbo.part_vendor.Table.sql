
--drop table dbo.part_vendor

if	object_id ('dbo.part_vendor') is null begin
	create table dbo.part_vendor
	(
		part varchar(25) not null
	,	vendor varchar(10) not null
	,	vendor_part varchar(25) null
	,	vendor_standard_pack numeric(20, 6) null
	,	accum_received numeric(20, 6) null
	,	accum_shipped numeric(20, 6) null
	,	outside_process char(1) null
	,	qty_over_received numeric(20, 6) null
	,	receiving_um varchar(10) null
	,	part_name varchar(100) null
	,	lead_time numeric(6, 2) null
	,	min_on_order numeric(20, 6) null
	,	beginning_inventory_date datetime null
	,	note text null
	,	FABAuthDays numeric(20, 6) null
	,	ReceiptAuthDays numeric(20, 6) null
	,	min_release_qty numeric(20, 6) null
	,	primary key clustered
		(
			part
		,	vendor
		)
	)
end
go

