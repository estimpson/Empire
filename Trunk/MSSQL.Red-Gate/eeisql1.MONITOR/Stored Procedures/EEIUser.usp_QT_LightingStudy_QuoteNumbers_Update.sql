SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_LightingStudy_QuoteNumbers_Update]
	@QuoteNumber varchar(50)
,	@Application varchar(50)
,	@LightingStudyId int = null
,	@Program varchar(50)
,	@LedHarness varchar(50)
,	@Sop datetime = null
,	@RowID int = null
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
-- If this is not a delete transaction, validate before inserting
if (@RowID is null) begin

	if (@LightingStudyId is not null) begin
		if exists (
				select
					1
				from
					EEIUser.QT_LightingStudy_QuoteNumbers qn
				where
					qn.QuoteNumber = @QuoteNumber
					and qn.LightingStudyId = @LightingStudyId ) begin
				
			set	@Result = 60000
			--RAISERROR ('This quote number is already tied to Lighting Study ID %d.', 16, 1, @LightingStudyId)
			rollback tran @ProcName
			return	
		end
	end
	else begin
		if exists (
				select
					1
				from
					EEIUser.QT_LightingStudy_QuoteNumbers qn
				where
					qn.QuoteNumber = @QuoteNumber
					and qn.[Application] = @Application ) begin
					
			set	@Result = 60001
			--RAISERROR ('This quote number is already tied to function code %s.', 16, 1, @FunctionCode)
			rollback tran @ProcName
			return		
		end			
	end

end
---	</ArgumentValidation>


--- <Body>
if (@RowID is null) begin -- Insert a new record

	if (@Program = '') begin -- Tying quote to an application only
	
		--- <Insert rows="1">
		set	@TableName = 'EEIUser.QT_LightingStudy_QuoteNumbers'

		insert into EEIUser.QT_LightingStudy_QuoteNumbers
		(
			QuoteNumber
		,	[Application]
		,	LightingStudyId
		,	Sop
		)
		select
			@QuoteNumber
		,	@Application
		,	null
		,	null
		
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
	else begin -- Tying quote to a specific Lighting study record
	
		--- <Insert rows="1">
		set	@TableName = 'EEIUser.QT_LightingStudy_QuoteNumbers'

		insert into EEIUser.QT_LightingStudy_QuoteNumbers
		(
			QuoteNumber
		,	[Application]
		,	LightingStudyId
		,	Program
		,	LEDHarness
		,	Sop
		)
		select
			@QuoteNumber
		,	@Application
		,	@LightingStudyId
		,	@Program
		,	@LedHarness
		,	@Sop

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

end
else begin -- Delete an existing row

	--- <Delete rows="1">
	set	@TableName = 'EEIUser.QT_LightingStudy_QuoteNumbers'
	
	delete from 
		EEIUser.QT_LightingStudy_QuoteNumbers
	where
		RowID = @RowID

	select
		@Error = @@Error,
		@RowCount = @@Rowcount
		
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount <> 1 begin
		set	@Result = 999999
		RAISERROR ('Error deleting from table %s in procedure %s.  Rows: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Delete rows="1">
	
end
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
