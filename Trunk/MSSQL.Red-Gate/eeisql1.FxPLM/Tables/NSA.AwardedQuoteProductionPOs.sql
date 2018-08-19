CREATE TABLE [NSA].[AwardedQuoteProductionPOs]
(
[QuoteNumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__AwardedQu__Statu__0E240DFC] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__AwardedQuo__Type__0F183235] DEFAULT ((0)),
[PurchaseOrderFileName] [sys].[sysname] NULL,
[PurchaseOrderDT] [datetime] NULL,
[PONumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlternativeCustomerCommitment] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SellingPrice] [numeric] (20, 6) NULL,
[PurchaseOrderSOP] [datetime] NULL,
[PurchaseOrderEOP] [datetime] NULL,
[Comments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__AwardedQu__RowCr__100C566E] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__AwardedQu__RowCr__11007AA7] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__AwardedQu__RowMo__11F49EE0] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__AwardedQu__RowMo__12E8C319] DEFAULT (suser_name())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [NSA].[tr_AwardedQuoteProductionPOs_uRowModified] on [NSA].[AwardedQuoteProductionPOs] after update
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
		set	@TableName = 'NSA.AwardedQuoteProductionPOs'
		
		update
			aqtp
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			NSA.AwardedQuoteProductionPOs aqtp
			join inserted i
				on i.RowID = aqtp.RowID
		
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
	NSA.AwardedQuoteProductionPOs
...

update
	...
from
	NSA.AwardedQuoteProductionPOs
...

delete
	...
from
	NSA.AwardedQuoteProductionPOs
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
ALTER TABLE [NSA].[AwardedQuoteProductionPOs] ADD CONSTRAINT [PK__AwardedQ__FFEE7451086B34A6] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [NSA].[AwardedQuoteProductionPOs] ADD CONSTRAINT [UQ__AwardedQ__8A47966A0B47A151] UNIQUE NONCLUSTERED  ([QuoteNumber]) ON [PRIMARY]
GO
ALTER TABLE [NSA].[AwardedQuoteProductionPOs] ADD CONSTRAINT [FK__AwardedQu__Quote__0D2FE9C3] FOREIGN KEY ([QuoteNumber]) REFERENCES [NSA].[AwardedQuotes] ([QuoteNumber])
GO