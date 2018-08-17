CREATE TABLE [Programs].[ProgramHeaders]
(
[Status] [int] NOT NULL CONSTRAINT [DF__ProgramHe__Statu__45F365D3] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__ProgramHea__Type__46E78A0C] DEFAULT ((0)),
[ProgramCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ModelYear] [int] NULL,
[OEM_SOP] [datetime] NULL,
[OEM_EOP] [datetime] NULL,
[CustomerSOP] [datetime] NULL,
[CustomerEOP] [datetime] NULL,
[EmpireSOP] [datetime] NULL,
[EmpireEOP] [datetime] NULL,
[ShipmentTerms] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentTerms] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToLocation] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReplacementProgram] [int] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__ProgramHe__RowCr__47DBAE45] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ProgramHe__RowCr__48CFD27E] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__ProgramHe__RowMo__49C3F6B7] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ProgramHe__RowMo__4AB81AF0] DEFAULT (suser_name())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [Programs].[tr_ProgramHeaders_uRowModified] on [Programs].[ProgramHeaders] after update
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. Programs.usp_Test
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
		set	@TableName = 'Programs.ProgramHeaders'
		
		update
			ph
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			Programs.ProgramHeaders ph
			join inserted i
				on i.RowID = ph.RowID
		
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
	Programs.ProgramHeaders
...

update
	...
from
	Programs.ProgramHeaders
...

delete
	...
from
	Programs.ProgramHeaders
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
ALTER TABLE [Programs].[ProgramHeaders] ADD CONSTRAINT [PK__ProgramH__FFEE7451412EB0B6] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [Programs].[ProgramHeaders] ADD CONSTRAINT [UQ__ProgramH__7658A987440B1D61] UNIQUE NONCLUSTERED  ([ProgramCode]) ON [PRIMARY]
GO
ALTER TABLE [Programs].[ProgramHeaders] ADD CONSTRAINT [FK__ProgramHe__Repla__5BE2A6F2] FOREIGN KEY ([ReplacementProgram]) REFERENCES [Programs].[ProgramHeaders] ([RowID])
GO
ALTER TABLE [Programs].[ProgramHeaders] ADD CONSTRAINT [FK__ProgramHe__Repla__70DDC3D8] FOREIGN KEY ([ReplacementProgram]) REFERENCES [Programs].[ProgramHeaders] ([RowID])
GO
