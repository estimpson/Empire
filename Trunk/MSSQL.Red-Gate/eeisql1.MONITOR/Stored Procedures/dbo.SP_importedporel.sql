SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_importedporel]
	
	@User		varchar(10)=NULL,
	@Cadena		varchar(MAX)=NULL,
	@SalesOrder varchar(5)=NULL
	,
	@Result		integer out



AS
BEGIN
SET   @Result = 999999

DECLARE     @TranCount smallint

DECLARE @ProcReturn integer, @ProcResult integer 
DECLARE @Error integer, @RowCount integer,@ProcName sysname
set    @ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)  -- e.g. dbo.usp_Test

----<Tran Required=Yes AutoCreate=Yes>
SET   @TranCount = @@TranCount
IF    @TranCount = 0 
      BEGIN TRANSACTION @ProcName
ELSE
      SAVE TRANSACTION @ProcName
--</Tran Required=Yes AutoCreate=Yes>
			

					truncate table dbo.importedporel
					--Delete from dbo.importedporel where OperatorCode= @User

					--	SET    @Error = @@Error
					--	IF     @Error != 0 
					--	BEGIN
					--		SET    @Result = 999999
					--		RAISERROR ('Error en %s.  Error: %d while deleting row', 16, 1, @ProcName, @Error, 'EEI.Monitor.dbo.SP_importedporel')
					--		rollback tran SP_importedporel
					--		RETURN	@Result
					--	END
					
					--INSERT INTO dbo.importedporel
					--			(
					--				po_number,
					--				part,
					--				due_date,
					--				quantity,
					--				week_no,
					--				EEIQty,
					--				OperatorCode
					--			)
					--	EXEC (@Cadena)

					--	SET    @Error = @@Error
					--	IF     @Error != 0 
					--	BEGIN
					--		SET    @Result = 999999
					--		RAISERROR ('Error en %s.  Error: %d while inserting cadena row', 16, 1, @ProcName, @Error, 'EEI.Monitor.dbo.SP_importedporel')
					--		rollback tran SP_importedporel
					--		RETURN	@Result
					--	END

					--EXEC [dbo].[ftsp_ImportRleases] @SalesOrder, @User,@Result
					
					--	SET    @Error = @@Error
					--	IF     @Error != 0 
					--	BEGIN
					--		SET    @Result = 999999
					--		RAISERROR ('Error en %s.  Error: %d while executing Procedure [dbo].[ftsp_ImportRleases]  row', 16, 1, @ProcName, @Error, 'EEI.Monitor.dbo.SP_importedporel')
					--		rollback tran SP_importedporel
					--		RETURN	@Result
					--	END


             if     @TranCount = 0 begin
                    commit transaction SP_importedporel
             end
--</CloseTran Required=Yes AutoCreate=Yes>

--     II.    Return.
set    @Result = 0
return @Result




END 
GO
