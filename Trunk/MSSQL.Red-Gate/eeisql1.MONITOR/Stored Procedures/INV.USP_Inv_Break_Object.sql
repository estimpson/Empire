SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [INV].[USP_Inv_Break_Object]( 
		@Operator varchar(5),
		@Serial int, 
		@QtyOfObjects int,
		@QtyPerObject numeric(20,6),
		@Location varchar(10) = NULL,
		@NewObjectSerial int = NULL output,
		@Result integer = 0 output
) AS
/*
Example:
begin transaction

declare	@ProcReturn int,
	@ProcResult int,
	@FirstSerial int,
	@Serial int 

set @Serial = 5981231

select	Serial, Part, std_Quantity, Quantity, location
from	Object
where serial = @Serial

execute	@ProcReturn = INV.USP_Inv_Break_Object
	@Operator = 'MON',
	@Serial = @Serial,
	@QtyOfObjects = 1, 
	@QtyPerObject = 80,
	@Location = NULL,
	@NewObjectSerial = @FirstSerial output,
	@Result = @ProcResult output

select	@ProcReturn,
	@ProcResult


select	Serial, Part, std_Quantity, Quantity, location
from	object 
where	Serial  = @Serial

select	Part, std_Quantity, Quantity, *
from	Audit_trail
where	Serial  = @Serial and Type = 'B'

select	Part, std_Quantity, Quantity, location
from	object 
where	Serial  Between @FirstSerial and @FirstSerial + 3

select	Part, type, from_loc, to_loc, std_Quantity, Quantity
from	Audit_trail
where	Serial  Between @FirstSerial and @FirstSerial + 3


rollback
:End Example
*/

SET nocount ON
SET	@Result = 999999

--<Tran Required=Yes AutoCreate=Yes>
DECLARE	@TranCount smallint
DECLARE @ObjectQuantity numeric(20,6), @Part varchar(25)

--<Error Handling>
DECLARE @ProcReturn integer, @ProcResult integer
DECLARE @Error integer,	@RowCount integer, @ProcName sysname

SET	@ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)
SET	@TranCount = @@TranCount
IF	@TranCount = 0 
	BEGIN TRANSACTION @ProcName
ELSE
	SAVE TRANSACTION @ProcName

--</Error Handling>

--	Argument Validation:
--		Operator required:
	IF	NOT EXISTS
		(	SELECT 	1
			FROM	employee
			WHERE	operator_code = @Operator) BEGIN

		SET	@Result = 60001
		RAISERROR (@Result, 16, 1, @Operator)
		ROLLBACK TRAN @ProcName		
		RETURN	@Result
	END

--		Serial required:
	IF	NOT EXISTS
		(	SELECT 	1
			FROM	object
			WHERE	serial = @Serial) 
	BEGIN
		SET	@Result = 100001
		RAISERROR (@Result, 16, 1, @Serial)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END


--		Quantity > 0:
	IF	@QtyPerObject !> 0 
	BEGIN
		SET	@Result = 60001
		RAISERROR ('Invalid quantity [%d]!', 16, 1, @QtyPerObject)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END

--  I. Get the require information
	--Get the Object info
	DECLARE @LocationTemp varchar(25)
	SET @LocationTemp= @Location
	
	SELECT	@Location = isnull (@Location, location), 
			@ObjectQuantity = Quantity, 
			@Part = Part 
	FROM	Object with (ROWLOCK)
	WHERE	Serial =@Serial 
	
	if  not exists( select	1
			from	location
			where	code = @Location) begin	
		set	@Result = 90001
		raiserror (@Result, 16, 1, @Location)
		rollback tran @ProcName
		return	@Result	                  	
	end		
	
-- II. Validate Original Object
	IF @ObjectQuantity !> 0 
	BEGIN
		SET	@Result = 60001
		RAISERROR ('Invalid quantity of the object [%d]!', 16, 1, @ObjectQuantity)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END

	
-- II. Validate the quantity is greater that the Object Quantity
	IF (@QtyPerObject * @QtyOfObjects) > @ObjectQuantity 
	begin
		set	@Result = 60001
		raiserror ('Quantity requested is grater than the original object', 16, 1)
		rollback tran @ProcName
		return	@Result
	end

	--	III.	Get a block of serial numbers.
	select	@NewObjectSerial = next_serial
	from	parameters with (TABLOCKX)

	WHILE	EXISTS
		(	SELECT	serial
			FROM	object
			WHERE	serial BETWEEN @NewObjectSerial AND @NewObjectSerial + @QtyOfObjects - 1) OR
		EXISTS
		(	SELECT	serial
			FROM	audit_trail
			WHERE	serial between @NewObjectSerial and @NewObjectSerial + @QtyOfObjects - 1) 
	BEGIN
		SET	@NewObjectSerial = @NewObjectSerial + 1
	END

	UPDATE	parameters
	SET	next_serial = @NewObjectSerial + @QtyOfObjects


