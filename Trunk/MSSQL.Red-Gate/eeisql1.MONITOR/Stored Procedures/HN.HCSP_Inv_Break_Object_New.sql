SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [HN].[HCSP_Inv_Break_Object_New]( 
		@Operator varchar(5),
		@Serial int, 
		@QtyOfObjects int,
		@QtyPerObject numeric(20,6),
		@Location varchar(10) = NULL,
		@NewObjectSerial int = NULL output,
		@Result integer = 0 output,
--<Debug>
		@Debug integer = 0
--</Debug>
) AS
/*
Example:
begin transaction

declare	@ProcReturn int,
	@ProcResult int,
	@FirstSerial int,
	@Serial int 

set @Serial = 34322714

select	Serial, Part, std_Quantity, Quantity, location, start_date
from	Object
where serial = @Serial

execute	@ProcReturn = HN.HCSP_Inv_Break_Object
	@Operator = 'MON',
	@Serial = @Serial,
	@QtyOfObjects = 1, 
	@QtyPerObject = 10,
	@Location = NULL,
	@NewObjectSerial = @FirstSerial output,
	@Result = @ProcResult output

select	@ProcReturn,
	@ProcResult


select	Serial, Part, std_Quantity, Quantity, location, start_date
from	object 
where	Serial  = @Serial

select	Serial, Part, std_Quantity, Quantity, start_date,  *
from	Audit_trail
where	Serial  = @Serial and Type = 'B'

select	Serial, Part, std_Quantity, Quantity, location, start_date
from	object 
where	Serial  Between @FirstSerial and @FirstSerial + 3

select	Serial, Part, type, from_loc, to_loc, std_Quantity, Quantity, start_date
from	Audit_trail
where	Serial  Between @FirstSerial and @FirstSerial + 3

select * from eeh.HN.PartRI_SerialWithRISystem where Part='EEP3031-WB00'

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
DECLARE @Error integer,	@RowCount integer


SET	@TranCount = @@TranCount
IF	@TranCount = 0 
	BEGIN TRANSACTION HCSP_Break_Object
ELSE
	SAVE TRANSACTION HCSP_Break_Object

--</Error Handling>

--	Argument Validation:
--		Operator required:
	IF	NOT EXISTS
		(	SELECT 	1
			FROM	employee
			WHERE	operator_code = @Operator) BEGIN

		SET	@Result = 60001
		ROLLBACK TRAN HCSP_Break_Object		
		RAISERROR (@Result, 16, 1, @Operator)
		RETURN	@Result
	END

--		Serial required:
	IF	NOT EXISTS
		(	SELECT 	1
			FROM	object
			WHERE	serial = @Serial) 
	BEGIN

		SET	@Result = 100001
		ROLLBACK TRAN HCSP_Break_Object
		RAISERROR (@Result, 16, 1, @Serial)
		RETURN	@Result
	END


--		Quantity > 0:
	IF	@QtyPerObject !> 0 
	BEGIN
		SET	@Result = 60001
		ROLLBACK TRAN HCSP_Break_Object
		RAISERROR ('Invalid quantity [%d]!', 16, 1, @QtyPerObject)
		RETURN	@Result
	END



---- Validar si la serie es un PRE-Object y no tiene jobcomplete
if exists (select   1
           from	    audit_trail
           where    type='P' 
		    and remarks='PRE-OBJECT' 
		    and serial=@Serial)
begin
	if not EXISTS(	select 1
	              	from	audit_trail 
	              	where	type='J' 
	              		and serial=@Serial)
	begin
		set	@Result = 100013
		rollback tran HCSP_Break_Object
		raiserror (@Result, 16, 1, @Serial)
		return	@Result		
	end
end


--  I. Get the require information
	--Get the Object info
	DECLARE @LocationTemp varchar(25), @FifoDate datetime, @ObjFromLoc varchar(25)
	SET @LocationTemp= @Location
	
	SELECT	@Location = isnull (@Location, location), 
			@ObjectQuantity = Quantity, 
			@Part = Part,
			@FifoDate = start_date,
			@ObjFromLoc = location
	FROM	Object with (ROWLOCK)
	WHERE	Serial =@Serial 
	
	if  not exists( select	1
			from	location
			where	code = @Location) begin
	
		set	@Result = 90001
		rollback tran HCSP_Break_Object
		raiserror (@Result, 16, 1, @Location)
		return	@Result	                  	
	end		
	
	if	@FifoDate is null begin
		select	@FifoDate = min(date_stamp)
		from	audit_trail
		where	serial = @Serial
	end


----VALIDAR SI LA LINEA ESTA EN INVENTARIO
if	exists(	select	1
					from	HN.BF_Part_In_CycleCount CycleCount
							join object on CycleCount.Part = object.Part
					where	Serial= @Serial
					and (@Location LIKE '%' + isnull(FamilyGroup,'@@@') + '%'
						 OR @ObjFromLoc LIKE '%' + isnull(FamilyGroup,'@@@') + '%')) begin
		
			

				set	@Result = 100013
		rollback tran HCSP_Break_Object
				RAISERROR ('Parte %s en inventario parcial, Operacion %s.', 16, 1, @Part,  'HCSP_Break_Object')
				return	@Result
		end

-- II. Validate Original Object
	IF @ObjectQuantity !> 0 
	BEGIN
		SET	@Result = 60001
		ROLLBACK TRAN HCSP_Break_Object
		RAISERROR ('Invalid quantity of the object [%d]!', 16, 1, @ObjectQuantity)
		RETURN	@Result
	END

	
-- II. Validate the quantity is greater that the Object Quantity
	IF (@QtyPerObject * @QtyOfObjects) > @ObjectQuantity 
	begin
		set	@Result = 60001
		rollback tran HCSP_Break_Object
		raiserror ('Quantity requested is grater than the original object', 16, 1)
		return	@Result
	end

-- II. Validate the quantity not must be equal to original quantity
	IF (Select product_line from part where part = @Part) !='PCB'
	begin 
		IF @QtyOfObjects =1 and  @QtyPerObject = @ObjectQuantity 
		begin
			set	@Result = 60001
			rollback tran HCSP_Break_Object
			raiserror ('Quantity requested not must be equal to original quantity', 16, 1)
			return	@Result
		end
	end
	--	III.	Get a block of serial numbers.
	--<Debug>
	if	@Debug & 1 = 1 begin
		print	'I.	Get a block of serial numbers.'
	end
	--</Debug>

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
			(	serial,
				part,
				quantity,
				std_quantity,
				lot,
				location,
				last_date,
				unit_measure,
				operator,
				status,
				plant,
				name,
				last_time,
				start_date,
				user_defined_status,
				cost,
				std_cost, 
				Custom1,
				Custom2,
				Custom3,
				Custom4,
				Custom5,
				field1,
				note,
				po_number,
				ObjectBirthday/*,
				ShipmentDate, SupplierLot,
				MasterSerial*/)
			SELECT	@NewObjectSerial + @Counter,
				part,
				@QtyPerObject,
				@QtyPerObject,
				lot,
				@Location,
				@TransDT,
				unit_measure,
				@Operator,
				status,
				plant,
				name,
				@TransDT,
				isnull( start_date,@FifoDate),
				user_defined_status,
				cost,
				std_cost,
				Custom1,
				Custom2,
				Custom3,
				Custom4,
				Custom5,
				field1,
				note,
				po_number,
				ObjectBirthday/*,
				ShipmentDate, SupplierLot,
				isnull( MasterSerial, @Serial )*/
			FROM Object
			WHERE	Serial = @Serial

		--Validate the last insert
			SELECT	@Error = @@Error, @RowCount = @@RowCount
			IF	@Error != 0 begin
				SET	@Result = 300
				ROLLBACK TRAN HCSP_Break_Object
				RAISERROR ('Error:  Unable to create object!', 16, 1)
				RETURN	@Result
			END
			
			IF	@RowCount != 1 begin
				SET	@Result = 300
				ROLLBACK TRAN HCSP_Break_Object
				RAISERROR ('RowNotFound:  Unable to create object!', 16, 1)
				RETURN	@Result
			END

		--		C.	Write to audit_trail.
			INSERT	audit_trail
			(	serial,
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
				tare_weight, 
				Custom1,
				Custom2,
				Custom3,
				Custom4,
				Custom5,
				start_date,
				field1,
				po_number,
				sequence/*,
				ShipmentDate, SupplierLot*/  )
			SELECT	serial,
				@TransDT,
				type = 'B',
				part,
				quantity,
				remarks = 'Break',
				operator,
				from_loc = convert( varchar, @Serial),
				to_loc = location,
				lot,
				weight,
				status,
				unit_measure,
				std_quantity,
				plant,
				Note,
				package_type,
				cost,
				user_defined_status,
				tare_weight, 
				Custom1,
				Custom2,
				Custom3,
				Custom4,
				Custom5,
				isnull(start_date,@FifoDate),
				field1,
				po_number,
				sequence/*,
				ShipmentDate, SupplierLot*/
			FROM	object
			WHERE	object.serial = @NewObjectSerial + @Counter


			--Validate the last insert
				SELECT	@Error = @@Error, @RowCount = @@RowCount
				IF	@Error != 0 begin
					SET	@Result = 300
					ROLLBACK TRAN HCSP_Break_Object
					RAISERROR ('Error:  Unable to create the Audit_Trail Record!', 16, 1)
					RETURN	@Result
				END
				
				IF	@RowCount != 1 begin
					SET	@Result = 300
					ROLLBACK TRAN HCSP_Break_Object
					RAISERROR ('RowNotFound:  Unable to create the Audit_Trail Record!', 16, 1)
					RETURN	@Result
				END

			--if exists( select 1	--Comentado porque no existe el campo receiving inspection
			--		   from part_inventory
			--		   where isnull(receiving_Inspection,0)=1
			--				 and part in (select part from object where serial=@Serial))

			--begin
			--	if exists (	select	1
			--				from	PartRI_SerialWithRISystem
			--				where	Serial=@Serial)
			--	begin
									
			--		insert into PartRI_SerialWithRISystem (Serial,Part,Week,Status,note,RegisterBy)
			--		select @NewObjectSerial + @Counter,Part,week,Status,Note,@Operator
			--		from PartRI_SerialWithRISystem where	Serial=@Serial

			--		IF	@RowCount != 1 begin
			--		SET	@Result = 999999
			--			ROLLBACK TRAN HCSP_Break_Object
			--			RAISERROR ('RowNotFound:  Unable to create the PartRI_SerialWithRISystem Record!', 16, 1)
			--			RETURN	@Result
			--		END

			--	end				
			--end
			
						
			SET @Counter = @Counter + 1
		END


