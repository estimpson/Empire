SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TROY_MON_SaveGroupLocation]
(	@GroupID			varchar(25),
	@Notes				varchar(255),
	@SourceType			varchar(10)=NULL,
	@Active				int=1,
	@operator			varchar(15),
	@result int out
	
)
        
/*

begin tran

declare @result int, @GroupID varchar(25)

set @result = 0
set @GroupID='EEP WAREHOUSE'

exec dbo.SP_TROY_MON_SaveGroupLocation
	@GroupID		=@GroupID,
	@Notes			='FG Main Warehouse in El Paso',
	@SourceType		=NULL,
	@Active			=1,
	@operator		='424',
	@result=@result out


select	RESULT=@result

IF @result=0 BEGIN

SELECT	* FROM Monitor.dbo.group_technology where id=@GroupID


END

rollback tran

*/
as

DECLARE  @trancount smallint
DECLARE @CallProcName sysname, @TableName sysname, @ProcName sysname

SET   @result = 999999
SET   @ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)  
SET   @trancount = @@trancount

IF    @trancount = 0 
      begin transaction @ProcName
ELSE
      save transaction @ProcName

DECLARE @procreturn integer, @procresult integer
DECLARE @error integer, @rowcount integer
DECLARE @TranDT datetime

SET @TranDT =GETDATE()

IF (@GroupID='') OR ( @GroupID IS NULL)
BEGIN
	SET	@Result = 999999
    RAISERROR ('Please input the field Group %s before to save. Error in procedure %s', 16, 1 ,@GroupID,@ProcName)
    rollback tran @ProcName
    return @Result
END

IF (@Notes='') OR ( @Notes IS NULL)
BEGIN
	SET	@Result = 999999
    RAISERROR ('Please input the field notes before to save the groupNo. %s. Error in procedure %s', 16, 1,@GroupID ,@ProcName)
    rollback tran @ProcName
    return @Result
END

--if exists Group technology id, update data, if not create one
IF exists(	select	1
			from	Monitor.dbo.group_technology
			where	id=@GroupID
) BEGIN

	IF @Active=0 and exists (select	1 from Monitor.dbo.group_technology where id=@GroupID and active=1)
	BEGIN
		IF EXISTS(SELECT	1 
				  FROM	MONITOR.dbo.location 
				  WHERE group_no=@GroupID )
		BEGIN
			DECLARE @QtyLocations int

			SELECT	@QtyLocations=count(code)
			FROM	MONITOR.dbo.location 
			WHERE	group_no=@GroupID
			group by group_no

			set   @Result = 999998
			RAISERROR ('There is %d locations with this groupNo. %s. Error in procedure %s.', 16, 1,@QtyLocations, @GroupID, @ProcName)
			rollback tran @ProcName
			return @Result

		END

	END

	UPDATE	Monitor.dbo.group_technology
	SET		notes=@Notes,
			source_type =iif(@SourceType='',NULL,@SourceType),
			Active=@Active,
			updateby=@operator,
			updatedate=@TranDT 
	WHERE	id=@GroupID		
	
	select @Error = @@Error,    
		   @RowCount = @@Rowcount
	set @TableName='Monitor.dbo.group_technology'

    if    @Error != 0 begin
          set   @Result = 999999
          RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
          rollback tran @ProcName
          return @Result
    end
    if    @RowCount != 1 begin
          set   @Result = 999999
          RAISERROR ('Error updating table %s in procedure %s.  Rows inserted: %d.  Expected rows: %d.', 16, 1, @TableName, @ProcName, @RowCount, 1)
          rollback tran @ProcName
          return @Result
    end

END
ELSE BEGIN
	

	INSERT INTO Monitor.dbo.group_technology(id,notes,source_type,Active,regby,regdate)
	SELECT @GroupID,@Notes,iif(@SourceType='',NULL,@SourceType),@Active,@operator,@TranDT 

	SELECT	@Error = @@Error,    
			@RowCount = @@Rowcount
	SET		@TableName = 'Monitor.dbo.group_technology'

	IF    @Error != 0 begin
			SET   @Result = 999999
			RAISERROR ('Error inserting table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			rollback tran @ProcName
			RETURN @Result
	END
    
	if    @RowCount != 1 begin
			set   @Result = 999999
			RAISERROR ('Error inserting table %s in procedure %s.  Rows inserted: %d.  Expected rows: %d.', 16, 1, @TableName, @ProcName, @RowCount, 1)
			rollback tran @ProcName
			return @Result
	end

END



if    @TranCount = 0 begin
    commit transaction @ProcName
end

set @Result = 0
return @Result



GO
