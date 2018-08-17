CREATE TABLE [PartTrack].[PartDataRaw]
(
[Status] [int] NOT NULL CONSTRAINT [DF__PartDataR__Statu__1F198FD4] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__PartDataRa__Type__200DB40D] DEFAULT ((0)),
[EmpirePN] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPN] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OEM] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Program] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Application] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModelYear] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReplacedBy] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes01] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes02] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes03] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes04] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes05] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes06] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes07] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes08] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes09] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes10] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes11] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes12] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes13] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes14] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes15] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes16] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes17] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes18] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes19] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes20] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__PartDataR__RowCr__2101D846] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PartDataR__RowCr__21F5FC7F] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__PartDataR__RowMo__22EA20B8] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PartDataR__RowMo__23DE44F1] DEFAULT (suser_name())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [PartTrack].[tr_PartDataRaw_uRowModified] on [PartTrack].[PartDataRaw] after update
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. PartTrack.usp_Test
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
		set	@TableName = 'PartTrack.PartDataRaw'
		
		update
			pdr
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			PartTrack.PartDataRaw pdr
			join inserted i
				on i.RowID = pdr.RowID
		
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
	PartTrack.PartDataRaw
...

update
	...
from
	PartTrack.PartDataRaw
...

delete
	...
from
	PartTrack.PartDataRaw
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
ALTER TABLE [PartTrack].[PartDataRaw] ADD CONSTRAINT [PK__PartData__FFEE74511D314762] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
