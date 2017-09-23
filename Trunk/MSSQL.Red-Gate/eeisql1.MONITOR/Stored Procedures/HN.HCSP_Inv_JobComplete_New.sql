SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [HN].[HCSP_Inv_JobComplete_New]
(	@Operator varchar (10),
	@Part varchar (25),
	@Quantity numeric (20,6) = NULL,
	@Unit char (2) = null,
	@Location varchar (20) = null,
	@UserDefinedStatus varchar (30) = NULL,
	@Lot varchar (10) = null,
	@Note varchar(254) = Null,
    @Custom2 varchar(50) = Null,
	@Custom5 varchar(50) = Null,
	@ObjectSerial integer = 0 output,
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
	@Serial int

execute	@ProcReturn = HCSP_JobComplete_New
	@Operator = 'MON',
	@Part = ?,
	@Quantity  = NULL,
	@Unit = null,
	@Location = null,
	@UserDefinedStatus = 'Approved',
	@Lot  = null,
	@Note  = Null,
    @Custom2  = Null,
	@Custom5 = Null,

	@ObjectSerial = @Serial,
	@Result = @ProcResult output

select @ProcReturn,
	@ProcResult, @Serial 

rollback
:End Example
*/
AS
SET nocount ON
set	@Result = 999999


--	I.	Get a block of serial numbers.
--<Debug>
IF	@Debug & 1 = 1 begin
	PRINT	'I.	Start Error Handling.'
END
--</Debug>

--<Tran Required=Yes AutoCreate=Yes>
DECLARE	@TranCount SMALLINT
SET	@TranCount = @@TranCount
IF	@TranCount = 0 
	BEGIN TRANSACTION HCSP_JobComplete_New
ELSE
	SAVE TRANSACTION HCSP_JobComplete_New
--</Tran>

--<Error Handling>
DECLARE @ProcReturn integer,	@ProcResult integer
DECLARE @Error integer,	@RowCount integer
--</Error Handling>


--	I.	Get a block of serial numbers.
--<Debug>
IF	@Debug & 1 = 1 begin
	PRINT	'II.	Validating the input values'
END
--</Debug>

--	Argument Validation:
--		Operator required:
IF	NOT EXISTS
	(	SELECT	1
		FROM	employee
		WHERE	operator_code = @Operator) 
BEGIN

	SET	@Result = 60001
	ROLLBACK TRAN HCSP_JobComplete
	RAISERROR (@Result, 16, 1, @Operator)
	RETURN	@Result
END

--		Part required:
IF	NOT EXISTS
	(	SELECT	1
		FROM	part
		WHERE	part = @Part and Class = 'M') 
BEGIN

	SET	@Result = 60001
	ROLLBACK TRAN HCSP_JobComplete_New
	RAISERROR ('Part "%s" not found or must be Manufactur!', 16, 1, @Part)
	RETURN	@Result
END


--		User defined Status:
DECLARE	@Status char (1), @IsQulityAlert char(1)

IF	ISNULL(@UserDefinedStatus,'NODATA') = 'NODATA'
BEGIN

	SELECT	@IsQulityAlert = ISNULL(Quality_Alert,'N')
	FROM	Part
	WHERE	Part = @Part

	IF @IsQulityAlert = 'Y'
		BEGIN
			SELECT	@UserDefinedStatus = Max(Display_name)
			FROM	user_defined_status
			WHERE	Base = 'Y' AND Type = 'H'
		END
	ELSE
		BEGIN
			SELECT	@UserDefinedStatus = Max(Display_name)
			FROM	user_defined_status
			WHERE	Base = 'Y' AND Type = 'A'
		END
END

IF	NOT EXISTS
	(	SELECT	1
		FROM	user_defined_status
		WHERE	Display_name = @UserDefinedStatus) 
BEGIN

	SET	@Result = 60001
	ROLLBACK TRAN HCSP_JobComplete_New
	RAISERROR ('Status "%s" not found', 16, 1, @UserDefinedStatus)
	RETURN	@Result
END

SELECT	@Status = Type
FROM	user_defined_status
WHERE	display_name = @UserDefinedStatus


--		Unit valid or default:
SELECT	@Unit = isnull (@Unit, standard_unit)
FROM	part_inventory
WHERE	part = @Part

--		Location valid or default:
SELECT	@Location = isnull (@Location, primary_location), @Quantity = isnull(@Quantity, standard_pack)
FROM	part_inventory
WHERE	part = @Part

--		Userdefined status valid:


--		Get the Package Type:
DECLARE	@BoxType char (20)
SELECT	@BoxType = Min(Code)
FROM	part_packaging
WHERE	Part = @Part

--		Quantity > 0:
IF	@Quantity !> 0 
BEGIN
	SET	@Result = 60001
	ROLLBACK TRAN HCSP_JobComplete_New
	RAISERROR ('Invalid quantity [%d]!', 16, 1, @Quantity)
	RETURN	@Result
END


--	I.	Get a block of serial numbers.
--<Debug>
IF	@Debug & 1 = 1 begin
	PRINT	'III. Get the new serial for the transaction'
END
--</Debug>

SELECT	@ObjectSerial = next_serial
FROM	parameters with (TABLOCKX)

WHILE	EXISTS
	(	SELECT	serial
		FROM	object
		WHERE	serial BETWEEN @ObjectSerial AND @ObjectSerial) OR
	EXISTS
	(	SELECT	serial
		FROM	audit_trail
		WHERE	serial between @ObjectSerial and @ObjectSerial) 
BEGIN
	SET	@ObjectSerial = @ObjectSerial + 1
END

UPDATE	parameters
SET	next_serial = @ObjectSerial + 1

--	II.	Create inventory.
--		A.	Adjust part online.
--	I.	Get a block of serial numbers.
--<Debug>
IF	@Debug & 1 = 1 begin
	PRINT	'IV.	Update Part Online.'
END
--</Debug>


UPDATE	part_online
SET	on_hand = on_hand + @Quantity
WHERE	part = @Part

SELECT	@Error = @@Error, @RowCount = @@RowCount
IF	@Error != 0 begin
	SET	@Result = 200
	ROLLBACK TRAN HCSP_JobComplete_New
	RAISERROR ('Error:  Unable to update part online!', 16, 1)
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
		ROLLBACK TRAN HCSP_JobComplete_New
		RAISERROR ('Error:  Unable to update part online!', 16, 1)
		RETURN	@Result
	END
end


--	I.	Get a block of serial numbers.
--<Debug>
IF	@Debug & 1 = 1 begin
	PRINT	'V.	Create the new object'
END
--</Debug>

--		A.	Check for PO if is Mit
declare @PO varchar(20)

if	left(@Part, 7) = 'MIT0005' begin

	select	@PO = Min(convert(int,PONumber))
	from	hn.mitsubishi_inventory MitPOs
			left join (	select po_number, Qty = SUM(std_quantity)
					from	audit_trail
					where	part like 'MIT0005%'
							and type = 'P'
					group by po_number) poqty on poqty.po_number = MitPOs.PONumber
	where	Status = 'O'
			and MitPOs.Quantity > (isnull(poqty.Qty,0) + @Quantity)
			

	if @PO is null begin 
		set	@Result = 70001
		rollback tran ProdControlNewPreObject
		RAISERROR (@Result, 16, 1, 'No hay PO para Mitsubishi, hablar con el ingenerio de calidad.')
		return	@Result
	end
end


--		B.	Create object.
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
		user_defined_status,
		cost,
		std_cost,
		package_type,
		po_number )
	SELECT	@ObjectSerial,
		UPPER(@Part),
		@Quantity,
		@Quantity,
		@Lot,
		location.code,
		GetDate (),
		@Unit,
		@Operator,
		@Status,
		location.plant,
		part.name,
		GetDate (),
		@UserDefinedStatus,
		part_standard.cost_cum,
		part_standard.cost_cum,
		@BoxType,
		@PO
	FROM	location
		join part on part.part = @Part
		join part_inventory on part_inventory.part = @Part
		join part_standard on part_standard.part = @Part
		join user_defined_status on user_defined_status.display_name = @UserDefinedStatus
	WHERE	location.code = @Location

