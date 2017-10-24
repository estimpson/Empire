SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [HN].[HCSP_Inv_Material_Issue]( 
		@Operator varchar(5),
		@Serial int, 
		@Machine varchar(10),
		@Quantity  numeric (20,6) = NULL, 
		@Custom4 varchar(50) = NULL, 
		@Note varchar(250) = NULL,
		@Result integer = 0 output,
--<Debug>
		@Debug integer = 0,
		@Excess integer = 0
--</Debug>
) AS
/*
Example:
begin transaction

declare	@ProcReturn int,
	@ProcResult int,
	@ShipperID int,
	@Serial int

select	@Serial = Max(Serial)
from	Object

select	Serial, Part, Quantity, location
from	Object
where	serial = 30049432


select	Machine_no
from	Machine
where	Machine_no like 'Piso%'

set	@Serial = 30049432


execute	@ProcReturn = HN.[HCSP_Inv_Material_Issue]
	@Operator = 'MON',
	@Serial = @Serial,
	@Machine = 'TRAN1-41TU',
	@Quantity =  NULL,
	@Custom4 = NULL,
	@Note = 'Material Issue Requested by Rodolfo Hernadez',
	@Result = @ProcResult output,
	@Debug = 1

select	@ProcReturn,
	@ProcResult


select	*
from	object 
where	Serial  = @Serial

select	*
from	Audit_Trail
where	Serial  = @Serial

select	*
from	Audit_Trail
where	(Serial  = @Serial or Serial = 848026) and Type = 'M'

rollback
:End Example
*/

SET nocount ON
SET	@Result = 999999

--<Tran Required=Yes AutoCreate=Yes>
DECLARE	@TranCount smallint
DECLARE @FromLoc varchar(10), @Plant varchar(10)
DECLARE @Object_Quantity numeric(20,6), @Part varchar(25)

--<Error Handling>
DECLARE @ProcReturn integer, @ProcResult integer
DECLARE @Error integer,	@RowCount integer

SET	@TranCount = @@TranCount
IF	@TranCount = 0 
	BEGIN TRANSACTION HCSP_Material_Issue
ELSE
	SAVE TRANSACTION HCSP_Material_Issue
--</Error Handling>


--	I.	Get a block of serial numbers.
--<Debug>
IF	@Debug & 1 = 1 begin
	PRINT	'I.	Validating the paramenters.'
END
--</Debug>


--	Argument Validation:
--		Operator required:
	IF	NOT EXISTS
		(	SELECT 	1
			FROM	employee
			WHERE	operator_code = @Operator) BEGIN

		SET	@Result = 60001
		ROLLBACK TRAN HCSP_Material_Issue
		RAISERROR (@Result, 16, 1, @Operator)
		RETURN	@Result
	END

--		Serial required:
	IF	NOT EXISTS
		(	SELECT 	1
			FROM	object
			WHERE	serial = @Serial AND status = 'A') BEGIN

		SET	@Result = 100001
		ROLLBACK TRAN HCSP_Material_Issue
		RAISERROR (@Result, 16, 1, @Serial)
		RETURN	@Result
	END

--		Machine required:
	--IF	NOT EXISTS
	--	(	SELECT 	1
	--		FROM	Location
	--		WHERE	Code = @Machine  ) BEGIN

	--	SET	@Result = 107304
	--	ROLLBACK TRAN HCSP_Material_Issue
	--	RAISERROR (@Result, 16, 1, @Machine)
	--	RETURN	@Result
	--END
	
	-- Validate the Quantity
	SELECT	@Part = Part, 
			@Object_Quantity = Quantity, 
			@Quantity = ISNULL( @Quantity, Quantity) 
		FROM Object 
		WHERE Serial = @Serial

	IF @Object_Quantity < @Quantity and @Excess = 0
	BEGIN
		SET	@Result = 107304
		ROLLBACK TRAN HCSP_Material_Issue
		RAISERROR (107305, 16, 1)
		RETURN	@Result
	END	
	
---- Validar si la serie es un PRE-Object y no tiene jobcomplete
---- 2008/10/14 Hecho por Roberto Larios
if exists (select 1
           from audit_trail at
           where at.type='P' and at.remarks='PRE-OBJECT' and at.serial=@Serial)
