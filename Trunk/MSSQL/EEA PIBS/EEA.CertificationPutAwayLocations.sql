
if	objectproperty(object_id('EEA.CertificationPutAwayLocations'), 'IsView') = 1 begin
	drop view EEA.CertificationPutAwayLocations
end
go

create view EEA.CertificationPutAwayLocations
as
select
	Location = code
from
	dbo.location l
where
	code in ('ALA-FINAUD', 'ALA-WRHQUE')
go

select
	Location
from
	EEA.CertificationPutAwayLocations
order by
	Location
go

