SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_StagingRemoveInvFromShipper_Troy]
(	@Operator varchar (10),
	@ObjectSerial integer,
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

execute	@ProcReturn = FT.ftsp_StagingRemoveInvFromShipper_Troy
	@Operator = 'MON',
	@ObjectSerial = ?,
	@Result = @ProcResult output

select	@ShipperID,
	@ProcReturn,
	@ProcResult

select	*
from	object
where	serial = ?

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
	begin transaction StagingRemoveInvFromShipper_Troy
end
else	begin
	save transaction StagingRemoveInvFromShipper_Troy
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
	rollback tran StagingRemoveInvFromShipper_Troy
	RAISERROR (@Result, 16, 1, @Operator)
	return	@Result
end

--		Object serial must be valid.
if	not exists
	(	select	1
		from	object
		where	serial = @ObjectSerial) begin

	set	@Result = 100001
	rollback tran StagingRemoveInvFromShipper_Troy
	RAISERROR (@Result, 16, 1, @ObjectSerial)
	return	@Result
end

--		Do nothing if object isn't on a shipper.
declare	@ShipperID int
select	@ShipperID = shipper
from	object
where	serial = @ObjectSerial

if	@ShipperID is null begin

	set	@Result = 100
	rollback tran PrestagingBeginStagingPallet
	return	@Result
end	

--		Box/Pallets Unstaged differently.
declare	@ObjectType char (1)
select	@ObjectType = case when type is null then 'B' when type = 'S' then 'P' else @ObjectType end
from	object
where	serial = @ObjectSerial

--	I.	Unstage inventory.
if	@ObjectType not in ('B', 'P') begin

	set	@Result = 100901
	rollback tran StagingRemoveInvFromShipper_Troy
	RAISERROR (@Result, 16, 1, @ObjectSerial, @ObjectType)
	return	@Result
end
if	@ObjectType = 'B' begin

	execute	@ProcReturn = FT.ftsp_StagingUnstageBoxFromShipper
		@Operator = @Operator,
		@BoxSerial = @ObjectSerial,
		@Result = @ProcResult output
	
	set	@Error = @@error
	
	if @ProcResult != 0 begin

		set	@Result = @ProcResult
		rollback tran StagingRemoveInvFromShipper_Troy
		return	@Result
	end		
	if @Error != 0 or @ProcReturn != 0 begin

		rollback tran StagingRemoveInvFromShipper_Troy
		RAISERROR (@Result, 16, 1, 'StagingRemoveInvFromShipper_Troy')
		return	@Result
	end
end
if	@ObjectType = 'P' begin

	execute	@ProcReturn = FT.ftsp_StagingUnstagePalletFromShipper
		@Operator = @Operator,
		@PalletSerial = @ObjectSerial,
		@Result = @ProcResult output
	
	set	@Error = @@error
	
	if @ProcResult != 0 begin

		set	@Result = @ProcResult
		rollback tran StagingRemoveInvFromShipper_Troy
		return	@Result
	end		
	if @Error != 0 or @ProcReturn != 0 begin

		rollback tran StagingRemoveInvFromShipper_Troy
		RAISERROR (@Result, 16, 1, 'StagingRemoveInvFromShipper_Troy')
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
	rollback tran StagingRemoveInvFromShipper_Troy
	return	@Result
end		
if @Error != 0 or @ProcReturn != 0 begin

	rollback tran StagingRemoveInvFromShipper_Troy
	RAISERROR (@Result, 16, 1, 'StagingRemoveInvFromShipper_Troy')
	return	@Result
end

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction StagingRemoveInvFromShipper_Troy
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	III.	Success.
set	@Result = 0
return	@Result
GO