BEGIN           	          
	if not EXISTS
			(select 1
				from audit_trail at 
				where at.type='J' and at.serial=@Serial)
	BEGIN
		SET	@Result = 100001
		ROLLBACK TRAN HCSP_Material_Issue
		RAISERROR ('The serial # is a PRE-OBJECT and doesnt have a JOBCOMPLETE', 16, 1, @Serial)
		RETURN	@Result		
	END
END

declare @TranDT datetime, @Audit_trailID int

set	@TranDT  = getdate()

if	@Excess > 0 and  @Object_Quantity < @Quantity  begin

		insert	audit_trail
		(	serial, date_stamp, type, part, quantity, remarks, price,
			operator, from_loc, to_loc, on_hand, lot, weight, status, unit,
			workorder, std_quantity, cost, custom1, custom2, custom3,
			custom4, custom5, plant, notes, gl_account, std_cost,
			user_defined_status, part_name, tare_weight)
		select	serial = object.serial, date_stamp = @TranDT, 
			type = 'E', part = object.part,
			quantity = -(@Quantity  - quantity), 
			remarks = 'Excess', price = 0,
			operator = object.operator, from_loc = object.location, to_loc = 'S',
			on_hand = IsNull (part_online.on_hand, 0) +
			(	case	when object.status = 'A' then object.std_quantity
					else 0
				end), lot = object.lot, weight = object.weight,
			status = object.status, unit = object.unit_measure,
			workorder = object.workorder, std_quantity = -(@Quantity  - quantity), 
			cost = object.cost,
			custom1 = object.custom1, custom2 = object.custom2, custom3 = object.custom3,
			custom4 = object.custom4, custom5 = object.custom5, plant = object.plant,
			notes = '', gl_account = '', std_cost = object.cost,
			user_defined_status = object.user_defined_status, part_name = object.name, tare_weight = object.tare_weight
		from	object
			left outer join part_online on object.part = part_online.part
			join part on object.part = part.part
		where	object.serial = @Serial

		set	@Error = @@Error
		set	@RowCount = @@Rowcount
		set	@Audit_trailID = SCOPE_IDENTITY()
                	
		if	@Error != 0 begin
			set	@Result = 999999
			RAISERROR (@Result, 16, 1, 'HCSP_BF_Report_Purge:Insert Audit_Trail')
			rollback tran HCSP_Material_Issue
			return	@Result
		end
		if	@RowCount != 1 begin
			set	@Result = 999999
			rollback tran HCSP_Material_Issue
			RAISERROR (@Result, 16, 1, 'HCSP_BF_Report_Purge:Insert Audit_Trail')
			return	@Result
		end

		insert	Defects
			(	machine, part, reason, quantity,
				operator,  shift, work_order, data_source,defect_date,defect_time)
		select	    Machine = location,
				Part = object.part, DefectCode = 'Qty Excess',
				QtyScrapped = -(@Quantity  - quantity), Operator = @Operator,
				Shift =  'A', WODID = null,
				DefectSerial = serial,
				DATEADD(dd, 0, DATEDIFF(dd, 0, @TranDT)),@TranDT
		from	object
		where	serial = @Serial

			select	@Error = @@Error,
				@RowCount = @@Rowcount

			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR (@Result, 16, 1, 'HCSP_BF_Report_Purge:Insert Defect Data')
				rollback tran HCSP_Material_Issue
				return	@Result
			end

			if	@RowCount != 1 begin
				print @Serial
				set	@Result = 999999
				RAISERROR (@Result, 16, 1, 'HCSP_BF_Report_Purge:Insert Defect Data')
				rollback tran HCSP_Material_Issue
				return	@Result
			end


end

--	II.	Create inventory.
--    A. Ajust the Get the Extra info require
--<Debug>
IF	@Debug & 1 = 1 begin
	PRINT	'II.	Ajusting Parts online'
END
--</Debug>

	SELECT @Plant = location.plant FROM location  WHERE location.code = @Machine 
	

