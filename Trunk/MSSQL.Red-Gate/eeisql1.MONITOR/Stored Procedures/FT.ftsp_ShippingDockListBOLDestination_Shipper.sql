SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_ShippingDockListBOLDestination_Shipper]
(	@ShipperID int)
as
--	Declarations:
declare @BOLNumber int,
	@ShipTo varchar(20)

--	I.	Get bill of lading number and destination from the passed shipper.
select	@BOLNumber = isnull (bill_of_lading_number, 0),
	@ShipTo = destination
from	shipper
where	id = @ShipperID

--	II.	Is there already a bill of lading?
if	@BOLNumber > 0 begin

--		A.	If there is more that 1, return pool_code and editable flag of 0 (FALSE).
	if	(	select	count(id)
			from	shipper
			where	destination != @ShipTo and
				bill_of_lading_number = @BOLNumber) > 0 begin

		select	code = edi_setups.pool_code,
			name = destination.name,
			editable = 0
		from	edi_setups,
			destination
		where	destination.destination = edi_setups.pool_code and
			edi_setups.destination = @ShipTo
		order by
			code
	end
--		B.	Otherwise, return destination / pool_code and editable flag of 1 (TRUE).
	else begin

		select	code = edi_setups.pool_code,
			name = destination.name,
			editable = 1
		from	edi_setups,
			destination
		where	destination.destination = edi_setups.pool_code and
			edi_setups.destination = @ShipTo
		union
		select	code = destination,
			name,
			editable = 1
		from 	destination
		where 	destination.destination = @ShipTo
		order by
			code
	end
end
--	III.	Otherwise return destination / pool_code and editable flag of 1 (TRUE).
else begin

	select	code = edi_setups.pool_code,
		name = destination.name,
		editable = 1
	from	edi_setups,
		destination
	where	destination.destination = edi_setups.pool_code and
		edi_setups.destination = @ShipTo
	union
	select	code = destination,
		name,
		editable = 1
	from 	destination
	where 	destination.destination = @ShipTo
	order by
		code
end
GO
