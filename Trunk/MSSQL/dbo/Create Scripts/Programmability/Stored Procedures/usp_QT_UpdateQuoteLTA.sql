USE [MONITOR]
GO

/****** Object:  StoredProcedure [EEIUser].[usp_QT_UpdateQuoteLTA]    Script Date: 03/04/2013 11:30:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [EEIUser].[usp_QT_UpdateQuoteLTA]
	@QuoteNumber varchar(50)
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
if not exists
	(	select	ql.ModelYear
		from	EEIUser.QT_QuoteLog ql
		where	ql.QuoteNumber = @QuoteNumber
				and ql.ModelYear is not null) begin
	RAISERROR ('A model year must be tied to this quote before LTA data can be entered.', 16, 1)
	set	@Result = 999000
	rollback tran @ProcName
	return
end		
---	</ArgumentValidation>

--- <Body>
declare @ModelYear varchar(10)
select
	@ModelYear = ql.ModelYear
from
	EEIUser.QT_QuoteLog ql
where
	ql.QuoteNumber = @QuoteNumber


-- Insure there are always four LTA years and they are current
--
if exists (	select	1
			from	EEIUser.QT_QuoteLTA qlta
			where	qlta.QuoteNumber = @QuoteNumber
					and qlta.LTAYear = 1) begin
					
	--- <Update Rows="1">
	set	@TableName = 'EEIUser.QT_QuoteLTA'
	update
		qlta
	set
		qlta.EffectiveDate = @ModelYear + 1
	from
		EEIUser.QT_QuoteLTA qlta
	where
		qlta.QuoteNumber = @QuoteNumber
		and qlta.LTAYear = 1
		
	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999100
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != 1 begin
		set	@Result = 999101
		RAISERROR ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Update>
end
else begin
	--- <Insert rows="1">
	set	@TableName = 'EEIUser.QT_QuoteLTA'
	insert 
		EEIUser.QT_QuoteLTA
	(	QuoteNumber
	,	EffectiveDate
	,	Percentage
	,	LTAYear
	)
	select
		QuoteNumber = @QuoteNumber
	,	EffectiveDate = @ModelYear + 1
	,	Percentage = 0
	,	LTAYear = 1

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999102
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != 1 begin
		set	@Result = 999103
		RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
--- </Insert>		 
end


if exists (	select	1
			from	EEIUser.QT_QuoteLTA qlta
			where	qlta.QuoteNumber = @QuoteNumber
					and qlta.LTAYear = 2) begin
					
	--- <Update Rows="1">
	set	@TableName = 'EEIUser.QT_QuoteLTA'
	update
		qlta
	set
		qlta.EffectiveDate = @ModelYear + 2
	from
		EEIUser.QT_QuoteLTA qlta
	where
		qlta.QuoteNumber = @QuoteNumber
		and qlta.LTAYear = 2
		
	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999104
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != 1 begin
		set	@Result = 999105
		RAISERROR ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Update>
end
else begin
	--- <Insert rows="1">
	set	@TableName = 'EEIUser.QT_QuoteLTA'
	insert 
		EEIUser.QT_QuoteLTA
	(	QuoteNumber
	,	EffectiveDate
	,	Percentage
	,	LTAYear
	)
	select
		QuoteNumber = @QuoteNumber
	,	EffectiveDate = @ModelYear + 2
	,	Percentage = 0
	,	LTAYear = 2

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999106
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != 1 begin
		set	@Result = 999107
		RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
--- </Insert>		 
end


if exists (	select	1
			from	EEIUser.QT_QuoteLTA qlta
			where	qlta.QuoteNumber = @QuoteNumber
					and qlta.LTAYear = 3) begin
					
	--- <Update Rows="1">
	set	@TableName = 'EEIUser.QT_QuoteLTA'
	update
		qlta
	set
		qlta.EffectiveDate = @ModelYear + 3
	from
		EEIUser.QT_QuoteLTA qlta
	where
		qlta.QuoteNumber = @QuoteNumber
		and qlta.LTAYear = 3
		
	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999108
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != 1 begin
		set	@Result = 999109
		RAISERROR ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Update>
end
else begin
	--- <Insert rows="1">
	set	@TableName = 'EEIUser.QT_QuoteLTA'
	insert 
		EEIUser.QT_QuoteLTA
	(	QuoteNumber
	,	EffectiveDate
	,	Percentage
	,	LTAYear
	)
	select
		QuoteNumber = @QuoteNumber
	,	EffectiveDate = @ModelYear + 3
	,	Percentage = 0
	,	LTAYear = 3

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999110
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != 1 begin
		set	@Result = 999111
		RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
--- </Insert>		 
end


if exists (	select	1
			from	EEIUser.QT_QuoteLTA qlta
			where	qlta.QuoteNumber = @QuoteNumber
					and qlta.LTAYear = 4) begin
					
	--- <Update Rows="1">
	set	@TableName = 'EEIUser.QT_QuoteLTA'
	update
		qlta
	set
		qlta.EffectiveDate = @ModelYear + 4
	from
		EEIUser.QT_QuoteLTA qlta
	where
		qlta.QuoteNumber = @QuoteNumber
		and qlta.LTAYear = 4
		
	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999112
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != 1 begin
		set	@Result = 999113
		RAISERROR ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Update>
end
else begin
	--- <Insert rows="1">
	set	@TableName = 'EEIUser.QT_QuoteLTA'
	insert 
		EEIUser.QT_QuoteLTA
	(	QuoteNumber
	,	EffectiveDate
	,	Percentage
	,	LTAYear
	)
	select
		QuoteNumber = @QuoteNumber
	,	EffectiveDate = @ModelYear + 4
	,	Percentage = 0
	,	LTAYear = 4

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999114
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != 1 begin
		set	@Result = 999115
		RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
--- </Insert>		 
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

