SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[uSP_MON_Reassign_Po_ByParts]
	
	@SQL NVARCHAR(MAX),
	@BuyerAssig NVARCHAR(100),
	@BuyerActual NVARCHAR(100),
	@Result INT OUT


AS
BEGIN
	
	/*
	
	BEGIN TRAN

	Declare @SQLTest NVARCHAR(MAX)='SELECT ''HEL'''
	DECLARE @BuyerAssigTest nvarchar(100)='OFAJ'
	Declare @BuyerActualTest nvarchar(100)='JJF'

	EXEC uSP_MON_Reassign_Po_ByParts @SqlTest,@BuyerAssigTest,@BuyerActualTest,0

	rollback tran
	*/
SET nocount ON

SET   @Result = 999999

DECLARE     @TranCount smallint
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
declare @TranDT datetime
set @TranDT=GETDATE()
declare @SQLDetalle nvarchar(3000)
declare @reem nvarchar(3000)


CREATE TABLE #Part_Temporal(
	ID int identity,
	Part NVARCHAR(25)
)


			SET @SQL=SUBSTRING(@SQL, 0, LEN(@SQL)-9)
			

			set @SQL= N'INSERT INTO #Part_Temporal(Part) ' + @SQL
			exec sp_executeSQL @SQL


			set	@Error = @@Error
				if	@Error != 0 begin
					set	@Result = 900501
					RAISERROR ('Error encountered in %s.  Error: %d while inserting row to table', 16, 1, @ProcName, @Error, '#Part_Temporal')
					rollback tran @ProcName
					return @Result
			end

			UPDATE MONITOR.dbo.po_header
			SET Buyer=@BuyerAssig
			WHERE Buyer=@BuyerActual  
			AND LEFT(blanket_part,7) in (Select Part from #Part_Temporal)


			
			set	@Error = @@Error
				if	@Error != 0 begin
					set	@Result = 900501
					RAISERROR ('Error encountered in %s.  Error: %d while inserting row to table', 16, 1, @ProcName, @Error, 'po_header')
					rollback tran @ProcName
					return @Result
			end
			

	
if	@TranCount = 0 begin
	commit transaction @ProcName
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	II.	Return.
set	@Result = 0
return	@Result
END
GO
