CREATE TABLE [EEIUser].[ST_LightingStudy_EU_2]
(
[Component] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Service] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Forecast Date] [datetime] NULL,
[VP: Region] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VP: Country] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VP: Manufacturer Group] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VP: Production Brand] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VP: Production Nameplate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VP: Platform] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VP: Program] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VP: SOP] [datetime] NULL,
[VP: EOP] [datetime] NULL,
[VP: Global Sales Segment] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Lighting ECU Fitment] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Lighting ECU Type] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Lighting ECU Function Category] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp Supplier] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp Low Beam Type] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp High Beam Type] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp Low & High Beam Bulb Count] [int] NULL,
[Headlamp Power Consumption (Watts)] [int] NULL,
[Fixed Bend Light (FBL) Fitment] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FBL Location] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp Adaptive Function: DBL] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp Adaptive Function: AFS] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp Adaptive Function: AHB] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp Adaptive Function: ADB] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp ADB Actuation Type] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp Units] [int] NULL,
[Camera Fitment] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DRL Fitment] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DRL Implementation] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DRL Type] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Indicator Type] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Motor Fitment] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Motor Units] [int] NULL,
[Integration Location] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Lighting ECU Function: ADB] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Lighting ECU Function: AFS] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Lighting ECU Function: DBL] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Lighting ECU Function: DRL] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Lighting ECU Function: FBL] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Lighting ECU Function: Foglamp] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Lighting ECU Function: Indicator] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Lighting ECU Function: LED Driver] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Lighting ECU Function: Levelling] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Lighting ECU Function: Matrix] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Lighting ECU Function: Other] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Lighting ECU Function: Position Lamp] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LED Headlamp Category] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Lighting ECU Supplier Group] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Lighting ECU Supplier] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Lighting ECU Units] [int] NULL,
[Vehicle Units] [int] NULL,
[Component Volume 2016] [int] NULL,
[Component Volume 2017] [int] NULL,
[Component Volume 2018] [int] NULL,
[Component Volume 2019] [int] NULL,
[Component Volume 2020] [int] NULL,
[Component Volume 2021] [int] NULL,
[Component Volume 2022] [int] NULL,
[Component Volume 2023] [int] NULL,
[Vehicle Volume 2016] [int] NULL,
[Vehicle Volume 2017] [int] NULL,
[Vehicle Volume 2018] [int] NULL,
[Vehicle Volume 2019] [int] NULL,
[Vehicle Volume 2020] [int] NULL,
[Vehicle Volume 2021] [int] NULL,
[Vehicle Volume 2022] [int] NULL,
[Vehicle Volume 2023] [int] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__ST_Lighti__RowCr__340BB1A6] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ST_Lighti__RowCr__34FFD5DF] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__ST_Lighti__RowMo__35F3FA18] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ST_Lighti__RowMo__36E81E51] DEFAULT (suser_name())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [EEIUser].[tr_ST_LightingStudy_EU_2_uRowModified] on [EEIUser].[ST_LightingStudy_EU_2] after update
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EEIUser.usp_Test
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
		set	@TableName = 'EEIUser.ST_LightingStudy_EU_2'
		
		update
			ls
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			EEIUser.ST_LightingStudy_EU_2 ls
			join inserted i
				on i.RowID = ls.RowID
		
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
	EEIUser.ST_LightingStudy_EU_2
...

update
	...
from
	EEIUser.ST_LightingStudy_EU_2
...

delete
	...
from
	EEIUser.ST_LightingStudy_EU_2
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
ALTER TABLE [EEIUser].[ST_LightingStudy_EU_2] ADD CONSTRAINT [PK__ST_Light__FFEE745132236934] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
