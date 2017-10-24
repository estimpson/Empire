
if not exists
(	select
		*
	from
		dbo.sysindexes s
	where
		id = object_id('dbo.location')
		and name = 'ix_location_1' ) begin

	create index ix_location_1 on dbo.location (plant, code)
end
go
