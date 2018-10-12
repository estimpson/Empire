SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[uSP_VI_Save_ProjectTracker]
	
	@ProjectLeader NVARCHAR(150),
	@ProductType NVARCHAR(150),
	@ProjectType NVARCHAR(150),
	@ComponentPart NVARCHAR(150),
	@SamplesDates DATETIME,
	@FinishGood NVARCHAR(150),
	@ProgramManager NVARCHAR(150),
	@DesignLeader NVARCHAR(150),
	@ProjectStatus NVARCHAR(150),
	@DatePartNeeded NVARCHAR(150),
	@MaterialType NVARCHAR(150),
	@Customer NVARCHAR(150),
	@Program NVARCHAR(150),
	@EAU NVARCHAR(150),
	@ManufacturingLocation NVARCHAR(150),
	@EndUser NVARCHAR(150),
	@ComponentPicture NVARCHAR(150),
	@ProjectTimeLine NVARCHAR(150),
	@User NVARCHAR(50),
	@result Int out
	
AS
BEGIN
	
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





INSERT INTO sistema.dbo.VI_ProjectTracker(ProjectLeader,ProductType,ProjectType,ComponentPart,SamplesDates,FinishGood,ProgramManager,DesignLeader,ProjectStatus,DatePartNeeded,MaterialType,Customer,Program,EAU,ManufacturingLocation,EndUser,ComponentPicture,ProjectTimeLine,CreateBy,CreateDate)
VALUES(@ProjectLeader,@ProductType,@ProjectType,@ComponentPart,@SamplesDates,@FinishGood,@ProgramManager,@DesignLeader,@ProjectStatus,@DatePartNeeded,@MaterialType,@Customer,@Program,@EAU,@ManufacturingLocation,@EndUser,@ComponentPicture,@ProjectTimeLine,@User,GETDATE())



	set	@Error = @@Error
			if	@Error != 0 begin
			set	@Result = 900501
			RAISERROR ('Error inserting in %s.  Error: %d while inserting row to table', 16, 1, @ProcName, @Error, 'VI_Project')
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
