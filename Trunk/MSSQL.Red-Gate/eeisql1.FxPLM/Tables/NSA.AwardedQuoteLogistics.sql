CREATE TABLE [NSA].[AwardedQuoteLogistics]
(
[QuoteNumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__AwardedQu__Statu__65C116E7] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__AwardedQuo__Type__66B53B20] DEFAULT ((0)),
[EmpireFacility] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FreightTerms] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__AwardedQu__RowCr__67A95F59] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__AwardedQu__RowCr__689D8392] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__AwardedQu__RowMo__6991A7CB] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__AwardedQu__RowMo__6A85CC04] DEFAULT (suser_name())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [NSA].[tr_AwardedQuoteLogistics_uRowModified] on [NSA].[AwardedQuoteLogistics] after update
as
declare
	@TranDT datetime
,	@Result int

set xact_abort off
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. NSA.usp_Test
--- </Error Handling>

begin try
	--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount
	set	@TranDT = coalesce(@TranDT, GetDate())
	save tran @ProcName
	--- </Tran>

	---	<ArgumentValidation>

	---	</ArgumentValidation>
	
	--- <Body>
	if	not update(RowModifiedDT) begin
		--- <Update rows="*">
		set	@TableName = 'NSA.AwardedQuoteLogistics'
		
		update
			aql
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			NSA.AwardedQuoteLogistics aql
			join inserted i
				on i.RowID = aql.RowID
		
		select
			@Error = @@Error,
			@RowCount = @@Rowcount
		
		if	@Error != 0 begin
			set	@Result = 999999
			RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			rollback tran @ProcName
			return
		end
		--- </Update>
		
		--- </Body>
	end
end try
begin catch
	declare
		@errorName int
	,	@errorSeverity int
	,	@errorState int
	,	@errorLine int
	,	@errorProcedures sysname
	,	@errorMessage nvarchar(2048)
	,	@xact_state int
	
	select
		@errorName = error_number()
	,	@errorSeverity = error_severity()
	,	@errorState = error_state ()
	,	@errorLine = error_line()
	,	@errorProcedures = error_procedure()
	,	@errorMessage = error_message()
	,	@xact_state = xact_state()

	if	xact_state() = -1 begin
		print 'Error number: ' + convert(varchar, @errorName)
		print 'Error severity: ' + convert(varchar, @errorSeverity)
		print 'Error state: ' + convert(varchar, @errorState)
		print 'Error line: ' + convert(varchar, @errorLine)
		print 'Error procedure: ' + @errorProcedures
		print 'Error message: ' + @errorMessage
		print 'xact_state: ' + convert(varchar, @xact_state)
		
		rollback transaction
	end
	else begin
		/*	Capture any errors in SP Logging. */
		rollback tran @ProcName
	end
end catch

---	<Return>
set	@Result = 0
return
--- </Return>
/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go

begin transaction Test
go

insert
	NSA.AwardedQuoteLogistics
...

update
	...
from
	NSA.AwardedQuoteLogistics
...

delete
	...
from
	NSA.AwardedQuoteLogistics
...
go

if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/
GO
ALTER TABLE [NSA].[AwardedQuoteLogistics] ADD CONSTRAINT [PK__AwardedQ__FFEE745160083D91] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_AwardedQuoteLogistics_FreightTerms] ON [NSA].[AwardedQuoteLogistics] ([FreightTerms], [RowID]) ON [PRIMARY]
GO
ALTER TABLE [NSA].[AwardedQuoteLogistics] ADD CONSTRAINT [UQ__AwardedQ__8A47966A62E4AA3C] UNIQUE NONCLUSTERED  ([QuoteNumber]) ON [PRIMARY]
GO
ALTER TABLE [NSA].[AwardedQuoteLogistics] ADD CONSTRAINT [FK__AwardedQu__Quote__64CCF2AE] FOREIGN KEY ([QuoteNumber]) REFERENCES [NSA].[AwardedQuotes] ([QuoteNumber])
GO