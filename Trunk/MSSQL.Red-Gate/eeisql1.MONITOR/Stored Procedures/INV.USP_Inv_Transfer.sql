SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [INV].[USP_Inv_Transfer]( 
		@Operator varchar(5),
		@Serial int, 
		@Toloc varchar(10) = NULL,
		@ToSerial int = null,
		@Note varchar(250) = NULL,
		@Result integer = 0 output
) AS
/*
Example:
begin transaction

declare	@ProcReturn int,
	@ProcResult int,
	@ShipperID int,
	@Serial int
	
set	@Serial  = 16501717

execute	@ProcReturn = HN.HCSP_Inv_Transfer_Core
	@Operator = 'MON',
	@Serial = @Serial,
	@ToLoc = 'RECHA-SORT',
	@Note = 'Request by Jhonantan castro',
	@Result = @ProcResult output

select	@ProcReturn,
	@ProcResult

select	*
from	object 
where	Serial  = @Serial 

rollback
:End Example
*/
set transaction isolation level read uncommitted

SET nocount ON
SET	@Result = 999999

DECLARE	@TranCount smallint,
		@ProcName sysname

--<Tran Required=Yes AutoCreate=Yes>


SET	@ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)
SET	@TranCount = @@TranCount
IF	@TranCount = 0 
	BEGIN TRANSACTION @ProcName
ELSE
	SAVE TRANSACTION @ProcName

--<Error Handling>
DECLARE @ProcReturn integer, @ProcResult integer
DECLARE @Error integer,	@RowCount integer

--</Error Handling>
DECLARE @FromLoc varchar(10), @Plant varchar(10)
DECLARE @QtyON_Hand_Result numeric(20,6), @Part varchar(25)
Declare @TranDT datetime


set	@TranDT = getdate()
set @Toloc = nullif(@Toloc,'')

--	Argument Validation:
--		Operator required:
	IF	NOT EXISTS
		(	SELECT 	1
			FROM	employee
			WHERE	operator_code = @Operator) BEGIN
		SET	@Result = 60001
		RAISERROR ('Error:  Operator %i is not valid!', 16, 1, @Operator)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END

--		Serial required:
	IF	NOT EXISTS
		(	SELECT 	1
			FROM	object
			WHERE	serial = @Serial and (Shipper is null or Shipper = 0)) BEGIN

		SET	@Result = 100001
		RAISERROR ('Error:  Object %s does not exists', 16, 1,@Serial)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END
       

--		Location required:
IF	@Toloc is not null begin
	if  exists ( select 1
				 from   object
				join part_characteristics on part_characteristics.part = object.part
				 where  object.serial = @Serial and 
				isnull(part_characteristics.hazardous, 'N') = 'Y' )
		and not exists( select  1
						from    location
						where   code = @Toloc
					and isnull(hazardous,'N') = 'Y' ) begin
		SET	@Result = 100034
		RAISERROR (@Result, 16, 1, @Serial,  @ToLoc)
		ROLLBACK TRAN @ProcName
		RETURN	@Result				                                      	
	end

	IF	NOT EXISTS
		(	SELECT 	1
			FROM	location
			WHERE	Code = @ToLoc) BEGIN
		SET	@Result = 107303
		RAISERROR ('Error:  Location %s is not valid', 16, 1, @ToLoc)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END
	
	set	@ToSerial = NULL
end
else if @ToSerial is not null begin
	IF	NOT EXISTS
		(	SELECT 	1
			FROM	Object
			WHERE	Serial = @ToSerial
					and Type = 'S') BEGIN
		SET	@Result = 107303
		RAISERROR ('Error:  Super Object Serial is not valid', 16, 1)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END
	select	@Toloc = location from object where Serial = @ToSerial
	
end
else if (@Toloc is null and @ToSerial is null) begin
		SET	@Result = 107303
		ROLLBACK TRAN @ProcName
		RAISERROR ('Error:  The Require Parameter SuperObject Serial or Location where not supplied.', 16, 1)
		RETURN	@Result
end

IF	Exists(SELECT 1
			FROM	object
			WHERE	serial = @Serial and Quantity < 0) BEGIN
	SET	@Result = 100030
	RAISERROR ('Error:  Cantidad en Object <= 0', 16, 1)
	ROLLBACK TRAN @ProcName
	RETURN	@Result
END

		
-- Get the plant designated for the new location
	SELECT @Plant = location.plant FROM location  WHERE location.code = @Toloc 

