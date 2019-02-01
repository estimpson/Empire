SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE Procedure [INV].[USP_Inv_ChangeObjectStatus]( 
				@Operator varchar(5),
				@Serial int, 
				@UserDefinedStatus varchar(30), 
				@Note as varchar(254) = NULL, 
				@Result int OUTPUT 
--<Debug>
	, @Debug integer = 0
--</Debug>

) as 

--Sample
--Begin Tran
--	Exec Change_Object_Status <Serial Number>, <User Defined Status Selected from list>, <Status type defined by User defined Status>, <User Comments>, <Operator generate the Transaction>, <Result>
--Commit Tran

SET NOCOUNT ON

--Declaration of the varible that will be use
DECLARE @QtyOnBox Numeric(20,6), @strCurrentStatus char(1)
DECLARE @Delete_Scarpped_object char(1), @Part nvarchar(25)
DECLARE @strNewStatus as varchar(1)

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


SELECT @Delete_Scarpped_object = parameters.delete_scrapped_objects FROM parameters 


--Set the value of the result to error (any number rathen 0) because if transacction doesn't get to the end means we have an error
	SET @Result	= 99999

-- Validate before do any, the serial is still alive
	
	IF  NOT EXISTS( SELECT 1 FROM Object WHERE Serial = @Serial )
		BEGIN
			SET	@Result = 60001
			ROLLBACK TRAN @ProcName
			RAISERROR ('The Object Serial is invalid', 16, 1, @Part)
			RETURN	@Result
		END


		-- Get the new type of Status it will have
			SELECT @strNewStatus = user_defined_status.Type FROM user_defined_status WHERE Display_Name = @UserDefinedStatus 

			IF @strNewStatus IS NULL 
				BEGIN
					SET	@Result = 400
					ROLLBACK TRAN @ProcName
					RAISERROR ('The type of the reported status is not defined please check', 16, 1, @Part)
					RETURN	@Result
				END

		--Get the PArt, the Qty of the box to reduce from the on_hand value (Part_online), and the Curret Status to put on the Audit_Trail as FROM_LOC field
			SELECT @Part = Part, @QtyOnBox = Quantity, @strCurrentStatus = status FROM object WHERE Serial = @Serial
	
		--Change the amount of pices that we have available for delivery to the customer based on the type
		--Be carfuel you only will rest value when you pass from Approved status to other, but no more
		--and you will add only if you pass from any other to Approve
			--Type = Approved(A) Add
			--Type = On Hold(H) Rest
			--Type = Obsolete(O) Rest
			--Type = Rejected(R) Rest 
			--Type = Scrapped(S) Rest

			--IF the current Status = 'A' AND The new is not, then update Part_online
			IF @strCurrentStatus = 'A' AND @strNewStatus <> 'A'
			BEGIN 
				UPDATE PART_ONLINE
				SET ON_HAND = ON_HAND - @QtyOnBox 
				WHERE Part = @Part 

				-- Validate the the update of Part_online is not null
				SELECT	@Error = @@Error, @RowCount = @@RowCount
				IF	@Error != 0 begin
					SET	@Result = 300
					ROLLBACK TRAN @ProcName
					RAISERROR ('Error:  Unable to update part online!', 16, 1)
					RETURN	@Result
				END

				IF @RowCount = 0 
				BEGIN 
					INSERT part_online
					(	part,
						on_hand)
					select	@Part,
						@QtyOnBox

					SELECT	@Error = @@Error
					IF	@Error != 0 begin
						SET	@Result = 200
						ROLLBACK TRAN @ProcName
						RAISERROR ('Error:  Unable to update part online!', 16, 1)
						RETURN	@Result
					END
				END
			END

			IF @strCurrentStatus <> 'A' AND @strNewStatus = 'A'
			BEGIN 
				UPDATE PART_ONLINE
				SET ON_HAND = ON_HAND + @QtyOnBox 
				WHERE Part = @Part 

				-- Validate the the update of Part_online is not null
				SELECT	@Error = @@Error, @RowCount = @@RowCount
				IF	@Error != 0 begin
					SET	@Result = 300
					ROLLBACK TRAN @ProcName
					RAISERROR ('Error:  Unable to update part online!', 16, 1)
					RETURN	@Result
				END

				IF	@RowCount != 1 begin
					SET	@Result = 300
					ROLLBACK TRAN @ProcName
					RAISERROR ('Error:  Unable to update part online!', 16, 1)
					RETURN	@Result
				END
			END
	
			--Update the Object Table with new info.
				UPDATE Object
				SET Last_date = Getdate(), Operator = @Operator, Status = @strNewStatus, Note = @Note, user_defined_status = @UserDefinedStatus, Last_Time = Getdate()
				WHERE Serial = @Serial

				SELECT	@Error = @@Error
				IF	@Error != 0 begin
					SET	@Result = 300
					ROLLBACK TRAN @ProcName
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
		tare_weight,
		warehousefreightlot)
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
		object.tare_weight,
		object.warehousefreightlot
	FROM	object object
	WHERE	object.serial = @Serial


--  Validate if the operation on the Audit Trail is succesfull
	SELECT	@Error = @@Error, @RowCount = @@RowCount
	IF	@Error != 0 begin
		SET	@Result = 300
		ROLLBACK TRAN @ProcName
		RAISERROR ('Error:  Unable to update object Table!', 16, 1)
		RETURN	@Result
	END

	IF	@RowCount = 0 begin
		SET	@Result = 800
		ROLLBACK TRAN @ProcName
		RAISERROR ('Error:  No row Updated on object Table!', 16, 1)
		RETURN	@Result
	END

	--Delete the serial from object table if the Delete_Scarpped_object is yes and the new status is Scrap
	IF @Delete_Scarpped_object = 'Y' AND @strNewStatus = 'S'
		BEGIN
			DELETE FROM Object WHERE Serial = @Serial

			SELECT	@Error = @@Error, @RowCount = @@RowCount
			IF	@Error != 0 begin
				SET	@Result = 400
				ROLLBACK TRAN @ProcName
				RAISERROR ('Error:  The object could not be delete!', 16, 1)
				RETURN	@Result
			END

			IF	@RowCount = 0 begin
				SET	@Result = 900
				ROLLBACK TRAN @ProcName
				RAISERROR ('Error:  Unable to delete object Table!', 16, 1)
				RETURN	@Result
			END
		END

	--Change the result to zero, means succefull.
	IF	@TranCount = 0 
	BEGIN
		COMMIT TRANSACTION @ProcName
	END

	SET @Result	= 0
	RETURN	@Result
GO
