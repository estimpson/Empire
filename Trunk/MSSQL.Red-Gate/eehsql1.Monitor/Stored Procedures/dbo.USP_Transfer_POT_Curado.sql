SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Marvin Franco
-- Create date: 09-agosto-2017
-- Description:	transferir la serie de jobcomplete a estacion de curado, solicitado por Rodolfo Hernandez, se utiliza en inventory en la pantalla BF_PRE_ADC.vb
-- =============================================
CREATE PROCEDURE [dbo].[USP_Transfer_POT_Curado]
	@SerialPallet	INT,
	@NewSerial		INT,
	@WoID			INT,
	@ToLoc			Varchar(15),
	@Result			INT OUT

AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON
	SET @Result = 999999

	--<tran required=yes autocreate=yes>
	DECLARE	@CallProcName sysname,
			@TableName sysname,
			@ProcName sysname

	SET	@ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)

	DECLARE	@trancount smallint
		SET	@trancount = @@trancount

	If	@trancount = 0 
		BEGIN TRAN @ProcName
	ELSE
		SAVE TRAN @ProcName
	--</tran>
	
	--<error handling>
	DECLARE	@procreturn integer, 
			@procresult integer,
			@error integer,	
			@rowcount integer


	UPDATE	eeh.hn.PCB_PE_Serial
	SET		SerialProduced=@NewSerial
	where WODID=@WoID and comments='JobComplete' and SerialProduced=0

		set	@Error = @@Error
			if	@Error != 0 begin
				set	@Result = 1
				rollback tran @ProcName
				RAISERROR ('No fue posible actualizar SerialProduced al transferir el POT a estacion de curado en PCB_PE_Serial', 16, 1)
				return @Result
			end

	UPDATE	EEH.DBO.object
	SET		parent_serial= @SerialPallet
	WHERE	serial=@NewSerial

		set	@Error = @@Error
			if	@Error != 0 begin
				set	@Result = 1
				rollback tran @ProcName
				RAISERROR ('No fue posible actualizar parent_serial al transferir el POT a estacion de curado en object', 16, 1)
				return @Result
			end

	EXEC	@ProcReturn = EEH.HN.HCSP_INV_Transfer_Object
				@Operator = 'MON',
				@Serial = @SerialPallet,
				@ToLoc = @ToLoc,
				@Note = '',
				@Result = @ProcResult output

	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 999999
		rollback tran @ProcName
		RAISERROR (@Result, 16, 1, 'ProdControl_JobComplete')		
		return	@Result
	end

	if	@ProcReturn != 0 begin
		set	@Result = 999999
		rollback tran @ProcName
		RAISERROR (@Result, 16, 1, 'ProdControl_JobComplete')
		
		return	@Result
	end


	--<CloseTran Required=Yes AutoCreate=Yes>
	if	@TranCount = 0 begin
		commit transaction @ProcName
	end
	--</CloseTran Required=Yes AutoCreate=Yes>

	--	II.	Return.
	set	@Result = 0
	return	@Result
	

END
GO
