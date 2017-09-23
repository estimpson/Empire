
/*
Create Table.Fx.dbo.Shipping_ContainerHeader.sql
*/

--use Fx
--go

--drop table dbo.Shipping_ContainerHeader
if	objectproperty(object_id('dbo.Shipping_ContainerHeader'), 'IsTable') is null begin

	create table dbo.Shipping_ContainerHeader
	(	ContainerNumber varchar(50) default ('0') not null
	,	Status int not null default(0)
	,	Type int not null default(0)
	,	FromPlant varchar(50)
	,	ToPlant varchar(50)
	,	IntransitLocationCode varchar(50)
	,	DepartureDueDT datetime
	,	ScheduledDepartureDT datetime
	,	ActualDepartureDT datetime
	,	ArrivalDueDT datetime
	,	ScheduledArrivalDT datetime
	,	ExpectedArrivalDT datetime
	,	ActualArrivalDT datetime
	,	RowID int identity(1,1) primary key clustered
	,	RowCreateDT datetime default(getdate())
	,	RowCreateUser sysname default(suser_name())
	,	RowModifiedDT datetime default(getdate())
	,	RowModifiedUser sysname default(suser_name())
	,	unique nonclustered
		(	ContainerNumber
		,	RowID
		)
	)
end
go

/*
Create trigger dbo.tr_Shipping_ContainerHeader_uRowModified on dbo.Shipping_ContainerHeader
*/

--use Fx
--go

if	objectproperty(object_id('dbo.tr_Shipping_ContainerHeader_uRowModified'), 'IsTrigger') = 1 begin
	drop trigger dbo.tr_Shipping_ContainerHeader_uRowModified
end
go

create trigger dbo.tr_Shipping_ContainerHeader_uRowModified on dbo.Shipping_ContainerHeader after update
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
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
		set	@TableName = 'dbo.Shipping_ContainerHeader'
		
		update
			sch
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			dbo.Shipping_ContainerHeader sch
			join inserted i
				on i.RowID = sch.RowID
		
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
	dbo.Shipping_ContainerHeader
...

update
	...
from
	dbo.Shipping_ContainerHeader
...

delete
	...
from
	dbo.Shipping_ContainerHeader
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
go

/*
Create trigger Fx.dbo.tr_Shipping_ContainerHeader_NumberMask on dbo.Shipping_ContainerHeader
*/

--use Fx
--go

if	objectproperty(object_id('dbo.tr_Shipping_ContainerHeader_NumberMask'), 'IsTrigger') = 1 begin
	drop trigger dbo.tr_Shipping_ContainerHeader_NumberMask
end
go

create trigger dbo.tr_Shipping_ContainerHeader_NumberMask on dbo.Shipping_ContainerHeader after insert
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
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
/*	Check if any new rows require a new Delivery Number. */
	if	exists
			(	select
					*
				from
					inserted i
				where
					i.ContainerNumber = '0'
			) begin

/*			Get the number of new delivery numbers needed. */
		declare
			@NumberCount int
	
		select
			@NumberCount = Count(*)
		from
			inserted i
		where
			i.ContainerNumber = '0'
		
/*			Set the new delivery numbers. */
		--- <Update rows="n">
		set	@TableName = 'dbo.Shipping_ContainerHeader'
				
		update
			sch
		set
			ContainerNumber = NewValues.NewValue
		from
			dbo.Shipping_ContainerHeader sch
			join
			(	select
					i.RowID
				,	i.RowCreateDT
				,	NewValue = FT.udf_NumberFromMaskAndValue
						(	ns.NumberMask
						,	ns.NextValue + row_number() over (order by i.RowID) - 1
						,	i.RowCreateDT
						)
				from
					inserted i
					join FT.NumberSequenceKeys nsk
						join FT.NumberSequence ns with(updlock)
							on ns.NumberSequenceID = nsk.NumberSequenceID
						on nsk.KeyName = 'dbo.Shipping_ContainerHeader.ContainerNumber'
				where
					i.ContainerNumber = '0'
			) NewValues
				on NewValues.RowID = sch.RowID
		
		select
			@Error = @@Error,
			@RowCount = @@Rowcount
		
		if	@Error != 0 begin
			set	@Result = 999999
			RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			rollback tran @ProcName
			return
		end
		if	@RowCount != @NumberCount begin
			set	@Result = 999999
			RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: %d.', 16, 1, @TableName, @ProcName, @RowCount, @NumberCount)
			rollback tran @ProcName
			return
		end
		--- </Update>
	
/*			Increment the next delivery number. */
		--- <Update rows="1">
		set	@TableName = 'FT.NumberSequence'
		
		update
			ns
		set
			NextValue = ns.NextValue + @NumberCount
		from
			FT.NumberSequenceKeys nsk
			join FT.NumberSequence ns with(updlock)
				on ns.NumberSequenceID = nsk.NumberSequenceID
		where
			nsk.KeyName = 'dbo.Shipping_ContainerHeader.ContainerNumber'
		
		select
			@Error = @@Error,
			@RowCount = @@Rowcount
		
		if	@Error != 0 begin
			set	@Result = 999999
			RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			rollback tran @ProcName
			return
		end
		if	@RowCount != 1 begin
			set	@Result = 999999
			RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
			rollback tran @ProcName
			return
		end
		--- </Update>
	end
	--- </Body>
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
	dbo.Shipping_ContainerHeader
...

update
	...
from
	dbo.Shipping_ContainerHeader
...

delete
	...
from
	dbo.Shipping_ContainerHeader
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
go


insert
	FT.NumberSequence
(	Name
,	HelpText
,	NumberMask
,	NextValue
)
select
	Name = 'Container Number'
,	HelpText = 'Number sequence for containers.'
,	NumberMask = 'CNT_0000000000'
,	NextValue = 1
where
	not exists
		(	select
				*
			from
				FT.NumberSequence ns
			where
				ns.Name = 'Container Number'
		)

select
	*
from
	FT.NumberSequence ns

delete
	nsk
from
	FT.NumberSequenceKeys nsk
where
	nsk.KeyName = 'dbo.ContainerHeader.ContainerNumber'

insert
	FT.NumberSequenceKeys
(	KeyName
,	NumberSequenceID
)
select
	KeyName = 'dbo.ContainerHeader.ContainerNumber'
,	NumberSequenceID = 11
where
	not exists
		(	select
				*
			from
				FT.NumberSequenceKeys nsk
			where
				nsk.KeyName = 'dbo.ContainerHeader.ContainerNumber'
		)

select
	*
from
	FT.NumberSequenceKeys nsk
