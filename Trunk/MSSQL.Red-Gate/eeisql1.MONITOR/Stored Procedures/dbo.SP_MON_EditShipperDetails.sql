SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SP_MON_EditShipperDetails](
					   @Part Varchar(35)
					  ,@Shipper integer = null	
					  ,@AccountCode Varchar(75)
					  ,@Price numeric(20,6)
					  ,@Terms varchar(25)				  
					  ,@Result int out
					   )
				AS
				BEGIN

	SET NOCOUNT ON
	SET   @Result = 999999

	DECLARE @TranCount smallint

	DECLARE @ProcReturn integer, @ProcResult integer 
	DECLARE @Error integer, @RowCount integer,@ProcName sysname

	set	@ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)  -- e.g. dbo.usp_Test

	----<Tran Required=Yes AutoCreate=Yes>
	SET   @TranCount = @@TranCount
	IF    @TranCount = 0 
		  BEGIN TRANSACTION @ProcName
	ELSE
		  SAVE TRANSACTION @ProcName
	--</Tran Required=Yes AutoCreate=Yes>

	UPDATE Monitor.dbo.shipper_Detail
	SET account_code=@AccountCode , price=@Price 
	 where shipper=@Shipper and part=@Part 
	

	set	@Error = @@Error
	if	@Error != 0
	BEGIN
		set	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while update row to table', 16, 1, @ProcName, @Error, 'IT_Assets_Activo')
		rollback tran @ProcName
		return @Result
	END


	UPDATE Monitor.dbo.shipper
	SET Terms=@terms
	 where id=@Shipper

	set	@Error = @@Error
	if	@Error != 0
	BEGIN
		set	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while update row to table', 16, 1, @ProcName, @Error, 'Shipper')
		rollback tran @ProcName
		return @Result
	END
	--<CloSETran Required=Yes AutoCreate=Yes>
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