--Get the location for serial pass
	Select	@FromLoc = location from object where	serial=@Serial

--Update the location for the serial
	UPDATE	object 
	SET		location = isnull(@ToLoc, location), last_date = @TranDT, 
			operator = @operator, last_time = @TranDT, 
			plant = @Plant, Parent_serial = isnull(@ToSerial,0), note = @Note
	WHERE	serial = @Serial

	SELECT	@Error = @@Error, @RowCount = @@RowCount
	IF	@Error != 0 begin
		SET	@Result = 99999
		ROLLBACK TRAN @ProcName
		RAISERROR ('Error:  Unable to update object Table!', 16, 1)
		RETURN	@Result
	END

	IF	@RowCount = 0 begin
		SET	@Result = 99999
		RAISERROR ('Error:  No row Updated on object Table!', 16, 1)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END


	--Update the Child serial, because if the main serial (Super Object) is give, we have to move the chields
	UPDATE	object 
	SET		location = @ToLoc, last_date = @TranDT, 
			operator = @operator, note = @Note, 
			last_time = @TranDT, plant = @Plant
	WHERE	Parent_Serial = @Serial

	SELECT	@Error = @@Error, @RowCount = @@RowCount
	IF	@Error != 0 begin
		SET	@Result = 99999
		RAISERROR ('Error:  Unable to update child serial on object Table!', 16, 1)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END

--	Write to audit_trail.
	INSERT INTO	audit_trail
	(	Serial,
		date_stamp,
		type,
		part, 
		quantity,
		remarks, 
		operator,
		from_loc,
		to_loc,
		lot, 
		weight,		
		status, 
		unit,
		std_quantity,
		plant,
		notes, 
		package_type,
		std_cost,
		user_defined_status,
		on_hand,
		shipper, field1, suffix, sequence, custom1,
		custom2, custom3, custom4, custom5
		, parent_serial, ShipperToRAN )
	SELECT	serial,last_date,
		type = 'T',part, quantity, remarks = 'Transfer',
		operator,from_loc = @FromLoc,
		to_loc = isnull(convert(varchar, @ToSerial), @ToLoc),lot,
		weight,status,
		unit_measure,std_quantity,
		plant,@Note,
		package_type,cost,
		user_defined_status,
		on_hand =0,shipper, field1,
		suffix, sequence, custom1,
		custom2, custom3, custom4, custom5, parent_serial, ShipperToRAN
	FROM	object
	WHERE	serial = @Serial

--  Validate if the operation on the Audit Trail is succesfull
	SELECT	@Error = @@Error, @RowCount = @@RowCount

	IF	@Error != 0 begin
		SET	@Result = 99999
		ROLLBACK TRAN @ProcName
		RAISERROR ('Error:  Unable to update object Table!', 16, 1)
		RETURN	@Result
	END

	IF	@RowCount = 0 begin
		SET	@Result = 99999
		ROLLBACK TRAN @ProcName
		RAISERROR ('Error:  No rows were Updated on object Table!', 16, 1)
	END

----Insert into audit_trail the data for the Child Serials
	INSERT INTO	audit_trail
	(	serial,	date_stamp,
		type,	part,
		quantity, remarks,
		operator, from_loc,
		to_loc,	lot,
		weight,	status,
		unit,	std_quantity,
		plant,	notes,
		package_type,	std_cost,
		user_defined_status, field1,
		suffix, sequence, custom1,
		custom2, custom3, custom4, custom5, parent_serial, ShipperToRAN )
	select Serial,
		last_date, Type = 'T', part,
		quantity, Remarks= 'Transfer', operator,
		@FromLoc, @ToLoc, lot, weight, status,
		unit_measure, std_quantity, plant, @note,
		package_type, cost, user_defined_status,
		field1, suffix, sequence, custom1,
		custom2, custom3, custom4, custom5, parent_serial, ShipperToRAN
	FROM object
	Where Parent_serial = @Serial

--  Validate if the operation on the Audit Trail is succesfull
	
	SELECT	@Error = @@Error, @RowCount = @@RowCount
	
	IF	@Error != 0 begin
		SET	@Result = 99999
		ROLLBACK TRAN @ProcName
		RAISERROR ('Error:  Unable to update object Table!', 16, 1)
		RETURN	@Result
	END
	
IF	@TranCount = 0 BEGIN
	COMMIT TRANSACTION @ProcName
END

--	III.	Success.
SET	@Result = 0
RETURN	@Result
GO
