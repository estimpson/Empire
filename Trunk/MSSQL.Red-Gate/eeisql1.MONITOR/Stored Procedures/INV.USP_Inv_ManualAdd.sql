SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [INV].[USP_Inv_ManualAdd]
(	@Operator varchar (10),
	@Part varchar (25),
	@Quantity numeric (20,6),
	@Unit char (2) = null,
	@Location varchar (20) = null,
	@UserDefinedStatus varchar (30) = 'Approved',
	@Lot varchar (10) = null,
	@Note varchar(255) = Null,
	@Serial integer output,
	@Result integer = 0 output )

/*
Example:
begin transaction

declare	@ProcReturn int,
	@ProcResult int,
	@Serial int

execute	@ProcReturn = HN.HCSP_INV_ManualAdd
	@Operator = 'MON',
	@Part = '1302121',
	@Quantity = 1900.00,
	@Unit = 'AU',
	@Location	= '',
	@UserDefinedStatus = 'Approved',
	@Lot  = '',
	@Note = 'Corte de terminal',
    @Custom2 = '',
	@Custom5 = '',
	@Serial = @Serial output,	
	@Result = @ProcResult output

select @ProcReturn,
	@ProcResult,
	@Serial

rollback
:End Example
*/
AS
SET nocount ON



set	@Result = 999999

--<Tran Required=Yes AutoCreate=Yes>
DECLARE	@TranCount SMALLINT,
		@ProcName sysname

SET	@ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)
SET	@TranCount = @@TranCount
IF	@TranCount = 0 
	BEGIN TRANSACTION @ProcName
ELSE
	SAVE TRANSACTION @ProcName
--</Tran>

--<Error Handling>
DECLARE @ProcReturn integer,	@ProcResult integer
DECLARE @Error integer,	@RowCount integer
--</Error Handling>


--	Argument Validation:
--		Operator required:
IF	NOT EXISTS
	(	SELECT	1
		FROM	employee
		WHERE	operator_code = @Operator) 
BEGIN

	SET	@Result = 60001
	RAISERROR (@Result, 16, 1, @Operator)
	ROLLBACK TRAN @ProcName
	RETURN	@Result
end

--		Part required:
IF	NOT EXISTS
	(	SELECT	1
		FROM	part
		WHERE	part = @Part) 
BEGIN
	SET	@Result = 60001
	RAISERROR ('Part "%s" not found!', 16, 1, @Part)
	ROLLBACK TRAN @ProcName
	RETURN	@Result
END

--		Quantity > 0:
IF	@Quantity !> 0 
BEGIN
	SET	@Result = 60001
	RAISERROR ('Invalid quantity [%d]!', 16, 1, @Quantity)
	ROLLBACK TRAN @ProcName
	RETURN	@Result
END

--		Unit valid or default:
SELECT	@Unit = isnull (@Unit, standard_unit)
FROM	part_inventory
WHERE	part = @Part

--		Location valid or default:
--		Machine required:
	IF	NOT EXISTS
		(	SELECT 	1
			FROM	Location
			WHERE	Code = @Location  ) BEGIN

		SET	@Result = 107304
		ROLLBACK TRAN @ProcName
		RAISERROR (@Result, 16, 1, @Location)
		RETURN	@Result
	END
	
SELECT	@Location = isnull (NULLIF(@Location,''), primary_location)
FROM	part_inventory
WHERE	part = @Part

--		Userdefined status valid:
DECLARE	@Status char (1)
SELECT	@Status = type
FROM	user_defined_status
WHERE	display_name = @UserDefinedStatus

--	I.	Get a block of serial numbers.
SELECT	@Serial = next_serial
FROM	parameters with (TABLOCKX)

WHILE	EXISTS
	(	SELECT	serial
		FROM	object
		WHERE	serial BETWEEN @Serial AND @Serial) OR
	EXISTS
	(	SELECT	serial
		FROM	audit_trail
		WHERE	serial between @Serial and @Serial) 
BEGIN
	SET	@Serial = @Serial + 1
END

UPDATE	parameters
SET	next_serial = @Serial + 1

--	II.	Create inventory.
--		A.	Adjust part online.
UPDATE	part_online
SET	on_hand = on_hand + @Quantity
WHERE	part = @Part

SELECT	@Error = @@Error, @RowCount = @@RowCount
IF	@Error != 0 begin
	SET	@Result = 200
	RAISERROR ('Error:  Unable to update part online!', 16, 1)
	ROLLBACK TRAN @ProcName
	RETURN	@Result
END

IF	@RowCount = 0 begin
	insert	part_online
	(	part,
		on_hand)
	select	@Part,
		@Quantity

	SELECT	@Error = @@Error
	IF	@Error != 0 begin
		SET	@Result = 200
		RAISERROR ('Error:  Unable to update part online!', 16, 1)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END
end

--		B.	Create object.
	INSERT	object
	(	serial,	part,
		quantity, std_quantity,
		lot, location, last_date,
		unit_measure, operator,
		status,	plant, name,
		last_time, user_defined_status,
		cost, std_cost )
	SELECT	@Serial,
		Upper(rtrim(@Part)), @Quantity,
		@Quantity, @Lot,location.code,
		last_date = GetDate (),
		unit_measure = @Unit,
		operator = @Operator,
		status = @Status, location.plant,
		part.name, last_time = GetDate (),
		@UserDefinedStatus,
		part_standard.cost_cum,
		part_standard.cost_cum
	FROM	location
		join part on part.part = @Part
		join part_inventory on part_inventory.part = @Part
		join part_standard on part_standard.part = @Part
		join user_defined_status on user_defined_status.display_name = @UserDefinedStatus
	WHERE	location.code = @Location

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
		tare_weight)
	SELECT	object.serial,
		object.last_date,
		'A',
		object.part,
		object.quantity,
		'Manual Add',
		object.operator,
		object.location,
		object.location,
		object.lot,
		object.weight,
		object.status,
		object.unit_measure,
		object.std_quantity,
		object.plant,
		@Note,
		object.package_type,
		object.cost,
		object.user_defined_status,
		object.tare_weight
	FROM	object object
	WHERE	object.serial = @Serial

SELECT	@Error = @@Error, @RowCount = @@RowCount
IF	@Error != 0 begin
	SET	@Result = 99999
	RAISERROR ('Error:  Unable to create Audit_Trail!', 16, 1)
	ROLLBACK TRAN @ProcName
	RETURN	@Result
END
IF	@RowCount != 1 begin
	SET	@Result = 99999
	RAISERROR ('RowNotFound:  Unable to create Audit_Trail!', 16, 1)
	ROLLBACK TRAN @ProcName
	RETURN	@Result
END

IF	@TranCount = 0 BEGIN
	COMMIT TRANSACTION @ProcName
END

--	III.	Success.
SET	@Result = 0
RETURN	@Result
GO