--Validate the Object insert, happen
	SELECT	@Error = @@Error, @RowCount = @@RowCount
	IF	@Error != 0 begin
		SET	@Result = 300
		ROLLBACK TRAN HCSP_JobComplete_New
		RAISERROR ('Error:  Unable to create object!', 16, 1)
		RETURN	@Result
	END

	IF	@RowCount != 1 begin
		SET	@Result = 300
		ROLLBACK TRAN HCSP_JobComplete_New
		RAISERROR ('RowNotFound:  Unable to create object!', 16, 1)
		RETURN	@Result
	END

--		C.	Write to audit_trail.
--	I.	Get a block of serial numbers.
--<Debug>
IF	@Debug & 1 = 1 begin
	PRINT	'VI. Insert the new Object on Audit Trail'
END
--</Debug>

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
		Custom2, 
		Custom5,
		po_number/*, SupplierLot*/)
	SELECT	object.serial,
		object.last_date,
		'P',
		object.part,
		object.quantity,
		'PRE-OBJECT',
		object.operator,
		object.location,
		object.location,
		object.lot,
		object.weight,
		status = 'H',
		object.unit_measure,
		object.std_quantity,
		object.plant,
		note ='Pre-Object.',
		object.package_type,
		object.cost,
		object.user_defined_status,
		object.tare_weight, 
		@Custom2, 
		@Custom5,
		po_number--, SupplierLot
	FROM	object
	WHERE	object.serial = @ObjectSerial