--		B.	Create object.
	DECLARE	@Counter int, @TransDT datetime

	SET	@TransDT = Getdate()
	SET @Counter = 0

	While  @Counter <  @QtyOfObjects
	Begin
			INSERT	object
			(	serial, part, quantity, std_quantity, lot,
				location, last_date, unit_measure, operator,
				status, plant, name, last_time,	start_date,
				user_defined_status, cost,
				std_cost, Custom1, Custom2, Custom3,
				Custom4, Custom5, field1,	note,po_number, ShipperToRAN)
			SELECT	@NewObjectSerial + @Counter,
				part, quantity = @QtyPerObject,
				std_quantity = @QtyPerObject,
				lot, location= @Location, last_date = @TransDT, unit_measure,
				@Operator, status, plant, name, @TransDT, start_date,
				user_defined_status, cost, std_cost, Custom1, Custom2,
				Custom3, Custom4, Custom5, field1, note, po_number, ShipperToRAN
			FROM Object
			WHERE	Serial = @Serial

		--Validate the last insert
			SELECT	@Error = @@Error, @RowCount = @@RowCount
			IF	@Error != 0 begin
				SET	@Result = 300
				RAISERROR ('Error:  Unable to create object!', 16, 1)
				ROLLBACK TRAN @ProcName
				RETURN	@Result
			END
			
			IF	@RowCount != 1 begin
				SET	@Result = 300
				RAISERROR ('RowNotFound:  Unable to create object!', 16, 1)
				ROLLBACK TRAN @ProcName
				RETURN	@Result
			END

		--		C.	Write to audit_trail.
			INSERT	audit_trail
			(	serial,	date_stamp, type,
				part, quantity, remarks, operator,
				from_loc, to_loc, lot, weight, status,
				unit, std_quantity,	plant, notes,
				package_type, std_cost, user_defined_status,
				tare_weight, Custom1, Custom2, Custom3,
				Custom4, Custom5, start_date, field1, po_number, ShipperToRAN )
			SELECT	serial,	@TransDT, type = 'B',
				part, quantity, remarks = 'Break', operator,
				from_loc = convert(varchar, @Serial),
				to_loc = location, lot, weight, status,
				unit_measure, std_quantity, plant, Note,
				package_type, cost, user_defined_status,
				tare_weight, Custom1,Custom2,Custom3,
				Custom4,Custom5,start_date,	field1,	po_number, ShipperToRAN
			FROM	object
			WHERE	object.serial = @NewObjectSerial + @Counter


			--Validate the last insert
				SELECT	@Error = @@Error, @RowCount = @@RowCount
				IF	@Error != 0 begin
					SET	@Result = 300
					RAISERROR ('Error:  Unable to create the Audit_Trail Record!', 16, 1)
					ROLLBACK TRAN @ProcName
					RETURN	@Result
				END
				
				IF	@RowCount != 1 begin
					SET	@Result = 300
					RAISERROR ('RowNotFound:  Unable to create the Audit_Trail Record!', 16, 1)
					ROLLBACK TRAN @ProcName
					RETURN	@Result
				END

			SET @Counter = @Counter + 1
		END


-- Decrease the quantity of the object 
	--Update the Object Table with new info.
		UPDATE Object
		SET Quantity = Quantity - (@QtyPerObject * @QtyOfObjects),
			std_quantity = std_quantity - (@QtyPerObject * @QtyOfObjects),
			Last_date = Getdate(), 
			Operator = @Operator, 
			Last_Time = Getdate()
		WHERE Serial = @Serial


	--Validate the update of the original Serial
		SELECT	@Error = @@Error, @RowCount = @@RowCount
		IF	@Error != 0 begin
			SET	@Result = 6002
			RAISERROR ('Error:  Unable to update the master serial on the object table!', 16, 1)
			ROLLBACK TRAN @ProcName
			RETURN	@Result
		END
		
		IF	@RowCount != 1 begin
			SET	@Result = 6003
			RAISERROR ('RowNotFound:  Unable to update the master serial on the object table!', 16, 1)
			ROLLBACK TRAN @ProcName
			RETURN	@Result
		END


--		C.	Write to audit_trail.
	INSERT	audit_trail
	(	serial, date_stamp, type, part, quantity, remarks, operator, from_loc,
		to_loc, lot, weight, status, unit, std_quantity, plant, notes,
		package_type, std_cost, user_defined_status, tare_weight,  Custom1, custom2,
		custom3, Custom4, custom5, start_date, po_number, field1, ShipperToRAN )
	SELECT	serial, date_stamp = @TransDT, type = 'B', part, quantity,
		Remark = 'Break-Out', operator, from_loc = location, to_loc = location,
		lot, weight, status, unit_measure, std_quantity, plant, Note,
		package_type, cost, user_defined_status, tare_weight, 
		Custom1 = '', custom2 = convert( varchar,  (@QtyPerObject * @QtyOfObjects)),
		custom3, custom4, custom5, start_date, po_number, field1, ShipperToRAN
	from	object object
	where	object.serial = @Serial

	--Validate the update of the original Serial
		select	@Error = @@Error, @RowCount = @@RowCount
		if	@Error != 0 begin
			set	@Result = 60108
			RAISERROR (@Result, 16, 1, 'Audit_trail', @Serial)
			rollback tran @ProcName
			RETURN	@Result
		END
		
		IF	@RowCount != 1 begin
			SET	@Result = 6003
			RAISERROR ('RowNotFound:  Unable to the audit_Trail table!', 16, 1)
			ROLLBACK TRAN @ProcName
			RETURN	@Result
		END

	--If the serial is depleted delete the object
	if  (select isnull(Quantity,0) from Object where Serial =@Serial ) = 0 begin
		delete 
		from    object
		where   serial = @Serial

		SELECT	@Error = @@Error, @RowCount = @@RowCount
		IF	@Error != 0 begin
			SET	@Result = 6002
			RAISERROR ('Error:  Unable to delete the object [%d]!', 16, 1, @Serial)
			ROLLBACK TRAN @ProcName
			RETURN	@Result
		END
		
		IF	@RowCount != 1 begin
			SET	@Result = 6003
			RAISERROR ('Rowcount:  Unable to delete the object [%d]!', 16, 1, @Serial)
			ROLLBACK TRAN @ProcName
			RETURN	@Result
		END
	end

if	@TranCount = 0 begin
	commit transaction @ProcName
end

--	III.	Success.
set	@Result = 0
return	@Result
GO