-- Decrease the quantity of the object 
	--Update the Object Table with new info.
		UPDATE Object
		SET Quantity = Quantity - (@QtyPerObject * @QtyOfObjects),
			std_quantity = std_quantity - (@QtyPerObject * @QtyOfObjects),
			Last_date = @TransDT, 
			Operator = @Operator, 
			Last_Time = @TransDT,
			start_date = isnull(start_date,@FifoDate)
		WHERE Serial = @Serial


	--Validate the update of the original Serial
		SELECT	@Error = @@Error, @RowCount = @@RowCount
		IF	@Error != 0 begin
			SET	@Result = 6002
			ROLLBACK TRAN HCSP_Break_Object
			RAISERROR ('Error:  Unable to the object table!', 16, 1)
			RETURN	@Result
		END
		
		IF	@RowCount != 1 begin
			SET	@Result = 6003
			ROLLBACK TRAN HCSP_Break_Object
			RAISERROR ('RowNotFound:  Unable to the object table!', 16, 1)
			RETURN	@Result
		END


--		C.	Write to audit_trail.
	INSERT	audit_trail
	(	serial,
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
		tare_weight, 
		Custom1,
		custom2,
		custom3,
		Custom4,
		custom5,
		start_date,
		po_number,
		field1,
		sequence/*,
		ShipmentDate, SupplierLot */ )
	SELECT	serial,
		@TransDT,
		type = 'B',
		part,
		quantity,
		Remark = 'Break-Out',
		operator,
		from_loc = location,
		to_loc = location,
		lot,
		weight,
		status,
		unit_measure,
		std_quantity,
		plant,
		Note,
		package_type,
		cost,
		user_defined_status,
		tare_weight, 
		Custom1 = '',
		custom2 = convert( varchar,  (@QtyPerObject * @QtyOfObjects)),
		custom3,
		custom4,
		custom5,
		start_date,
		po_number,
		field1,
		sequence/*,
		ShipmentDate, SupplierLot*/
	from	object object
	where	object.serial = @Serial

	--Validate the update of the original Serial
		select	@Error = @@Error, @RowCount = @@RowCount
		if	@Error != 0 begin
			set	@Result = 60108
			rollback tran HCSP_Break_Object
			RAISERROR (@Result, 16, 1, 'Audit_trail', @Serial)
			RETURN	@Result
		END
		
		IF	@RowCount != 1 begin
			SET	@Result = 6003
			ROLLBACK TRAN HCSP_Break_Object
			RAISERROR ('RowNotFound:  Unable to the audit_Trail table!', 16, 1)
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
			ROLLBACK TRAN HCSP_Break_Object
			RAISERROR ('Error:  Unable to delete the object [%d]!', 16, 1, @Serial)
			RETURN	@Result
		END
		
		IF	@RowCount != 1 begin
			SET	@Result = 6003
			ROLLBACK TRAN HCSP_Break_Object
			RAISERROR ('Rowcount:  Unable to delete the object [%d]!', 16, 1, @Serial)
			RETURN	@Result
		END
	end

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction HCSP_Break_Object
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	III.	Success.
set	@Result = 0
return	@Result


GO