--Validate the Object insert, happen
	SELECT	@Error = @@Error, @RowCount = @@RowCount
	IF	@Error != 0 begin
		SET	@Result = 300
		ROLLBACK TRAN HCSP_JobComplete_New
		RAISERROR ('Error:  Unable to create the Pre-Object in Audit_trail!', 16, 1)
		RETURN	@Result
	END

	IF	@RowCount != 1 begin
		SET	@Result = 300
		ROLLBACK TRAN HCSP_JobComplete_New
		RAISERROR ('RowNotFound:  Unable to create Pre-Object in Audit_trail!', 16, 1)
		RETURN	@Result
	END



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
		Custom2, 
		Custom5/*, SupplierLot*/)
	SELECT	object.serial,
		object.last_date,
		'J',
		object.part,
		object.quantity,
		'Job Comp',
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
		object.tare_weight, 
		@Custom2, 
		@Custom5--, SupplierLot
	FROM	object object
	WHERE	object.serial = @ObjectSerial

--Validate the Object insert, happen
	SELECT	@Error = @@Error, @RowCount = @@RowCount
	IF	@Error != 0 begin
		SET	@Result = 300
		ROLLBACK TRAN HCSP_JobComplete_New
		RAISERROR ('Error:  Unable to create JC in AuditTrail!', 16, 1)
		RETURN	@Result
	END

	IF	@RowCount != 1 begin
		SET	@Result = 300
		ROLLBACK TRAN HCSP_JobComplete_New
		RAISERROR ('RowNotFound:  Unable to create JC in AuditTrail!', 16, 1)
		RETURN	@Result
	END



--DEM Oct 31ST-2016.	Insert To table if part is ING


--	I.	Get a block of serial numbers.
--<Debug>
IF	@Debug & 1 = 1 begin
	PRINT	'VII.	Commit the Transacction.'
END
--</Debug>

--<CloseTran Required=Yes AutoCreate=Yes>
IF	@TranCount = 0 BEGIN
	COMMIT TRANSACTION HCSP_JobComplete_New
END
--</CloseTran Required=Yes AutoCreate=Yes>

--	III.	Success.
SET	@Result = 0
RETURN	@Result

GO
