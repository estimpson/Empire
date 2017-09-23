SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [HN].[HCSP_Inv_Combine_New]
(	@Operator varchar (10),
	@Master_Serial int,
	@Child_Serial int,
	@Quantity numeric (20,6) = NULL,
	@Result integer = 0 output
--<Debug>
	, @Debug integer = 0,
	@AllowCombineOnHold char(1) = 'N'
--</Debug>
)
/*
Example:
begin transaction

declare	@ProcReturn int,
	@ProcResult int,
	@Master_Serial int,
	@Child_Serial int


execute	@ProcReturn = HN.HCSP_Inv_Combine_New
	@Operator = 'MON',
	@Master_Serial = 37259463,
	@Child_Serial = 37296111,
	@AllowCombineOnHold = 'N',
	@Result = @ProcResult output

select @ProcReturn,
	@ProcResult

rollback
:End Example
*/
as

SET nocount ON
SET	@Result = 999999

--<Tran Required=Yes AutoCreate=Yes>
DECLARE	@TranCount SMALLINT
SET	@TranCount = @@TranCount

declare	@TranDT datetime
set	@TranDT = getdate()


IF	@TranCount = 0 
	BEGIN TRANSACTION HCSP_Inv_Combine_New
ELSE
	SAVE TRANSACTION HCSP_Inv_Combine_New
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
	ROLLBACK TRAN HCSP_Inv_Combine_New
	RAISERROR (@Result, 16, 1, @Operator)
	RETURN	@Result
end


--Validate Serials
if	ISNULL(@AllowCombineOnHold, 'N' ) = 'N' Begin
	IF	NOT EXISTS
		(	SELECT	1
			FROM	object
			WHERE	Serial = @Master_Serial and Status = 'A') 
	BEGIN

		SET	@Result = 100001
		ROLLBACK TRAN HCSP_Inv_Combine_New
		RAISERROR ('La serie especificada %d no es valida. Esta en estado OnHold', 16, 1, @Master_Serial)
		print'1'
		RETURN	@Result
	end


	IF	NOT EXISTS
		(	SELECT	1
			FROM	object
			WHERE	Serial = @Child_Serial and Status = 'A') 
	BEGIN

		SET	@Result = 100001
		ROLLBACK TRAN HCSP_Inv_Combine_New
		RAISERROR ('La serie especificada %d no es valida. Esta en estado OnHold', 16, 1, @Child_Serial)
		--RAISERROR (@Result, 16, 1, @Child_Serial)
		print'2'
		RETURN	@Result
	end
end

if	@Master_Serial = @Child_Serial begin
	SET	@Result = 100001
	ROLLBACK TRAN HCSP_Inv_Combine_New
	RAISERROR ('The original serial %d is iqual to the child %d', 16, 1, @Master_Serial, @Child_Serial)
	print'3'
	RETURN	@Result	  	                               	
end

--El lote se considera por dia
if	exists(	select 1
			from	object
					join part_inventory on object.part = part_inventory.part
			where	Serial = @Master_Serial
					and isnull( part_inventory.shelf_life_days,0) > 0 and quantity >0) begin  
	if	isnull( Convert(date, (select	start_date 
  				 from object 
  				 where serial = @Master_Serial )), '1/1/1999') <>
		isnull( Convert(date, (select	start_date 
  				 from object 
  				 where serial = @Child_Serial )), '1/1/1999') begin
		set	@Result = 100010
		rollback tran HCSP_Inv_Combine_New
		raiserror (@Result, 16, 1, @Master_Serial, @Child_Serial)
		print'4'
		return	@Result	  	                               	
	end
end

-- Validate part name that both part are the same
	DECLARE	@Part varchar(25), @Object_Quantity decimal(20,6), @Field1 varchar(10),@custom4Child varchar(200),@custom4Master varchar(200),@NewCustom varchar(200)
	SELECT	@Part = Part, 
			@Object_Quantity = Quantity, 
			@Quantity = ISNULL( @Quantity, Quantity),
			@Field1 = field1,
			@custom4Child = custom4
		FROM Object 
		WHERE Serial = @Child_Serial

	SELECT @custom4Master=custom4
	FROM Object 
	WHERE Serial = @Master_Serial

	Select @NewCustom =(Select max(id) from  (Select id=@custom4Child union all Select  id=@custom4Master) x )


	IF @Part <> (Select	Part 
				FROM	Object
				WHERE	Serial = @Master_Serial)
	BEGIN
		SET	@Result = 60102
		ROLLBACK TRAN HCSP_Inv_Combine_New
		RAISERROR (@Result, 16, 1)
		print'5'
		RETURN	@Result
	END


