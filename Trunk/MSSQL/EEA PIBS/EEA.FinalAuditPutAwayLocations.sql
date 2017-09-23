
if	objectproperty(object_id('EEA.FinalAuditPutAwayLocations'), 'IsView') = 1 begin
	drop view EEA.FinalAuditPutAwayLocations
end
go

create view EEA.FinalAuditPutAwayLocations
as
select
	Location = code
from
	dbo.location l
where
	code in ('ALA-CERTIF', 'ALA-WRHQUE')
go

select
	Location
from
	EEA.FinalAuditPutAwayLocations
order by
	Location
go

