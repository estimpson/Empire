SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Elvis Alas>
-- Create date: <Create Date,,9/9/2017>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_NewLocation]				
					--@User					VARCHAR(25)	
					 @Code					VARCHAR(10)
					,@Name					VARCHAR(30)
					,@Type					VARCHAR(5)
					,@Group_no				VARCHAR(25)
					,@Sequence				NUMERIC(3,0)=NULL
					,@Plant					VARCHAR(10)	
					,@Status				VARCHAR(1)=NULL
					,@Secured_location		VARCHAR(1)	
					,@Label_on_transfer		VARCHAR(1)=NULL
					,@Cantransfer				VARCHAR(1)	
					,@AllowMultiplePallet	VARCHAR(1)	
					,@box_type              VARCHAR(50)=NULL
					,@maxSerialloc           int=NULL
					,@Process				VARCHAR(25)=NULL
					,@Active				int=1
					,@operator				varchar(15)=NULL
					,@Result				INT OUT	
	
	AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
	SET NOCOUNT ON 
	DECLARE	@TranCount	SMALLINT,
			@ProcName	SYSNAME

	SET  @ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid) 

	--<Tran Required=Yes AutoCreate=Yes>
	SET	@TranCount = @@TranCount
	IF	@TranCount = 0 BEGIN
		BEGIN TRAN @ProcName
	END
		ELSE BEGIN
		SAVE TRAN @ProcName
	END

	DECLARE @ProcReturn integer, @ProcResult integer 
	DECLARE @Error integer, @RowCount integer

	declare @TranDT datetime
	set @TranDT=getdate()

	IF (SELECT COUNT(*) FROM location WHERE CODE=@CODE)>0 AND @PROCESS<>'UPDATE'
		BEGIN
			SET	@Result = 900501
			RAISERROR ('Sorry, the location you are trying to create already exists',16,1)
			ROLLBACK TRAN @ProcName
			RETURN @Result
			END
	ELSE
	BEGIN

	IF @PROCESS='UPDATE'
		BEGIN
		UPDATE  MONITOR.dbo.location 
		SET		name=@NAME,
				group_no=@group_no,
				type=@TYPE,
				sequence=@sequence,
				plant=@plant,
				status=@status,
				secured_location=@secured_location,
				label_on_transfer=@label_on_transfer,
				AllowMultiplePallet=@AllowMultiplePallet,
				box_type=@box_type , 
				maxSerialloc=@maxSerialloc ,
				Active=@Active,
				updateby=@operator,
				updatedate=@TranDT
		WHERE code=@CODE


			SET	@Error = @@Error
			IF	@Error != 0 BEGIN
				SET	@Result = 900501
				RAISERROR ('Sorry, an error occurred while UPDATE the information. (MONITOR.dbo.location)',16,1)
				ROLLBACK TRAN @ProcName
				RETURN @Result
			END		

		



		END
	ELSE
	BEGIN

		INSERT INTO MONITOR.dbo.location(code,name,type,group_no,sequence,plant,status,secured_location,
			label_on_transfer,AllowMultiplePallet,box_type,maxSerialloc,
			Active,regby,regdate )
		VALUES(@CODE,@NAME,@TYPE,@group_no,@sequence,@plant,@status,@secured_location,
			@label_on_transfer,@AllowMultiplePallet,@box_type,@maxSerialloc,
			@Active,@operator,@TranDT)
						
			SET	@Error = @@Error
			IF	@Error != 0 BEGIN
				SET	@Result = 900501
				RAISERROR ('Sorry, an error occurred while saving the information. (MONITOR.dbo.location)',16,1)
				ROLLBACK TRAN @ProcName
				RETURN @Result
			END		

	
	END			


END


	IF NOT EXISTS(SELECT 1 FROM location_limits WHERE LOCATION_CODE=@CODE) and @cantransfer='Y'
				BEGIN
					INSERT INTO MONITOR.dbo.location_limits (trans_code,location_code)
					VALUES('T',@CODE)

					SET	@Error = @@Error
					IF	@Error != 0 BEGIN
						SET	@Result = 900501
						RAISERROR ('Sorry, an error occurred while saving the information. (MONITOR.dbo.location_limits ) ',16,1)
						ROLLBACK TRAN @ProcName
						RETURN @Result
					END		


				END
		
		
	IF EXISTS(SELECT 1 FROM location_limits WHERE LOCATION_CODE=@CODE) and @cantransfer='N'
				BEGIN
				
				DELETE from location_limits WHERE LOCATION_CODE=@CODE								

					SET	@Error = @@Error
					IF	@Error != 0 BEGIN
						SET	@Result = 900501
						RAISERROR ('Sorry, an error occurred while deleting the information. (MONITOR.dbo.location_limits ) ',16,1)
						ROLLBACK TRAN @ProcName
						RETURN @Result
					END		


				END
		

	
	IF	@TranCount = 0 
	BEGIN
		COMMIT TRANSACTION @ProcName
	END
	--</CloSETran Required=Yes AutoCreate=Yes>

	--	II.	Return.
	SET	@Result = 0
	RETURN	@Result 


	END
GO
