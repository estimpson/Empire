SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	procedure [HN].[HCSP_BF_DeliveryMaterialByOperator](
	@Operator varchar(5),
	@WODID int,
	@Part varchar(25),
	@QtyFound numeric(20,6),
	@Result int out)
as
/*
Example:
begin tran

declare	@Result int,
		@WODID int,
		@Part varchar(25),
		@QtyFound numeric(20,6)
		
select	@WODID = 359204,
		@Part = '11C40 NC010',
		@QtyFound = 253.831726

exec HN.HCSP_BF_DeliveryMaterialByOperator
	@Operator = 'MON',
	@WODID	= @WODID,
	@Part = @Part,
	@QtyFound = @QtyFound,
	@Result = @Result out
	
select	@Result

select	Serial = object.serial,
		Quantity = std_quantity,
		Location
from	object with (XLOCK)
		join WODMaterialAllocations on WODMaterialAllocations.serial = object.serial
where	WODMaterialAllocations.WODID = @WODID
		and QtyEnd is null
		and Part = @Part
		and object.Status = 'A'
		
rollback
END Example
*/
SET XACT_ABORT ON 
set nocount on
set	@Result = 999999

--<Tran Required=Yes AutoCreate=Yes>
declare	@TranCount smallint
set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin transaction DeliveryMaterialByOperator
end
else	begin
	save transaction DeliveryMaterialByOperator
end
--</Tran>

--<Error Handling>
declare	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer
--</Error Handling>


--	Argument Validation:
--		Valid WO required:
if	not exists (select  1
  	            from	WOHeaders 
  						join WODetails on WODetails.WOID = WOHeaders.ID 
  	            where	WODetails.ID = @WODID 
						and WOHeaders.Status in (0,2) ) begin
	set	@Result = 90100
	raiserror (@Result, 16, 1, @WODID )
	rollback tran DeliveryMaterialByOperator
	return	@Result
end

if	not exists
	(	select	1
		from	employee
		where	operator_code = @Operator) begin
	set	@Result = 60001
	rollback tran DeliveryMaterialByOperator
	RAISERROR (@Result, 16, 1, @Operator)
	return	@Result
end

if	not exists
	(	select	1
		from	part
		where	part = @Part) begin

	set	@Result = 90101
	raiserror (@Result, 16, 1, @Part)
	rollback tran DeliveryMaterialByOperator
	return	@Result
end

declare	@QtyInventory numeric (20,6),
	@QtyDiscrepancy numeric(20,6)

declare	@Objects table
(	Serial integer,
	Part varchar(25),
	Quantity numeric (20,6) )

insert	@Objects
(	Serial,
	Part, 
	Quantity)
select	distinct Serial = object.serial,
		object.Part,
		Quantity = std_quantity
from	object with (READUNCOMMITTED)
		join WODMaterialAllocations on WODMaterialAllocations.serial = object.serial
where	Location in(select	OperatorCode
					from	MaterialHandlerPickupWarehouse
					where	WarehouseCode in ('MOLDEO-KITS','SOBREMOLD'))
		and WODMaterialAllocations.WODID = @WODID
		and Part = @Part
		and QtyEnd is null
		and object.Status = 'A'


if  not exists( select	1
                from @Objects ) begin
	set @Result = 0
	return	@Result                             	
end
                
	
set	@QtyInventory = coalesce (
	(	select	sum (Quantity)
		from	@Objects), 0)

set	@QtyDiscrepancy = @QtyInventory - @QtyFound

if	abs(@QtyDiscrepancy) > 0.001 begin
	set	@Result = 90101
	raiserror ('There is a Discrepancy between the amount on the location and the Qty Input.', 16, 1)
	rollback tran DeliveryMaterialByOperator
	return	@Result
end

--	II.	Correct inventory.
declare	@TranDT datetime,
	@TranType char (1),
	@Status char (1),
	@UserStatus varchar (10),
	@Remarks varchar (10),
	@Notes varchar (50),
	@Machine varchar(10),
	@WOID int,
	@Toppart varchar(25)

