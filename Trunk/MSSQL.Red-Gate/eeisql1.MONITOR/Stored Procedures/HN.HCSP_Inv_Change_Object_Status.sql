SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE Procedure [HN].[HCSP_Inv_Change_Object_Status]( 
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
--Sample
Begin Tran
declare @serial int, @Result int
set @serial=36405787

	Exec HN.HCSP_Inv_Change_Object_Status
		@Operator='424',
		@lngSerial=@serial,
		@strUserDefinedStatus='on Hold',
		@Note='Replacement box: Cert SSR16-971',
		@Result=@Result out

select @Result

select	*
from	audit_trail
where	serial=@serial

select	*
from	object
where	serial=@serial

rollback tran

*/
SET NOCOUNT ON

--Declaration of the varible that will be use
DECLARE @QtyOnBox Numeric(20,6), @strCurrentStatus char(1)
DECLARE @Delete_Scarpped_object char(1), @Part nvarchar(25)
DECLARE @strNewStatus as varchar(1)

--<Tran Required=Yes AutoCreate=Yes>
DECLARE	@TranCount SMALLINT
SET	@TranCount = @@TranCount
IF	@TranCount = 0 
	BEGIN
		BEGIN TRANSACTION HCSP_Change_Object_Status
	END
else begin 

SAVE TRANSACTION HCSP_Change_Object_Status
end
--</Tran>

--<Error Handling>
DECLARE @ProcReturn integer,	@ProcResult integer
DECLARE @Error integer,	@RowCount integer
--</Error Handling>


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
		
		-- Get the new type of Status it will have
			SELECT @strNewStatus = user_defined_status.Type FROM user_defined_status WHERE Display_Name = @strUserDefinedStatus 

			IF @strNewStatus IS NULL 
				BEGIN
					SET	@Result = 400
					ROLLBACK TRAN HCSP_Change_Object_Status
					RAISERROR ('The type of the reported status is not defined please check', 16, 1, @Part)
					RETURN	@Result
				END

			if exists (	select	1
						from	object 
						where	serial=@lngSerial
								and shipper is not null
								and @strNewStatus='H')
			begin
				SET	@Result = 99999
				ROLLBACK TRAN HCSP_Change_Object_Status
				RAISERROR ('The Object Serial is invalid because have a shipper assigned. Please check.! ', 16, 1)
				RETURN	@Result

			end

		--Get the PArt, the Qty of the box to reduce from the on_hand value (Part_online), and the Curret Status to put on the Audit_Trail as FROM_LOC field
			SELECT @Part = Part, @QtyOnBox = Quantity, @strCurrentStatus = status FROM object WHERE Serial = @lngSerial
	
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
					ROLLBACK TRAN HCSP_Change_Object_Status
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
						ROLLBACK TRAN HCSP_Change_Object_Status
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
					ROLLBACK TRAN HCSP_Change_Object_Status
					RAISERROR ('Error:  Unable to update part online!', 16, 1)
					RETURN	@Result
				END

				IF	@RowCount != 1 begin
					SET	@Result = 300
					ROLLBACK TRAN HCSP_Change_Object_Status
					RAISERROR ('Error:  Unable to update part online!', 16, 1)
					RETURN	@Result
				END
			END
	
			--Update the Object Table with new info.
				UPDATE Object
				SET Last_date = Getdate(), Operator = @Operator, Status = @strNewStatus, Note = @Note, user_defined_status = @strUserDefinedStatus, Last_Time = Getdate()
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
		tare_weight)
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
		object.tare_weight
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




--Change the result to zero, means succefull.
IF	@TranCount = 0 
BEGIN
	COMMIT TRANSACTION HCSP_Change_Object_Status
END

--Se puso este bloque al final del SP, por el error de: Cannot promote the transaction to a distributed transaction because there is an active save point in this transaction.
--09/11/2016
if exists (	select	1
			from	MONITOR.dbo.SSR_LogbySerial
			where	serial=@lngSerial)
	AND (@Note like 'Authorized by%' or @Note like 'Replacement %')
BEGIN

	declare @ApprovedWithDefect varchar(1)
	select @ApprovedWithDefect = case when @Note like '%For Defect%' or @Note like '%For Defects%' then 'Y' else 'N' end 

	insert into EEHSQL1.EEH.dbo.SSR_LogFromTroy(Serial,StatusReported,Quantity,Notes,Operator,RegisterDate,ApprovedWithDefect)
	SELECT	object.serial, object.Status,object.quantity,@Note,@Operator,GETDATE(), @ApprovedWithDefect
	FROM	object object
	WHERE	object.serial = @lngSerial

END

SET @Result	= 0
RETURN	@Result
GO
GRANT EXECUTE ON  [HN].[HCSP_Inv_Change_Object_Status] TO [APPUser]
GO
