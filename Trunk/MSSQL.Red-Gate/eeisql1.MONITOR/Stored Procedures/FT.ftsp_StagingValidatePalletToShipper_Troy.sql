SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_StagingValidatePalletToShipper_Troy]
(	@ShipperID integer,
	@PalletSerial integer,
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

execute	@ProcReturn = FT.ftsp_StagingValidatePalletToShipper_Troy
	@ShipperID = ?,
	@PalletSerial = ?,
	@Result = @ProcResult output

select	@ProcReturn,
	@ProcResult

rollback
:End Example
*/
as
set nocount on
set	@Result = 999999

--	Argument Validation:
--		Pallet must be valid.
if	not exists
	(	select	1
		from	object
		where	serial = @PalletSerial) begin

	set	@Result = 100001
	RAISERROR (@Result, 16, 1, @PalletSerial)
	return	@Result
end

if	not exists
	(	select	1
		from	object
		where	serial = @PalletSerial and
			type ='S') begin

	set	@Result = 100003
	RAISERROR (@Result, 16, 1, @PalletSerial)
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
		where	parent_serial = @PalletSerial and
			part not in
			(	select	part_original
				from	shipper_detail
				where	shipper = @ShipperID)) begin

	set	@Result = 107102
	RAISERROR (@Result, 16, 1, @PalletSerial, @ShipperID)
	return	@Result
end

--			...shipper must have requirement remaining.
if	exists
	(	select	1
		from	object
		where	parent_serial = @PalletSerial and
			part not in
			(	select	part_original
				from	shipper_detail
				where	shipper = @ShipperID and
					qty_packed < qty_required)) begin

	set	@Result = 107103
	RAISERROR (@Result, 16, 1, @PalletSerial, @ShipperID)
	return	@Result
end

--	I.	Validated.
set	@Result = 0
return	@Result
GO
