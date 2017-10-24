SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE Procedure [HN].[HCSP_Inv_Change_Object_Status_New]( 
				@Operator varchar(10),
				@lngSerial int, 
				@strUserDefinedStatus varchar(30), 
				@Note as varchar(254) = NULL, 
				@Result int OUTPUT 
--<Debug>
	, @Debug integer = 0
--</Debug>

) as 

/*

Begin Tran
	
	declare @Result int
	Exec HN.HCSP_Inv_Change_Object_Status 'mon', 71400402, 'Approved',  '', @Result out
	print @result

rollback

*/
SET NOCOUNT ON
SET XACT_ABORT ON

--Declaration of the varible that will be use
DECLARE @QtyOnBox Numeric(20,6), @strCurrentStatus char(1)
DECLARE @Delete_Scarpped_object char(1), @Part nvarchar(25)
DECLARE @strNewStatus as varchar(1)
Declare @Category as varchar(25)

--<Tran Required=Yes AutoCreate=Yes>
DECLARE	@TranCount SMALLINT
SET	@TranCount = @@TranCount
IF	@TranCount = 0 
	BEGIN TRANSACTION HCSP_Change_Object_Status
ELSE
	SAVE TRANSACTION HCSP_Change_Object_Status
--</Tran>

--<Error Handling>
DECLARE @ProcReturn integer,	@ProcResult integer
DECLARE @Error integer,	@RowCount integer
--</Error Handling>


--	Argument Validation:
--		Operator required:
	IF	NOT EXISTS
		(	SELECT 	1
			FROM	employee
			WHERE	operator_code = @Operator) BEGIN

		SET	@Result = 60001
		ROLLBACK TRAN HCSP_Change_Object_Status
		RAISERROR (@Result, 16, 1, @Operator)
		RETURN	@Result
	END

--
	If EXISTS(Select 1
				from	MaterialHandlerPickupWarehouse
				where	OperatorCode=@Operator and WarehouseCode='Bodega Principal')
	BEGIN

		SET	@Result = 60001
		ROLLBACK TRAN HCSP_Change_Object_Status
		RAISERROR ('The operator %s can not change status to serial', 16, 1, @Operator)
		RETURN	@Result
	END
	set @Category=''			
	if 	charindex('@',isnull(@Note,''),1)>0
	begin
		 set @category=SUBSTRING(@note,	charindex('@',isnull(@Note,''),1)+1,len(isnull(@note,'')))
		 set @Note=REPLACE(@note,'@'+@category,'')
	end 

SELECT @Delete_Scarpped_object = parameters.delete_scrapped_objects FROM parameters 


--Set the value of the result to error (any number rathen 0) because if transacction doesn't get to the end means we have an error
	SET @Result	= 99999

-- Validate before do any, the serial is still alive
	
	IF  NOT EXISTS( SELECT 1 FROM Object WHERE Serial = @lngSerial )
		BEGIN
			SET	@Result = 60001
			ROLLBACK TRAN HCSP_Change_Object_Status
			RAISERROR ('The Object Serial is invalid', 16, 1, @Part)
			RETURN	@Result
		END

---- Validar si la serie es un PRE-Object y no tiene jobcomplete
---- 2008/10/14 Hecho por Roberto Larios
if exists (select 1
           from audit_trail at
           where at.type='P' and at.remarks='PRE-OBJECT' and at.serial=@lngSerial)
BEGIN           	          
	if not EXISTS
			(select 1
				from audit_trail at 
				where at.type='J' and at.serial=@lngSerial)
	BEGIN
		SET	@Result = 100001
		ROLLBACK TRAN HCSP_Change_Object_Status
		RAISERROR ('The serial # is a PRE-OBJECT and doesnt have a JOBCOMPLETE', 16, 1, @lngSerial)
		RETURN	@Result		
	END
END

/*
Validacion de Moldeo Solicitado por Edgar Menendez 2011/04/05
Las partes EEM0015-WG01-BLK, EEM0016-WG01-LGY, EEM3157-WA00-LGY para ser Aprobadas
deben tener un transfer a la location SETUPMOLD y estar ahi por lo menos 8 horas
*/

	--Get the PArt, the Qty of the box to reduce from the on_hand value (Part_online), and the Curret Status to put on the Audit_Trail as FROM_LOC field
		SELECT	@Part = Part, @QtyOnBox = Quantity, @strCurrentStatus = status 
		FROM	object 
		WHERE	Serial = @lngSerial

