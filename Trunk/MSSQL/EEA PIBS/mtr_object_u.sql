
/* Not in production yet. */
if	object_id('dbo.mtr_object_u') is not null begin
	drop trigger dbo.mtr_object_u
end
go

create trigger dbo.mtr_object_u on dbo.object
for update
as
set nocount on
declare
	@OldShipper int
,	@NewShipper int

declare
	ShipperWeights cursor local for
select distinct
	OldShipper = d.shipper
,	NewShipper = i.shipper
from
	deleted d
	join inserted i
		on d.serial = i.serial
where
	coalesce(d.shipper, -1) != coalesce(i.shipper, -1)
	or
	(	i.shipper > 0
		and
		(	update(package_type)
			or update(std_quantity)
			or update(part)
		)
	)

open
	ShipperWeights

while
	1=1 begin
	
	fetch
		ShipperWeights
	into
		@OldShipper
	,	@NewShipper
	
	if	@@FETCH_STATUS != 0 begin
		break
	end
	
	if	@OldShipper != @NewShipper
		and @OldShipper > 0 begin

		execute msp_calc_shipper_weights @OldShipper
	end
	
	if	@NewShipper > 0 begin

		execute msp_calc_shipper_weights @NewShipper
	end
end

close
	ShipperWeights
go

