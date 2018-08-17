CREATE TABLE [NSA].[AwardedQuotes]
(
[QuoteNumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__AwardedQu__Statu__03DB89B3] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__AwardedQuo__Type__04CFADEC] DEFAULT ((0)),
[CreationUser] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AwardDate] [datetime] NULL,
[FormOfCommitment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QuoteReason] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReplacingBasePart] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Salesperson] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProgramManager] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BasePart_User] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BasePart_Comments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BasePart_SignOffDT] [datetime] NULL,
[BasePart_SignOffUser] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CSM_User] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CSM_Comments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CSM_SignOffDT] [datetime] NULL,
[CSM_SignOffUser] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO_User] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO_Comments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO_SignOffDT] [datetime] NULL,
[CustomerPO_SignOffUser] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ToolingPO_User] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ToolingPO_Comments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ToolingPO_SignOffDT] [datetime] NULL,
[ToolingPO_SignOffUser] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Logistics_User] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Logistics_Comments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Logistics_SignOffDT] [datetime] NULL,
[Logistics_SignOffUser] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuoteTransfer_User] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuoteTransfer_Comments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuoteTransfer_SignOffDT] [datetime] NULL,
[QuoteTransfer_SignOffUser] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MasterSalesForecast_User] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MasterSalesForecast_Comments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MasterSalesForecast_SignOffDT] [datetime] NULL,
[MasterSalesForecast_SignOffUser] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__AwardedQu__RowCr__05C3D225] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__AwardedQu__RowCr__06B7F65E] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__AwardedQu__RowMo__07AC1A97] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__AwardedQu__RowMo__08A03ED0] DEFAULT (suser_name())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [NSA].[tr_AwardedQuotes_uRowModified] on [NSA].[AwardedQuotes] after update
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
		set	@TableName = 'NSA.AwardedQuotes'
		
		update
			aq
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			NSA.AwardedQuotes aq
			join inserted i
				on i.RowID = aq.RowID
		
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
	NSA.AwardedQuotes
...

update
	...
from
	NSA.AwardedQuotes
...

delete
	...
from
	NSA.AwardedQuotes
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
ALTER TABLE [NSA].[AwardedQuotes] ADD CONSTRAINT [PK__AwardedQ__FFEE74517F16D496] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [NSA].[AwardedQuotes] ADD CONSTRAINT [UQ__AwardedQ__8A47966A01F34141] UNIQUE NONCLUSTERED  ([QuoteNumber]) ON [PRIMARY]
GO