If  exists ( Select 1
				from object 
				where serial=@lngSerial 
				and part in (Select part from HN.MOLD_ControlPartesSetup))
	and (upper(@strUserDefinedStatus)= UPPER('Approved')) 
BEGIN
	If not exists (Select 1
					from audit_trail where serial=@lngSerial and type='T'
					and to_loc='SETUPMOLD')
		begin
			SET	@Result = 100001
			ROLLBACK TRAN HCSP_Change_Object_Status
			RAISERROR ('The serial does not have a transfer to SETUPMOLD location', 16, 1, @lngSerial)
			RETURN	@Result
		END
	else
		begin

			if DATEDIFF(HH,isnull((Select Min(date_stamp)
							FROM audit_trail 
							where serial=@lngSerial 
								and type='T'
								and to_loc='SETUPMOLD'),GETDATE()), GETDATE())	< (isnull((Select	CantidadHorasEnSetup 
																							from	MOLD_ControlPartesSetup 
																							where part=@Part and isnull(CantidadHorasEnSetup,0) >0),8))
						begin
							SET	@Result = 100001
							ROLLBACK TRAN HCSP_Change_Object_Status
							RAISERROR ('The serial does not have 8hrs in SETUPMOLD location', 16, 1, @lngSerial)
							RETURN	@Result
						END
		end
END 
	
				



	-- Get the new type of Status it will have
		SELECT @strNewStatus = user_defined_status.Type FROM user_defined_status WHERE Display_Name = @strUserDefinedStatus 

		IF @strNewStatus IS NULL 
			BEGIN
				SET	@Result = 400
				ROLLBACK TRAN HCSP_Change_Object_Status
				RAISERROR ('The type of the reported status is not defined please check', 16, 1, @Part)
				RETURN	@Result
			END


	
	
	--Update the Object Table with new info.
		UPDATE Object
		SET		Last_date = Getdate(), Operator = @Operator, 
				Status = @strNewStatus, Note = case when @strNewStatus = 'A' 
										then '' 
										else Left( rtrim(ltrim(isnull(Note,'') + ' , ' + @Note)), 254 )
										end, user_defined_status = @strUserDefinedStatus, 
				Last_Time = Getdate(),custom3=--iif(len(@Category)>0, ltrim(rtrim(custom3)) + ' Note:' + @Category,ltrim(rtrim(custom3)))
												Case When len(@Category)>0 Then ltrim(rtrim(custom3)) + ' Note:' + @Category else ltrim(rtrim(custom3)) end
		WHERE Serial = @lngSerial

		SELECT	@Error = @@Error
		IF	@Error != 0 begin
			SET	@Result = 300
			ROLLBACK TRAN HCSP_Change_Object_Status
			RAISERROR ('Error:  Unable to update object!', 16, 1)
			RETURN	@Result
		END


	-- Insert into audit Trail the record of the transaction 

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
		tare_weight, custom5,custom4/*, SupplierLot*/)
	SELECT	object.serial,
		object.last_date,
		'Q',
		object.part,
		object.quantity,
		'Quality',
		object.operator,
		@strCurrentStatus,
		@strNewStatus,
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
		object.tare_weight, custom5,
		object.custom4--, SupplierLot
	FROM	object object
	WHERE	object.serial = @lngSerial