if	exists(	select	1
			from	part_eecustom
			where	part = @Part
					and isnull(Require_Lot,'N') = 'Y' ) begin
	if	(	select	Lot = isnull(lot,'')
			from	object
			where	serial = @Master_Serial ) != 
		(	select	Lot = isnull(lot,'')
			from	object
			where	serial = @Child_Serial )  begin
		SET	@Result = 99999
		ROLLBACK TRAN HCSP_Inv_Combine_New
		RAISERROR ('Las series a combinar tienen diferente lote, y este es requiredo por la parte.', 16, 1)
		print'6'
		RETURN	@Result	
	end
end


--Validate the Quantity to be combined is less o iqual to the object
	IF @Object_Quantity < @Quantity
	BEGIN
		SET	@Result = 60103
		ROLLBACK TRAN HCSP_Inv_Combine_New
		RAISERROR (@Result, 16, 1)
		print'7'
		RETURN	@Result
	END		

---- Validar si la serie es un PRE-Object y no tiene jobcomplete
---- 2008/10/14 Hecho por Roberto Larios
if exists (select 1
           from audit_trail at
           where at.type='P' and at.remarks='PRE-OBJECT' and at.serial=@Master_Serial)
BEGIN           	          
	if not EXISTS
			(select 1
				from audit_trail at 
				where at.type='J' and at.serial=@Master_Serial)
	BEGIN
		SET	@Result = 100001
		ROLLBACK TRAN HCSP_Inv_Combine_New
		RAISERROR ('The serial # is a PRE-OBJECT and doesnt have a JOBCOMPLETE', 16, 1, @Master_Serial)
		print'8'
		RETURN	@Result		
	END
END

if exists (select 1
           from audit_trail at
           where at.type='P' and at.remarks='PRE-OBJECT' and at.serial=@Child_Serial)
BEGIN           	          
	if not EXISTS
			(select 1
				from audit_trail at 
				where at.type='J' and at.serial=@Child_Serial)
	BEGIN
		SET	@Result = 100001
		ROLLBACK TRAN HCSP_Inv_Combine_New
		RAISERROR ('The serial # is a PRE-OBJECT and doesnt have a JOBCOMPLETE', 16, 1, @Child_Serial)
		print'9'
		RETURN	@Result		
	END
END

--Location on Inventario
--Modificado por Roberto Larios Agos/08/2010
If (Select location.group_no
		from object inner join location on object.location=location.code 
		where serial=@Master_Serial)='INVENTARIO' or
	(Select location.group_no
		from object inner join location on object.location=location.code 
		where serial=@Child_Serial)='INVENTARIO' begin
	SET	@Result = 100001
		ROLLBACK TRAN HCSP_Inv_Combine_New
		RAISERROR ('One of the series has a location in INVENTORY', 16, 1, @Master_Serial,@Child_Serial)
		print'10'
		RETURN	@Result
	end 


--	II.	Start the update of the Inventory
--		A.	Write to audit_trail.
	INSERT	audit_trail
	(	serial,	date_stamp, type, part,
		quantity, remarks, operator, from_loc,
		to_loc, lot, weight, status, unit,
		std_quantity, plant, package_type,
		cost, std_cost, user_defined_status,
		tare_weight, field1, start_date, custom5/*, SupplierLot*/)
	SELECT	serial, date_stamp = @TranDT,
		type = 'C', Part, Quantity,
		remarks = 'Combine',operator = @Operator,
		from_loc = location, to_loc = @Master_Serial,
		lot = lot, weight, status,
		unit_measure, std_quantity,
		plant, package_type, cost,
		std_cost, user_defined_status,
		tare_weight, field1, start_date, custom5--, SupplierLot
	FROM	object
	WHERE	serial = @Child_Serial


	SELECT	@Error = @@Error, @RowCount = @@RowCount
	IF	@Error != 0 begin
		SET	@Result = 60106
		ROLLBACK TRAN HCSP_Inv_Combine_New
		RAISERROR (@Result, 16, 1)
		print'11'
		RETURN	@Result
	END

	IF	@RowCount = 0 begin
		SET	@Result = 60105
		ROLLBACK TRAN HCSP_Inv_Combine_New
		RAISERROR (@Result, 16, 1)
		print'12'
		RETURN	@Result
	END


