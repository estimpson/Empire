SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create Procedure [HN].[HCSP_Inv_Change_Pallet_Status]( 
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
	Exec HN.HCSP_Inv_Change_Object_Status 'mon', 16501717, 'Approved',  'Autorizados por Jhonatan Castro', @Result out
	print @result

rollback

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
	BEGIN TRANSACTION HCSP_Inv_Change_Pallet_Status
ELSE
	SAVE TRANSACTION HCSP_Inv_Change_Pallet_Status
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
		ROLLBACK TRAN HCSP_Inv_Change_Pallet_Status
		RAISERROR (@Result, 16, 1, @Operator)
		RETURN	@Result
	END


	

--Set the value of the result to error (any number rathen 0) because if transacction doesn't get to the end means we have an error
	SET @Result	= 99999

-- Validate before do any, the serial is still alive
	
	IF  NOT EXISTS( SELECT 1 FROM Object WHERE Serial = @lngSerial )
		BEGIN
			SET	@Result = 60001
			ROLLBACK TRAN HCSP_Inv_Change_Pallet_Status
			RAISERROR ('The Object Serial is invalid', 16, 1, @Part)
			RETURN	@Result
		END


-- Get the new type of Status it will have
		SELECT @strNewStatus = user_defined_status.Type FROM user_defined_status WHERE Display_Name = @strUserDefinedStatus 

		IF @strNewStatus IS NULL 
			BEGIN
				SET	@Result = 400
				ROLLBACK TRAN HCSP_Inv_Change_Pallet_Status
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
				Last_Time = Getdate()
		WHERE Serial = @lngSerial

		SELECT	@Error = @@Error
		IF	@Error != 0 begin
			SET	@Result = 300
			ROLLBACK TRAN HCSP_Inv_Change_Pallet_Status
			RAISERROR ('Error:  Unable to update object!', 16, 1)
			RETURN	@Result
		END

--Change the result to zero, means succefull.
	IF	@TranCount = 0 
	BEGIN
		COMMIT TRANSACTION HCSP_Inv_Change_Pallet_Status
	END

	SET @Result	= 0
	RETURN	@Result
GO
GRANT EXECUTE ON  [HN].[HCSP_Inv_Change_Pallet_Status] TO [APPUser]
GO
