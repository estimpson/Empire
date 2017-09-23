SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [FT].[ftsp_StagingAddInvToShipper_Troy]
(	@Operator varchar (10),
	@ShipperID integer,
	@ObjectSerial integer,
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
	@ProcResult int,
	@ShipperID int

execute	@ProcReturn = FT.ftsp_StagingAddInvToShipper_Troy
	@Operator = 'MON',
	@ShipperID = ?,
	@ObjectSerial = ?,
	@Result = @ProcResult output

select	@ShipperID,
	@ProcReturn,
	@ProcResult

select	*
from	shipper_detail
where	shipper = ?

rollback
:End Example
*/
as
set nocount on
set	@Result = 999999

--<Tran Required=Yes AutoCreate=Yes>
declare	@TranCount smallint
set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin transaction StagingAddInvToShipper_Troy
end
else	begin
	save transaction StagingAddInvToShipper_Troy
end
--</Tran>

--<Error Handling>
declare	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer
--</Error Handling>

--	Argument Validation:
--		Operator required:
if	not exists
	(	select	1
		from	employee
		where	operator_code = @Operator) begin

	set	@Result = 60001
	rollback tran StagingAddInvToShipper_Troy
	RAISERROR (@Result, 16, 1, @Operator)
	return	@Result
end

--		Object serial must be valid.
if	not exists
	(	select	1
		from	object
		where	serial = @ObjectSerial) begin

	set	@Result = 100001
	rollback tran StagingAddInvToShipper_Troy
	RAISERROR (@Result, 16, 1, @ObjectSerial)
	return	@Result
end

--		Pallet serial must be valid or null.
if	@PalletSerial is not null begin
	if	not exists
		(	select	1
			from	object
			where	serial = @PalletSerial) begin
	
		set	@Result = 100001
		rollback tran StagingAddInvToShipper_Troy
		RAISERROR (@Result, 16, 1, @PalletSerial)
		return	@Result
	end
	
--		...must be a pallet.
	if	not exists
		(	select	1
			from	object
			where	serial = @PalletSerial and
				type = 'S') begin
	
		set	@Result = 100003
		rollback tran StagingAddInvToShipper_Troy
		RAISERROR (@Result, 16, 1, @PalletSerial)
		return	@Result
	end
end

--		Shipper must be valid.
if	not exists
	(	select	1
		from	shipper
		where	id = @ShipperID) begin

	set	@Result = 107001
	rollback tran StagingAddInvToShipper_Troy
	RAISERROR (@Result, 16, 1, @ShipperID)
	return	@Result
end

--		Box/Pallets Staged differently.
declare	@ObjectType char (1)
select	@ObjectType = case when type is null then 'B' when type = 'S' then 'P' else @ObjectType end
from	object
where	serial = @ObjectSerial

if	@ObjectType not in ('B', 'P') begin

	set	@Result = 100901
	rollback tran StagingAddInvToShipper_Troy
	RAISERROR (@Result, 16, 1, @ObjectSerial, @ObjectType)
	return	@Result
end
if	@ObjectType = 'B' begin

	execute	@ProcReturn = FT.ftsp_StagingValidateBoxToShipper_Troy
		@ShipperID = @ShipperID,
		@BoxSerial = @ObjectSerial,
		@Result = @ProcResult output
	
	set	@Error = @@error
	
	if @ProcResult != 0 begin

		set	@Result = @ProcResult
		rollback tran StagingAddInvToShipper_Troy
		return	@Result
	end		
	if @Error != 0 or @ProcReturn != 0 begin

		rollback tran StagingAddInvToShipper_Troy
		RAISERROR (@Result, 16, 1, 'StagingAddInvToShipper_Troy')
		return	@Result
	end
end
if	@ObjectType = 'P' begin

	execute	@ProcReturn = FT.ftsp_StagingValidatePalletToShipper_Troy
		@ShipperID = @ShipperID,
		@PalletSerial = @ObjectSerial,
		@Result = @ProcResult output
	
	set	@Error = @@error
	
	if @ProcResult != 0 begin

		set	@Result = @ProcResult
		rollback tran StagingAddInvToShipper_Troy
		return	@Result
	end		
	if @Error != 0 or @ProcReturn != 0 begin

		rollback tran StagingAddInvToShipper_Troy
		RAISERROR (@Result, 16, 1, 'StagingAddInvToShipper_Troy')
		return	@Result
	end
end

--	I.	Stage inventory.
if	@ObjectType not in ('B', 'P') begin

	set	@Result = 100901
	rollback tran StagingAddInvToShipper_Troy
	RAISERROR (@Result, 16, 1, @ObjectSerial, @ObjectType)
	return	@Result
end
if	@ObjectType = 'B' begin

	execute	@ProcReturn = FT.ftsp_StagingStageBoxToShipper_Troy
		@Operator = @Operator,
		@ShipperID = @ShipperID,
		@BoxSerial = @ObjectSerial,
		@PalletSerial = @PalletSerial,
		@Result = @ProcResult output
	
	set	@Error = @@error
	
	if @ProcResult != 0 begin

		set	@Result = @ProcResult
		rollback tran StagingAddInvToShipper_Troy
		return	@Result
	end		
	if @Error != 0 or @ProcReturn != 0 begin

		rollback tran StagingAddInvToShipper_Troy
		RAISERROR (@Result, 16, 1, 'StagingAddInvToShipper_Troy')
		return	@Result
	end
end
if	@ObjectType = 'P' begin

	execute	@ProcReturn = FT.ftsp_StagingStagePalletToShipper
		@Operator = @Operator,
		@ShipperID = @ShipperID,
		@PalletSerial = @ObjectSerial,
		@Result = @ProcResult output
	
	set	@Error = @@error
	
	if @ProcResult != 0 begin

		set	@Result = @ProcResult
		rollback tran StagingAddInvToShipper_Troy
		return	@Result
	end		
	if @Error != 0 or @ProcReturn != 0 begin

		rollback tran StagingAddInvToShipper_Troy
		RAISERROR (@Result, 16, 1, 'StagingAddInvToShipper_Troy')
		return	@Result
	end
end

--	II.	Reconcile shipper.
execute	@ProcReturn = FT.ftsp_StagingReconcileShipper_Troy
	@ShipperID = @ShipperID,
	@Result = @ProcResult output

set	@Error = @@error

if @ProcResult != 0 begin

	set	@Result = @ProcResult
	rollback tran StagingAddInvToShipper_Troy
	return	@Result
end		
if @Error != 0 or @ProcReturn != 0 begin

	rollback tran StagingAddInvToShipper_Troy
	RAISERROR (@Result, 16, 1, 'StagingAddInvToShipper_Troy')
	return	@Result
end

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction StagingAddInvToShipper_Troy
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	III.	Success.
set	@Result = 0
return	@Result
GO
