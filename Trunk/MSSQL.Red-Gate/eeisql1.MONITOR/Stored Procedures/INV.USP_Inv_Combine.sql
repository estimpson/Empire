SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [INV].[USP_Inv_Combine]
(	@Operator varchar (5),
	@Master_Serial int,
	@Child_Serial int,
	@Quantity numeric (20,6) = NULL,
	@Result integer = 0 output
)
/*
Example:
begin transaction

declare	@ProcReturn int,
	@ProcResult int,
	@Master_Serial int,
	@Child_Serial int


execute	@ProcReturn = INV.USP_Inv_Combine
	@Operator = '550',
	@Master_Serial = 1258881,
	@Child_Serial = 1259582,
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
		, @ProcName sysname
		, @TranDT datetime 

SET	@ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)
SET	@TranCount = @@TranCount
set @TranDT=getdate()

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


--Validate Serials
if	@Master_Serial = @Child_Serial begin
	SET	@Result = 100001
	RAISERROR ('The original serial %d is iqual to the child %d', 16, 1, @Master_Serial, @Child_Serial)
	ROLLBACK TRAN @ProcName
	RETURN	@Result	  	                               	
end


if	isnull( (select	start_date 
  	         from object 
  	         where serial = @Master_Serial ), '1/1/1999') <>
	isnull( (select	start_date 
  	         from object 
  	         where serial = @Child_Serial ), '1/1/1999') begin
	set	@Result = 100010
	raiserror (@Result, 16, 1, @Master_Serial, @Child_Serial)
	rollback tran @ProcName
	return	@Result	  	                               	
end


-- Validate part name that both part are the same
	DECLARE	@Part varchar(25), @Object_Quantity decimal(20,6), @Field1 varchar(10)
	SELECT	@Part = Part, 
			@Object_Quantity = Quantity, 
			@Quantity = ISNULL( @Quantity, Quantity),
			@Field1 = field1
		FROM Object 
		WHERE Serial = @Child_Serial


	IF @Part <> (Select	Part 
				FROM	Object
				WHERE	Serial = @Master_Serial)
	BEGIN
		SET	@Result = 60102
		RAISERROR (@Result, 16, 1)
		ROLLBACK TRAN @ProcName
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
		RAISERROR ('The serials to combine has different Lot, combine can not be done.', 16, 1)
		ROLLBACK TRAN @ProcName
		RETURN	@Result	
	end
end


--Validate the Quantity to be combined is less o iqual to the object
	IF @Object_Quantity < @Quantity
	BEGIN
		SET	@Result = 60103
		RAISERROR (@Result, 16, 1)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END		

--	II.	Start the update of the Inventory
--		A.	Write to audit_trail.
	INSERT	audit_trail
	(	serial,	date_stamp, type, part,
		quantity, remarks, operator, from_loc,
		to_loc, lot, weight, status, unit,
		std_quantity, plant, package_type,
		cost, std_cost, user_defined_status,
		tare_weight, field1, start_date)
	SELECT	serial, date_stamp = @TranDT,
		type = 'C', Part, Quantity,
		remarks = 'Combine',operator = @Operator,
		from_loc = location, to_loc = @Master_Serial,
		lot = lot, weight, status,
		unit_measure, std_quantity,
		plant, package_type, cost,
		std_cost, user_defined_status,
		tare_weight, field1, start_date 
	FROM	object
	WHERE	serial = @Child_Serial


	SELECT	@Error = @@Error, @RowCount = @@RowCount
	IF	@Error != 0 begin
		SET	@Result = 60106
		RAISERROR (@Result, 16, 1)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END

	IF	@RowCount = 0 begin
		SET	@Result = 60105
		RAISERROR (@Result, 16, 1)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END


--	B. Update the Master Object with the new Quantity
	UPDATE	object
	SET		Quantity = Quantity + @Quantity, 
			std_quantity = std_quantity + @Quantity,
			Last_date = @TranDT, 
			Operator = @Operator, 
			Last_Time = @TranDT,
			Field1 = isnull( nullif( field1, ''), @Field1)
	WHERE	SERIAL =  @Master_Serial

	SELECT	@Error = @@Error, @RowCount = @@RowCount
	IF	@Error != 0 begin
		SET	@Result = 60108
		RAISERROR (@Result, 16, 1)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END

	IF	@RowCount = 0 begin
		SET	@Result = 60107
		RAISERROR (@Result, 16, 1)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END



--Insert in Audit_trail the child info
	INSERT	audit_trail
	(	serial,	date_stamp, type, part,
		quantity, remarks, operator, from_loc,
		to_loc, lot, weight, status, unit, std_quantity,
		plant, package_type, cost, std_cost, user_defined_status,
		tare_weight, start_date )
	SELECT	object.serial, @TranDT, type= 'C', Part, @Quantity,
		remarks= 'Combine-Re', @Operator, from_loc= convert( varchar, @Child_Serial),
		Location, lot, weight, status, unit_measure, @Quantity,
		plant, package_type, cost, std_cost, user_defined_status,
		tare_weight, start_date
	FROM	object
	WHERE	serial = @Master_Serial


	SELECT	@Error = @@Error, @RowCount = @@RowCount
	IF	@Error != 0 begin
		SET	@Result = 60106
		RAISERROR (@Result, 16, 1)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END

	IF	@RowCount = 0 begin
		SET	@Result = 60105
		RAISERROR (@Result, 16, 1)
		ROLLBACK TRAN @ProcName
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
		RAISERROR (@Result, 16, 1)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END

	IF	@RowCount = 0 begin
		SET	@Result = 60107
		RAISERROR (@Result, 16, 1)
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
