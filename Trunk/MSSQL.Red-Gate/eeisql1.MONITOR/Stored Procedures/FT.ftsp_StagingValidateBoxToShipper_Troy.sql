SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_StagingValidateBoxToShipper_Troy]
(	@ShipperID integer,
	@BoxSerial integer,
	@Result integer = 0 output
--<Debug>
	, @Debug integer = 0
--</Debug>
)
/*
Example:
begin transaction

declare	@ProcReturn int,
	@ProcResult int

execute	@ProcReturn = FT.ftsp_StagingValidateBoxToShipper_Troy
	@ShipperID = ?,
	@BoxSerial = ?,
	@Result = @ProcResult output

select	@ProcReturn,
	@ProcResult

rollback
:End Example
*/
as
set nocount on
set	@Result = 999999

--<Error Handling>
declare	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer
--</Error Handling>

--	Argument Validation:
--		Box validation:
declare	@RequiredBoxObjectType char (1),
	@RequiredBoxStatus char (1),
	@CurrentBoxObjectType char (1),
	@CurrentBoxStatus char (1),
	@CurrentPalletSerial integer,
	@CurrentShipper integer

set	@RequiredBoxObjectType = 'B'
set	@RequiredBoxStatus = 'A'

select	@CurrentBoxObjectType = isnull (type, 'B'),
	@CurrentBoxStatus = status,
	@CurrentPalletSerial = parent_serial,
	@CurrentShipper = shipper
from	object
where	serial = @BoxSerial

set	@RowCount = @@rowcount

--			...exists
if	@RowCount = 0 begin

	set	@Result = 100001
	RAISERROR (@Result, 16, 1, @BoxSerial)
	return	@Result
end

--			...box type
if	@CurrentBoxObjectType != @RequiredBoxObjectType begin

	set	@Result = 100002
	RAISERROR (@Result, 16, 1, @BoxSerial)
	return	@Result
end

--			...approved
if	@CurrentBoxStatus != @RequiredBoxStatus begin

	set	@Result = 100012
	RAISERROR (@Result, 16, 1, @BoxSerial, @RequiredBoxStatus, '[not specified]')
	return	@Result
end

--			...not on another shipper
if	@CurrentShipper is not null and
	@CurrentShipper != @ShipperID begin

	set	@Result = 100701
	RAISERROR (@Result, 16, 1, @BoxSerial, @CurrentShipper)
	return	@Result
end

--		Shipper must be valid.
if	not exists
	(	select	1
		from	shipper
		where	id = @ShipperID) begin

	set	@Result = 107001
	RAISERROR (@Result, 16, 1, @ShipperID)
	return	@Result
end

--		Box and Shipper compatibility validation:
--			...box must be required on shipper.
if	exists
	(	select	1
		from	object
		where	serial = @BoxSerial and
			part not in
			(	select	part_original
				from	shipper_detail
				where	shipper = @ShipperID)) begin

	set	@Result = 107101
	RAISERROR (@Result, 16, 1, @BoxSerial, @ShipperID)
	return	@Result
end

--			...shipper must have requirement remaining.
if	exists
	(	select	1
		from	object
		where	serial = @BoxSerial and
			part not in
			(	select	part_original
				from	shipper_detail
				where	shipper = @ShipperID and
					coalesce (qty_packed, 0) < qty_required)) begin

	set	@Result = 107103
	RAISERROR (@Result, 16, 1, @BoxSerial, @ShipperID)
	return	@Result
end

--	I.	Validated.
set	@Result = 0
return	@Result
GO
