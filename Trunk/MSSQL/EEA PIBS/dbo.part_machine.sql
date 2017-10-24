
if not exists
(	select
		*
	from
		dbo.sysindexes s
	where
		id = object_id('dbo.part_machine')
		and name = 'ix_part_machine_1' ) begin

	create index ix_part_machine_1 on dbo.part_machine (machine, part, sequence)
end
go