--	B. Update the Master Object with the new Quantity
	UPDATE	object
	SET		Quantity = Quantity + @Quantity, 
			std_quantity = std_quantity + @Quantity,
			Last_date = @TranDT, 
			Operator = @Operator, 
			Last_Time = @TranDT,
			Field1 = isnull( nullif( field1, ''), @Field1),
			custom4 = isnull( nullif( @NewCustom, ''), @NewCustom)
	WHERE	SERIAL =  @Master_Serial

	SELECT	@Error = @@Error, @RowCount = @@RowCount
	IF	@Error != 0 begin
		SET	@Result = 60108
		ROLLBACK TRAN HCSP_Inv_Combine_New
		RAISERROR (@Result, 16, 1)
		print'13'
		RETURN	@Result
	END

	IF	@RowCount = 0 begin
		SET	@Result = 60107
		ROLLBACK TRAN HCSP_Inv_Combine_New
		RAISERROR (@Result, 16, 1)
		print'14'
		RETURN	@Result
	END



--Insert in Audit_trail the child info
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
		package_type,
		cost,
		std_cost,
		user_defined_status,
		tare_weight,
		start_date,
		custom5/*, SupplierLot*/)
	SELECT	object.serial,
		@TranDT,
		'C',
		Part,
		@Quantity,
		'Combine-Re',
		@Operator,
		convert( varchar, @Child_Serial),
		Location,
		object.lot,
		object.weight,
		object.status,
		object.unit_measure,
		@Quantity,
		object.plant,
		object.package_type,
		object.cost,
		object.std_cost,
		object.user_defined_status,
		object.tare_weight,
		object.start_date,
		custom5--, SupplierLot
	FROM	object object
	WHERE	object.serial = @Master_Serial


	SELECT	@Error = @@Error, @RowCount = @@RowCount
	IF	@Error != 0 begin
		SET	@Result = 60106
		ROLLBACK TRAN HCSP_Inv_Combine_New
		RAISERROR (@Result, 16, 1)
		RETURN	@Result
	END

	IF	@RowCount = 0 begin
		SET	@Result = 60105
		ROLLBACK TRAN HCSP_Inv_Combine_New
		RAISERROR (@Result, 16, 1)
		print'15'
		RETURN	@Result
	END

--	C. Update the Child Object with the new Quantity

	IF @Object_Quantity = @Quantity
		BEGIN
			DELETE FROM object WHERE serial = @Child_Serial
		END
	ELSE
		BEGIN
			UPDATE	object
			SET		Quantity = Quantity - @Quantity, 
					std_quantity = std_quantity  - @Quantity,
					Last_date = @TranDT, 
					Operator = @Operator, 
					Last_Time = @TranDT
			WHERE	SERIAL =  @Child_Serial	
			
		END

	SELECT	@Error = @@Error, @RowCount = @@RowCount
	IF	@Error != 0 begin
		SET	@Result = 60108
		ROLLBACK TRAN HCSP_Inv_Combine_New
		RAISERROR (@Result, 16, 1)
		print'16'
		RETURN	@Result
	END

	IF	@RowCount = 0 begin
		SET	@Result = 60107
		ROLLBACK TRAN HCSP_Inv_Combine_New
		RAISERROR (@Result, 16, 1)
		print'17'
		RETURN	@Result
	END

--<CloseTran Required=Yes AutoCreate=Yes>
IF	@TranCount = 0 BEGIN
	COMMIT TRANSACTION HCSP_Inv_Combine_New
END
--</CloseTran Required=Yes AutoCreate=Yes>

--insert into dos select 99

--	III.	Success.
SET	@Result = 0
RETURN	@Result
Select	*
from	part_machine
where	part like '%W-mos%'
GO
