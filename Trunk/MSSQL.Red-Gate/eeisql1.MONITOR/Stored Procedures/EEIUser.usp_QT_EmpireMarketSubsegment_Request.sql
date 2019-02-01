SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_EmpireMarketSubsegment_Request]
	@OperatorCode varchar(5)
,	@EmpireMarketSubsegment varchar(200)
,	@Note varchar(250)
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
if not exists (
		select
			1
		from
			dbo.employee e
		where
			e.operator_code = @OperatorCode ) begin

	set @Result = -1
	raiserror ('Invalid operator.', 16, 1)
	rollback transaction @ProcName
	return
end

--- The Empire market Subsegment (approved) does not exist
if exists ( 
		select
			1
		from
			EEIUser.QT_EmpireMarketSubsegment ems
		where
			ems.EmpireMarketSubsegment = @EmpireMarketSubsegment
			and ems.Status = 0 ) begin
		
	set @Result = -1
	raiserror ('Empire market Subsegment %s already exists.', 16, 1, @EmpireMarketSubsegment)
	rollback transaction @ProcName
	return
end

--- The Empire market Subsegment (un-approved) does not exist
if exists ( 
		select
			1
		from
			EEIUser.QT_EmpireMarketSubsegment ems
		where
			ems.EmpireMarketSubsegment = @EmpireMarketSubsegment
			and ems.Status = 1 ) begin
		
	set @Result = -1
	raiserror ('Empire market Subsegment %s is already in the approval process.', 16, 1, @EmpireMarketSubsegment)
	rollback transaction @ProcName
	return
end

--- The Empire market Subsegment was not previously denied
declare
	@ResponseNote varchar(250)

select
	@ResponseNote = ems.ResponseNote
from
	EEIUser.QT_EmpireMarketSubsegment ems
where
	ems.EmpireMarketSubsegment = @EmpireMarketSubsegment
	and ems.Status = -1

if (@ResponseNote <> '') begin
	set @Result = -1
	raiserror ('Empire Market Subsegment %s was previously denied for the following reason: %s.', 16, 1, @EmpireMarketSubsegment, @ResponseNote)
	rollback transaction @ProcName
	return
end
---	</ArgumentValidation>



--- <Body>
--- <Insert Rows="1">
set	@TableName = 'EEIUser.QT_EmpireMarketSubsegment'
insert EEIUser.QT_EmpireMarketSubsegment
(
	EmpireMarketSubsegment
,	[Status]
,	[Type]
,	RequestorNote
,	RowCreateDT
,	RowCreateUser
,	RowModifiedDT
,	RowModifiedUser
)
select
	@EmpireMarketSubsegment
,	1
,	0
,	@Note
,	@TranDT
,	@OperatorCode
,	@TranDT
,	@OperatorCode

select
	@RowCount = @@Rowcount
				
if	@RowCount != 1 begin
	set @Result = -2
	raiserror ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback transaction @ProcName
	return
end
--- </Insert Rows>
--- </Body>


if @initialtrancount = 0  
    commit transaction @ProcName;   

GO
