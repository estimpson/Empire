SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [EEIUser].[usp_QT_InsertQuoteManualProgramData]
	@QuoteNumber varchar(50)
,	@Manufacturer varchar(50) = null
,	@Platform varchar(255) = null
,	@Program varchar(50) = null
,	@Nameplate varchar(50) = null
,	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings off
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
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
if not exists
	(	select
			1
		from
			EEIUser.QT_QuoteManualProgramData qmpd
		where
			qmpd.QuoteNumber = @QuoteNumber) begin
			
	--- <Insert rows="1">
	set	@TableName = 'EEIUser.QT_QuoteManualProgramData'
	insert 
		EEIUser.QT_QuoteManualProgramData
	(	QuoteNumber
	,	Manufacturer
	,	Platform
	,	Program
	,	Nameplate
	)
	select
		QuoteNumber = @QuoteNumber
	,	Manufacturer = @Manufacturer
	,	Platform = @Platform
	,	Program = @Program
	,	Nameplate = @Nameplate

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999990
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != 1 begin
		set	@Result = 999991
		RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
--- </Insert>		
end
else begin
	--- <Update rows="1">
	set	@TableName = 'EEIUser.QT_QuoteManualProgramData'
	update
		qmpd
	set
		qmpd.Manufacturer = @Manufacturer
	,	qmpd.Platform = @Platform
	,	qmpd.Program = @Program
	,	qmpd.Nameplate = @Nameplate
	from
		EEIUser.QT_QuoteManualProgramData qmpd
	where
		qmpd.QuoteNumber = @QuoteNumber
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999993
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != 1 begin
		set	@Result = 999994
		RAISERROR ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Update>
end
--- </Body>

--- <Tran AutoClose=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
--- </Tran>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>
GO
