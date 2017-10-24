
if not exists
(	select
		*
	from
		dbo.sysindexes s
	where
		id = object_id('dbo.order_header')
		and name = 'ix_order_header_1' ) begin

	create index ix_order_header_1 on dbo.order_header (blanket_part, package_type, customer, destination, order_no)
end
go
