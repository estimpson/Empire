SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [EEIUser].[usp_ST_SalesLeadLog_Hitlist_Update]
	@OperatorCode varchar(5)
,	@CombinedLightingId int
,	@SalesLeadId int = null
,	@SalesLeadStatus int -- 0=open, 1=quoted, 2=awarded, 3=closed
,	@ActivityRowId int = null
,	@Activity varchar(50) = null
,	@ActivityDate datetime = null
,	@MeetingLocation varchar(50) = null
,	@ContactName varchar(50) = null
,	@ContactPhoneNumber varchar(25) = null
,	@ContactEmailAddress varchar(320) = null
,	@Duration numeric(20,6) = null
,	@Notes varchar(max) = null
,	@QuoteNumber varchar(50) = null
,	@AwardedVolume int = null
,	@TranDT datetime = null out
,	@Result integer = null  out
as
set nocount on
set ansi_warnings on
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDIStanley.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>


--- <Body>
if (@SalesLeadId is null) begin

	--- <Insert rows="1">
	set	@TableName = 'EEIUser.ST_SalesLeadLog_Header'
	
	insert into EEIUser.ST_SalesLeadLog_Header
	(
		CombinedLightingId
	,	SalesPersonCode
	)
	select
		@CombinedLightingId
	,	@OperatorCode
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
		
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount <> 1 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Insert rows="1">
	
	select @SalesLeadId = SCOPE_IDENTITY();
end


if (@ActivityRowId is null) begin -- new sales lead activity (detail) record

	--- <Insert rows="1">
	set	@TableName = 'EEIUser.ST_SalesLeadLog_Detail'

	insert into EEIUser.ST_SalesLeadLog_Detail
	(
		SalesLeadId
	,	SalesPersonCode
	,	Status
	,	Activity
	,	ActivityDate
	,	MeetingLocation
	,	ContactName
	,	ContactPhoneNumber
	,	ContactEmailAddress
	,	Duration
	,	Notes
	,	QuoteNumber
	,	AwardedVolume
	)
	select
		@SalesLeadId
	,	@OperatorCode
	,	@SalesLeadStatus
	,	@Activity
	,	@ActivityDate
	,	@MeetingLocation
	,	@ContactName
	,	@ContactPhoneNumber
	,	@ContactEmailAddress
	,	@Duration
	,	@Notes
	,	@QuoteNumber
	,	@AwardedVolume

	select
		@Error = @@Error,
		@RowCount = @@Rowcount
		
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount <> 1 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Insert rows="1">
	
end
else begin -- existing sales lead activity (detail) record
	
	--- <Update rows="1">
	set	@TableName = 'EEIUser.ST_SalesLeadLog_Detail'

	update 
		EEIUser.ST_SalesLeadLog_Detail
	set
		Status = @SalesLeadStatus
	,	Activity = @Activity
	,	ActivityDate = @ActivityDate
	,	MeetingLocation = @MeetingLocation
	,	ContactName = @ContactName
	,	ContactPhoneNumber = @ContactPhoneNumber
	,	ContactEmailAddress = @ContactEmailAddress
	,	Duration = @Duration
	,	Notes = @Notes
	,	QuoteNumber = @QuoteNumber
	,	AwardedVolume = @AwardedVolume
	where
		RowID = @ActivityRowId
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
		
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount <> 1 begin
		set	@Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Insert rows="1">

end

/*  Carry status update over from details table to header and combined lighting study tables  */
--- <Update rows="1">
set	@TableName = 'EEIUser.ST_SalesLeadLog_Header'

update
	h
set
	h.Status = @SalesLeadStatus
from
	EEIUser.ST_SalesLeadLog_Header h
where
	h.RowID = @SalesLeadId

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount <> 1 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Update rows="1">



declare
	@Status varchar(20)
	
if (@SalesLeadStatus = 0) begin
	set @Status = 'Open'
end
else if (@SalesLeadStatus = 1) begin
	set @Status = 'Quoted'
end 
else if (@SalesLeadStatus = 2) begin
	set @Status = 'Awarded'
end
else begin
	set @Status = 'Closed'
end
	
--- <Update rows="1">
set	@TableName = 'EEIUser.EEIUser.vw_ST_LightingStudy_Hitlist_2016'

update
	hl
set
	hl.[Status] = @Status
,	hl.AwardedVolume = @AwardedVolume
from
	EEIUser.ST_LightingStudy_Hitlist_2016 hl
where
	hl.ID = @CombinedLightingId
	
select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount <> 1 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Update rows="1">
--- </Body>



---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>


---	<Return>
set	@Result = 0
return
	@Result
--- </Return>
GO