--  Validate if the operation on the Audit Trail is succesfull
	SELECT	@Error = @@Error, @RowCount = @@RowCount
	IF	@Error != 0 begin
		SET	@Result = 300
		ROLLBACK TRAN HCSP_Change_Object_Status
		RAISERROR ('Error:  Unable to update object Table!', 16, 1)
		RETURN	@Result
	END

	IF	@RowCount = 0 begin
		SET	@Result = 800
		ROLLBACK TRAN HCSP_Change_Object_Status
		RAISERROR ('Error:  No row Updated on object Table!', 16, 1)
		RETURN	@Result
	END

	--Delete the serial from object table if the Delete_Scarpped_object is yes and the new status is Scrap
	IF @Delete_Scarpped_object = 'Y' AND @strNewStatus = 'S'
		BEGIN

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
				tare_weight, custom5,custom4, start_date/*, SupplierLot*/)
			SELECT	object.serial,
				object.last_date,
				'D',
				object.part,
				Quantity = 0,
				'Delete',
				object.operator,
				Location,
				'TRASH',
				object.lot,
				object.weight,
				object.status,
				object.unit_measure,
				Std_Quantity = 0,
				object.plant,
				@Note,
				object.package_type,
				object.cost,
				object.user_defined_status,
				object.tare_weight, custom5,object.custom4, start_date--, SupplierLot
			FROM	object object
			WHERE	object.serial = @lngSerial

		--  Validate if the operation on the Audit Trail is succesfull
			SELECT	@Error = @@Error, @RowCount = @@RowCount
			IF	@Error != 0 begin
				SET	@Result = 300
				ROLLBACK TRAN HCSP_Change_Object_Status
				RAISERROR ('Error:  Unable to update object Table!', 16, 1)
				RETURN	@Result
			END

			IF	@RowCount = 0 begin
				SET	@Result = 800
				ROLLBACK TRAN HCSP_Change_Object_Status
				RAISERROR ('Error:  No row Updated on object Table!', 16, 1)
				RETURN	@Result
			END


			DELETE FROM Object WHERE Serial = @lngSerial

			SELECT	@Error = @@Error, @RowCount = @@RowCount
			IF	@Error != 0 begin
				SET	@Result = 400
				ROLLBACK TRAN HCSP_Change_Object_Status
				RAISERROR ('Error:  The object could not be delete!', 16, 1)
				RETURN	@Result
			END

			IF	@RowCount = 0 begin
				SET	@Result = 900
				ROLLBACK TRAN HCSP_Change_Object_Status
				RAISERROR ('Error:  Unable to delete object Table!', 16, 1)
				RETURN	@Result
			END
		END


	--Change the amount of pices that we have available for delivery to the customer based on the type
	--Be carfuel you only will rest value when you pass from Approved status to other, but no more
	--and you will add only if you pass from any other to Approve
		--Type = Approved(A) Add
		--Type = On Hold(H) Rest
		--Type = Obsolete(O) Rest
		--Type = Rejected(R) Rest 
		--Type = Scrapped(S) Rest

		--IF the current Status = 'A' AND The new is not, then update Part_online
		--IF @strCurrentStatus = 'A' AND @strNewStatus <> 'A'
		--BEGIN 
		--	UPDATE PART_ONLINE
		--	SET ON_HAND = ON_HAND - @QtyOnBox 
		--	WHERE Part = @Part 

		--	-- Validate the the update of Part_online is not null
		--	SELECT	@Error = @@Error, @RowCount = @@RowCount
		--	IF	@Error != 0 begin
		--		SET	@Result = 300
		--		ROLLBACK TRAN HCSP_Change_Object_Status
		--		RAISERROR ('Error:  Unable to update part online!', 16, 1)
		--		RETURN	@Result
		--	END

		--	IF @RowCount = 0 
		--	BEGIN 
		--		INSERT part_online
		--		(	part,
		--			on_hand)
		--		select	@Part,
		--			@QtyOnBox

		--		SELECT	@Error = @@Error
		--		IF	@Error != 0 begin
		--			SET	@Result = 200
		--			ROLLBACK TRAN HCSP_Change_Object_Status
		--			RAISERROR ('Error:  Unable to update part online!', 16, 1)
		--			RETURN	@Result
		--		END
		--	END
		--END

		--IF @strCurrentStatus <> 'A' AND @strNewStatus = 'A'
		--BEGIN 
		--	UPDATE PART_ONLINE
		--	SET ON_HAND = ON_HAND + @QtyOnBox 
		--	WHERE Part = @Part 

		--	-- Validate the the update of Part_online is not null
		--	SELECT	@Error = @@Error, @RowCount = @@RowCount
		--	IF	@Error != 0 begin
		--		SET	@Result = 300
		--		ROLLBACK TRAN HCSP_Change_Object_Status
		--		RAISERROR ('Error:  Unable to update part online!', 16, 1)
		--		RETURN	@Result
		--	END

		--	IF	@RowCount != 1 begin
		--		SET	@Result = 300
		--		ROLLBACK TRAN HCSP_Change_Object_Status
		--		RAISERROR ('Error:  Unable to update part online!', 16, 1)
		--		RETURN	@Result
		--	END
		--END


	--Change the result to zero, means succefull.
	IF	@TranCount = 0 
	BEGIN
		COMMIT TRANSACTION HCSP_Change_Object_Status
	END

	SET @Result	= 0
	RETURN	@Result
GO
