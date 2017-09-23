
if	objectproperty(object_id('EEA.PutAwayLocations'), 'IsView') = 1 begin
	drop view EEA.PutAwayLocations
end
go

create view EEA.PutAwayLocations
as
select
	Location = code
from
	dbo.location l
where
	(	group_no = 'EEA Warehouse'
		and code like 'ALA-[BC]%'
		and	not exists
		(	select
				*
			from
				dbo.object o
			where
				o.location = l.code
		)
	)
	or code in ('ALA-CERTIF', 'ALA-FINAUD')
go

select
	Location
from
	EEA.PutAwayLocations
order by
	Location
go

