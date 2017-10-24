
if not exists
(	select
		*
	from
		dbo.sysindexes s
	where
		id = object_id('dbo.order_detail')
		and name = 'ix_order_detail_1' ) begin

    alter table dbo.order_detail drop constraint [pk_order_detail]
    create clustered index ix_order_detail_1 on order_detail (order_no, due_date, sequence)
    alter table dbo.order_detail add constraint [pk_order_detail] primary key nonclustered (id)
end
go
