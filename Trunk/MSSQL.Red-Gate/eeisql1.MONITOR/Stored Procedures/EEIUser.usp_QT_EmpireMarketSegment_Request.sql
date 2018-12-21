SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_EmpireMarketSegment_Request]
	@OperatorCode varchar(5)
,	@EmpireMarketSegment varchar(200)
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

--- The Empire market segment (approved) does not exist
if exists ( 
		select
			1
		from
			EEIUser.QT_EmpireMarketSegment ems
		where
			ems.EmpireMarketSegment = @EmpireMarketSegment
			and ems.Status = 0 ) begin
		
	set @Result = -1
	raiserror ('Empire market segment %s already exists.', 16, 1, @EmpireMarketSegment)
	rollback transaction @ProcName
	return
end

--- The Empire market segment (un-approved) does not exist
if exists ( 
		select
			1
		from
			EEIUser.QT_EmpireMarketSegment ems
		where
			ems.EmpireMarketSegment = @EmpireMarketSegment
			and ems.Status = 1 ) begin
	
	set @Result = -1
	raiserror ('Empire market segment %s is already in the approval process.', 16, 1, @EmpireMarketSegment)
	rollback transaction @ProcName
	return
end

--- The Empire market segment was not previously denied
declare
	@ResponseNote varchar(250)

select
	@ResponseNote = ems.ResponseNote
from
	EEIUser.QT_EmpireMarketSegment ems
where
	ems.EmpireMarketSegment = @EmpireMarketSegment
	and ems.Status = -1

if (@ResponseNote <> '') begin
	set @Result = -1
	raiserror ('Empire Market segment %s was previously denied for the following reason: %s.', 16, 1, @EmpireMarketSegment, @ResponseNote)
	rollback transaction @ProcName
	return
end
---	</ArgumentValidation>



--- <Body>
--- <Insert Rows="1">
set	@TableName = 'EEIUser.QT_EmpireMarketSegment'
insert EEIUser.QT_EmpireMarketSegment
(
	EmpireMarketSegment
,	[Status]
,	[Type]
,	RequestorNote
,	RowCreateDT
,	RowCreateUser
,	RowModifiedDT
,	RowModifiedUser
)
select
	@EmpireMarketSegment
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
