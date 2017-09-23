SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [HN].[RLSP_JobComplete_New](
	@Operator varchar(5),
	@Part varchar(25),
	@Quantity numeric(20,6),
	@Location varchar (20) = null,
	@serial int out,
	@Result int out
)
as

set nocount on
set @Result = 999999

declare	@ProcReturn int, @Error int
declare	@TranCount SMALLINT
DECLARE @locationValid varchar(25)

set	@TranCount = @@TranCount
if	@TranCount = 0 
	begin transaction RLSP_JobComplete_New	
else
	save transaction RLSP_JobComplete_New  
	
	--		Location valid or default:
SELECT	@locationValid = isnull (@Location, primary_location)
FROM	part_inventory
WHERE	part = @Part
	
    execute	@ProcReturn = hn.HCSP_Inv_JobComplete_New
	    @Operator = @Operator,
	    @Part = @Part,
	    @Quantity  = @Quantity,
	    @Unit = null,
	    @Location = @locationValid,
	    @UserDefinedStatus = null,
	    @Lot  = null,
	    @Note  = Null,
	    @Custom2  = Null,
	    @Custom5 = Null,
	    @ObjectSerial = @Serial out,
	    @Result = @Result output
	
    set	@Error = @@ERROR
    if @Error != 0
    begin
    	set	@Result = 99999
	rollback tran RLSP_JobComplete_New
	raiserror (@Result, 16, 1)
	return	@Result
    end


--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction RLSP_JobComplete_New
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	Success.
set	@Result = 0
return	@Result

GO