--<Debug>
IF	@Debug & 1 = 1 begin
	PRINT	'III.	Insert Audit_Trail'
END
--</Debug>

--		B.	Write to audit_trail.
	INSERT	audit_trail
	(	serial,	date_stamp,
		type,part, quantity,
		remarks, operator,
		from_loc, to_loc,		
		lot, weight,
		status, unit,
		std_quantity,
		plant, notes,
		package_type,
		std_cost,
		user_defined_status,
		tare_weight, Custom4 )
	SELECT	object.serial,
		Datestamp = @TranDT, Type = 'M',
		object.part, Quantity = @Quantity,
		Remarks = 'Mat Issue',
		@Operator,
		object.location,
		@Machine,
		object.lot,
		object.weight,
		object.status,
		object.unit_measure,
		@Quantity,
		object.plant,
		@Note,
		object.package_type,
		object.cost,
		object.user_defined_status,
		object.tare_weight, 
		@Custom4 
	FROM	object object
	WHERE	object.serial = @Serial


--  Validate if the operation on the Audit Trail is succesfull
	SELECT	@Error = @@Error, @RowCount = @@RowCount
	IF	@Error != 0 begin
		SET	@Result = 300
		ROLLBACK TRAN HCSP_Material_Issue
		RAISERROR ('Error:  Unable to update object Table!', 16, 1)
		RETURN	@Result
	END

	IF	@RowCount = 0 begin
		SET	@Result = 800
		ROLLBACK TRAN HCSP_Material_Issue
		RAISERROR ('Error:  No row Updated on object Table!', 16, 1)
		RETURN	@Result
	END

--  C. Remove the data from the inventory
--<Debug>
IF	@Debug & 1 = 1 begin
	PRINT	'IV.	Delete Objects'
END
--</Debug>

	IF @Object_Quantity = @Quantity
		BEGIN
			DELETE FROM object WHERE serial = @Serial
		END
	ELSE
		BEGIN
			UPDATE	object
			SET		Quantity = Quantity - @Quantity, 
					std_quantity = std_quantity  - @Quantity,
					Last_date = Getdate(), 
					Operator = @Operator, 
					Last_Time = Getdate()
			WHERE	SERIAL =  @Serial
		END

	SELECT	@Error = @@Error, @RowCount = @@RowCount
	IF	@Error != 0 begin
		SET	@Result = 300
		ROLLBACK TRAN HCSP_Material_Issue
		RAISERROR ('Error:  Unable to update object Table!', 16, 1)
		RETURN	@Result
	END

	IF	@RowCount = 0 begin
		SET	@Result = 800
		ROLLBACK TRAN HCSP_Material_Issue
		RAISERROR ('Error:  No row Updated on object Table!', 16, 1)
		RETURN	@Result
	END

--	  D.	Adjust part online.
	UPDATE	part_online
	SET	on_hand = isnull((SELECT sum( Quantity) FROM Object WHERE Part = @Part and Status = 'A' ),0)
	WHERE	part = @Part

	SELECT	@Error = @@Error, @RowCount = @@RowCount
	IF	@Error != 0 begin
		SET	@Result = 200
		ROLLBACK TRAN HCSP_Material_Issue
		RAISERROR ('Error:  Unable to update part online!', 16, 1)
		RETURN	@Result
	END

	IF	@RowCount = 0 begin
		insert	part_online
		(	part,
			on_hand)
			Values(	@Part, 0 )

		SELECT	@Error = @@Error
		IF	@Error != 0 begin
			SET	@Result = 200
			ROLLBACK TRAN HCSP_Material_Issue
			RAISERROR ('Error:  Unable to insert on part online!', 16, 1)
			RETURN	@Result
		END
	END



--<CloseTran Required=Yes AutoCreate=Yes>
IF	@TranCount = 0 BEGIN
	COMMIT TRANSACTION HCSP_Material_Issue
END
--</CloseTran Required=Yes AutoCreate=Yes>

--	III.	Success.
SET	@Result = 0
RETURN	@Result
GO
GRANT EXECUTE ON  [HN].[HCSP_Inv_Material_Issue] TO [APPUser]
GO
