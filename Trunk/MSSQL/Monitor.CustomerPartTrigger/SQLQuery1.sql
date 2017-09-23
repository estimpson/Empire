/*
Create trigger MONITOR.dbo.tr_order_header_customer_part_iu on dbo.order_header
*/

--use MONITOR
--go

if	objectproperty(object_id('dbo.tr_order_header_customer_part_iu'), 'IsTrigger') = 1 begin
	drop trigger dbo.tr_order_header_customer_part_iu
end
go

create trigger dbo.tr_order_header_customer_part_iu on dbo.order_header after insert, update
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
	/*	Override customer part changes to order header. */
	if	exists
			(	select
					*
				from
					dbo.order_header oh
					join Inserted i
						on i.order_no = oh.order_no
				where
					i.customer_part != oh.customer_part
			) begin

			--- <Update rows="1+">
			set	@TableName = 'dbo.order_header'
			
			update
				oh
			set
				customer_part = i.customer_part
			from
				dbo.order_header oh
				join Inserted i
					on i.order_no = oh.order_no
			where
				i.customer_part != oh.customer_part
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
				rollback tran @ProcName
				return
			end
			if	@RowCount <= 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating into %s in procedure %s.  Rows Updated: %d.  Expected rows: 1 or more.', 16, 1, @TableName, @ProcName, @RowCount)
				rollback tran @ProcName
				return
			end
			--- </Update>
	end

	/*	Override customer part changes to order detail. */
	if	exists
			(	select
					*
				from
					dbo.order_detail od
					join Inserted i
						on i.order_no = od.order_no
				where
					i.customer_part != od.customer_part
			) begin

			--- <Update rows="1+">
			set	@TableName = 'dbo.order_detail'
			
			update
				od
			set
				customer_part = i.customer_part
			from
				dbo.order_detail od
				join Inserted i
					on i.order_no = od.order_no
			where
				i.customer_part != od.customer_part
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
				rollback tran @ProcName
				return
			end
			if	@RowCount <= 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating into %s in procedure %s.  Rows Updated: %d.  Expected rows: 1 or more.', 16, 1, @TableName, @ProcName, @RowCount)
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
	dbo.order_header
...

update
	...
from
	dbo.order_header
...

delete
	...
from
	dbo.order_header
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

alter table dbo.order_header disable trigger tr_order_header_customer_part_iu
go
