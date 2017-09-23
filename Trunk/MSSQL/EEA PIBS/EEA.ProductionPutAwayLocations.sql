
if	objectproperty(object_id('EEA.ProductionPutAwayLocations'), 'IsView') = 1 begin
	drop view EEA.ProductionPutAwayLocations
end
go

create view EEA.ProductionPutAwayLocations
as
select
	Location = code
from
	dbo.location l
where
	code in ('ALA-CERTIF', 'ALA-FINAUD')
go

select
	Location
from
	EEA.ProductionPutAwayLocations
order by
	Location
go

