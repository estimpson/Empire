SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [FT].[usp_Web_EmpireMarketSubsegment_Deny]
	@OperatorCode varchar(5)
,	@EmpireMarketSubsegment varchar(200)
,	@Note varchar(25)
,	@TranDT datetime = null out
,	@Result integer = null  out
as
set nocount on
set ansi_warnings on
set	@Result = 0

--- <Error Handling>
declare
	--@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	--@ProcReturn integer,
	--@ProcResult integer,
	--@Error integer,
	@RowCount integer


set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
set @TranDT = getdate()

declare
	@initialtrancount int = @@trancount
if	@initialtrancount > 0
	save transaction @ProcName
else
	begin transaction @ProcName 
 

---	<ArgumentValidation>
--- Operator is valid
declare 
	@OperatorName varchar(50) = ''
	
select
	@OperatorName = e.name
from
	dbo.employee e
where
	e.operator_code = @OperatorCode

if (@OperatorCode = '') begin
	set @Result = -1
	raiserror ('Invalid operator.', 16, 1)
	rollback transaction @ProcName
	return
end

--- The Empire market Subsegment exists
if not exists ( 
		select
			1
		from
			EEIUser.QT_EmpireMarketSubsegment ems
		where
			ems.EmpireMarketSubsegment = @EmpireMarketSubsegment ) begin
		
	set @Result = -1
	raiserror ('Empire market Subsegment %s was not found in the database.', 16, 1, @EmpireMarketSubsegment)
	rollback transaction @ProcName
	return
end

--- The Empire market Subsegment has not already been approved
if exists ( 
		select
			1
		from
			EEIUser.QT_EmpireMarketSubsegment ems
		where
			ems.EmpireMarketSubsegment = @EmpireMarketSubsegment
			and ems.Status = 1 ) begin
	
	set @Result = -1	
	raiserror ('Empire market segment %s has already been approved.', 16, 1, @EmpireMarketSubsegment)
	rollback transaction @ProcName
	return
end

--- The Empire market Subsegment has not already been denied
if exists ( 
		select
			1
		from
			EEIUser.QT_EmpireMarketSubsegment ems
		where
			ems.EmpireMarketSubsegment = @EmpireMarketSubsegment
			and ems.Status = -1 ) begin
		
	set @Result = -1
	raiserror ('Empire market Subsegment %s has already been denied.', 16, 1, @EmpireMarketSubsegment)
	rollback transaction @ProcName
	return
end
---	</ArgumentValidation>


--- <Body>
--- <Update Rows="1">
set	@TableName = 'EEIUser.QT_EmpireMarketSubsegment'
update 
	ems
set
	[Status] = -1
,	ResponseNote = @Note
,	RowModifiedDT = getdate()
,	RowModifiedUser = @OperatorCode
from
	EEIUser.QT_EmpireMarketSubsegment ems
where
	EmpireMarketSubsegment = @EmpireMarketSubsegment
	
select
	@RowCount = @@Rowcount
				
if	@RowCount != 1 begin
	set @Result = -2
	raiserror ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback transaction @ProcName
	return
end
--- </Update Rows>
--- </Body>


if @initialtrancount = 0  
    commit transaction @ProcName;  

GO