select	@Machine = Machine,
		@WOID = woHeaders.ID,
		@Toppart = WODetails.Part
from	woHeaders
		join WODetails on WODetails.WOID = woHeaders.ID
where	WODetails.ID = @WODID

if  exists ( select    1
	     	 from @Objects ) begin 

	insert into audit_trail
	(	Serial,	date_stamp, type, part, quantity, remarks, operator,
		from_loc, to_loc, lot, status, unit, std_quantity,
		plant, notes, package_type, std_cost, user_defined_status,
		on_hand )
	select	object.serial, date_stamp = getdate(), type = 'T', object.part,
		object.quantity, remarks = 'Transfer', operator = @Operator,
		object.location, To_loc = @Machine, object.lot, object.status,
		object.unit_measure, object.std_quantity, object.plant,
		Note = 'Transfer to delivery location', object.package_type,
		object.cost, object.user_defined_status, 
		Onhand = (select sum(Quantity) from object onHand where onHand.part = Object.Part and onHand.status = 'A')
	from	object object
			join @Objects OBJ on object.serial = OBJ.Serial

--  Validate if the operation on the Audit Trail is succesfull
	select	@Error = @@Error, @RowCount = @@RowCount

	if	@Error != 0 begin
		set	@Result = 300
		rollback tran DeliveryMaterialByOperator
		raiserror ('Error:  Unable to update object Table!', 16, 1)
		return	@Result
	end

	if	@RowCount = 0 begin
		set	@Result = 800
		rollback tran DeliveryMaterialByOperator
		raiserror ('Error:  No rows were Updated on object Table!', 16, 1)
		return	@Result
	end
	
	update	object
	set	last_date = getdate(),
		location = @Machine,
		last_time = getdate()
	where	serial in (select  serial
	     	           from @Objects )
end

declare	@Serial int, @TargetName varchar(25),
		@NewSerial int

declare ConvertSerial cursor for
select	Serial, Raname.SourcePart
from	@Objects Object
		join hn.BF_Rename_Parts Raname on  Object.Part =  Raname.TargetPart
				and Raname.Toppart = @Toppart


open ConvertSerial

fetch	next from ConvertSerial 
into	@Serial, @TargetName

while @@FETCH_STATUS = 0 begin

	
	exec HN.HCSP_Inv_Change_Part
			@Operator = @Operator,
			@Serial = @Serial,
			@Object_Quantity = null,
			@PartNew = @TargetName,
			@Note = 'Change because MeltFlow in rename part',
			@Type = 2,
			@SerialNew = @NewSerial out,
			@Result = @Result out

	set	@Error = @@Error	
	if	@Error != 0 begin
		set	@Result = 300
		rollback tran DeliveryMaterialByOperator
		raiserror ('Error: Unable to rename the part on the delivery...', 16, 1)
		return	@Result
	end

	if	@Result != 0 begin
		set	@Result = 800
		rollback tran DeliveryMaterialByOperator
		raiserror ('Result:  Error on the procedure rename part on delivery Kit... ', 16, 1)
	end
	
	update	WODMaterialAllocations
	set		Serial = @NewSerial
	where	WODID = @WODID
			and Serial = @Serial
			and QtyEnd is null
	
	select	@Error = @@Error, @RowCount = @@RowCount

	if	@Error != 0 begin
		set	@Result = 300
		rollback tran DeliveryMaterialByOperator
		raiserror ('Error:  Unable to update WODMaterialAllocations Table!', 16, 1)
		return	@Result
	end

	if	@RowCount = 0 begin
		set	@Result = 800
		rollback tran DeliveryMaterialByOperator
		raiserror ('Error:  No rows were Updated on WODMaterialAllocations Table!', 16, 1)
		return	@Result
	end
	
	
	fetch	next from ConvertSerial 
	into	@Serial, @TargetName
end

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction DeliveryMaterialByOperator
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	III.	Success.
set	@Result = 0
return	@Result
GO
