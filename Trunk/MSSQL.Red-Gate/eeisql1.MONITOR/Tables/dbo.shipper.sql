CREATE TABLE [dbo].[shipper]
(
[id] [int] NOT NULL,
[destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[shipping_dock] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ship_via] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[date_shipped] [datetime] NULL,
[aetc_number] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[freight_type] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[printed] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bill_of_lading_number] [int] NULL,
[model_year_desc] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[model_year] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[location] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[staged_objs] [int] NULL,
[plant] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoiced] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoice_number] [int] NULL,
[freight] [numeric] (15, 6) NULL,
[tax_percentage] [numeric] (6, 3) NULL,
[total_amount] [numeric] (15, 6) NULL,
[gross_weight] [numeric] (20, 6) NULL,
[net_weight] [numeric] (20, 6) NULL,
[tare_weight] [numeric] (20, 6) NULL,
[responsibility_code] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[trans_mode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pro_number] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[notes] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[time_shipped] [datetime] NULL,
[truck_number] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoice_printed] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[seal_number] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[terms] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tax_rate] [numeric] (20, 6) NULL,
[staged_pallets] [int] NULL,
[container_message] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[picklist_printed] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dropship_reconciled] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[date_stamp] [datetime] NULL,
[platinum_trx_ctrl_num] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[posted] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[scheduled_ship_time] [datetime] NULL,
[currency_unit] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[show_euro_amount] [smallint] NULL,
[cs_status] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bol_ship_to] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bol_carrier] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[operator] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExpediteCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create TRIGGER [dbo].[fttr_shipper_insert]
on [dbo].[shipper]
for Insert
as

begin
-----------------------------------------------------------------------------------------------
-- 12/19/16, ASB, Fore-Thought, LLC	Call EMail Alert for all Shipments
-----------------------------------------------------------------------------------------------

-- declarations
declare	@shipper		integer,
	@TradingPartner VARCHAR(25),
	@TranDT datetime, 
	@ProcResult int 

-- set shipper_detail.date_shipped and order_header last_shipped on ship out


	SELECT	@shipper = MIN ( id )
	FROM 	inserted

	
	 Begin
	 exec [FT].[ftsp_EMailAlert_ShipperCreation]  @shipper, 	@TranDT = @TranDT out ,	@Result = @ProcResult out 
	 End
	 
	
End
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[fttr_shipper_update]
on [dbo].[shipper]
for update
as
-----------------------------------------------------------------------------------------------
--	09/25/14, ASB, Fore-Thought, LLC	Call EMail Alert for Autoliv Shipments
--	01/07/15, ASB, Fore-Thought, LLC	UPdate orderdetail for Autoliv orders so they RANs are in proper order in order_detail and alert user to save orders via Monitor
-- 05/14/16, ASB, Fore-Thought, LLC	Call EMail Alert for Autosystems Shipments
-----------------------------------------------------------------------------------------------

-- declarations
declare	@shipper		integer,
	@TradingPartner VARCHAR(25),
	@TranDT datetime, -------Added 2014-03-07 Andre S. Boulanger Fore-Thought, LLC
	@ProcResult int -------Added 2014-03-07 Andre S. Boulanger Fore-Thought, LLC

-- set shipper_detail.date_shipped and order_header last_shipped on ship out
if exists (
	select	inserted.status
	from	inserted
		join deleted on inserted.id = deleted.id
	where	inserted.status in ('C', 'Z') and
				deleted.status not in ('C', 'Z' ) and
				inserted.date_shipped is Not NULL and
				deleted.date_shipped is NULL and
				inserted.type is NULL
				 )
BEGIN

	SELECT	@shipper = MIN ( id )
	FROM 	inserted

	SELECT @TradingPartner = COALESCE(trading_partner_code,'')
	FROM
		shipper s
	JOIN
		edi_setups es ON es.destination = s.destination
	WHERE
		s.id = @shipper


	
	 If @TradingPartner = 'AutoLiv'
	 Begin
	 exec ft.ftsp_EMailAlert_AutoLivShipment  @shipper, 	@TranDT = @TranDT out ,	@Result = @ProcResult out 
	 End
	 
	 If @TradingPartner like '%Autosys%'
	 Begin
	 exec ft.ftsp_EMailAlert_AutoSystemsShipment  @shipper, 	@TranDT = @TranDT out ,	@Result = @ProcResult out 
	 End


end

if exists (
	select	inserted.status
	from	inserted
		join deleted on inserted.id = deleted.id
	where	inserted.status = 'S' and
		deleted.status <> 'S' )
BEGIN

	SELECT	@shipper = MIN ( id )
	FROM 	inserted

	SELECT @TradingPartner = COALESCE(trading_partner_code,'')
	FROM
		shipper s
	JOIN
		edi_setups es ON es.destination = s.destination
	WHERE
		s.id = @shipper


	
	 If @TradingPartner = 'AutoLiv'
	 Begin
	 
	 update 
		order_detail 
	 set 
		due_date = DATEADD(MILLISECOND, convert(numeric(20,8),substring(release_no,4,10))/100, due_date) 
	 where 
		DATALENGTH(release_no) > 10 and
		order_no in ( Select order_no from shipper_detail where shipper =  @shipper )
	 
	 exec ft.ftsp_EMailAlert_AutoLivShipmentRequireOrderSave  @shipper, 	@TranDT = @TranDT out ,	@Result = @ProcResult out 
	 End


end
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE trigger [dbo].[mtr_shipper_i] on [dbo].[shipper] for insert
as
begin

/*
Object:			Insert Trigger [dbo].[mtr_shipper_i]    
Script Date:	11/17/2001
Authors:		Harish G.P. (Monitor)
		
Use:			

Dependencies:	Table [dbo].[shipper]
				
Change Log:		2001-11-17; Harish G.P.
				Included the code to sync shipper and invoice on manual invoices.
				
				2002-09-06; Harish G.P.
				Commented out the shipper update statement to overcome the recursive trigger problem

				2012-07-10 2:00 PM; Dan West
				Created email notification of shipper creation
*/

    -- declarations
	declare	@shipper	integer
	declare @type		char(1)

	-- get first updated row
	select	@shipper = min(id)
	from 	inserted

	-- loop through all updated records
	while ( isnull(@shipper,-1) <> -1 )
	begin

		if (	select	isnull(currency_unit,'')
			from	inserted
			where	id = @shipper ) > ''
		begin
			exec msp_calc_invoice_currency @shipper, null, null, null, null
/*
			update 	shipper set
				cs_status = destination.cs_status
			from	destination
			where	shipper.id = @shipper and
				destination.destination = shipper.destination
*/				
		end
/*		else
			update 	shipper set
				cs_status = destination.cs_status,
				currency_unit = isnull ( destination.default_currency_unit, (	select	default_currency_unit
												from	customer
												where	customer.customer = destination.customer  ) )
			from	destination
			where	shipper.id = @shipper and
				destination.destination = shipper.destination
*/		
		-- Get the type from the inserted view
		select	@type = isnull(type,'')
		from	inserted
		where	id = @shipper

		-- check if type is 'M', (ie manual invoice) then, sync shipper & invoice no.
		-- if need be add other types too here
		if @type ='M'
			execute msp_sync_shipper_invoice @shipper

		select	@shipper = min(id)
		from 	inserted
		where	id > @shipper

	end

end
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE trigger [dbo].[mtr_shipper_u]
on [dbo].[shipper]
for update
as
-----------------------------------------------------------------------------------------------
--	Modifications	
--	08/08/02, HGP	Commented the date updation statement on the shipper as	that's being handled in the msp_shipout routine
--	09/06/02, HGP	Commented the shipper update st. to overcome the recurrsive trigger problem.
--	09/12/08, ASB	Update shipper_detail.account_code to '4010' for Normal and Quick Shippers
--	09/15/09, ASB	Update shipper_detail.account_code to '4011' for RMAs
--	03/07/14, ASB, Fore-Thought, LLC	Call EMail Alert
-----------------------------------------------------------------------------------------------

-- declarations
declare	@shipper		integer,
	@inserted_cu		varchar (3),
	@inserted_status	varchar (20),
	@deleted_cu		varchar (3),
	@deleted_status 	varchar (20),
	@type			varchar (7),
	@order_no		numeric(8,0),
	@inserted_invoice	integer,
	@deleted_invoice	integer,
	@TranDT datetime, -------Added 2014-03-07 Andre S. Boulanger Fore-Thought, LLC
	@ProcResult int -------Added 2014-03-07 Andre S. Boulanger Fore-Thought, LLC

-- set shipper_detail.date_shipped and order_header last_shipped on ship out
if exists (
	select	inserted.status
	from	inserted
		join deleted on inserted.id = deleted.id
	where	inserted.status = 'C' and
		deleted.status <> 'C' )
begin
	update	order_header
	   set	shipper = inserted.id
	  from	inserted
	  	join shipper_detail on inserted.id = shipper_detail.shipper
	 where	shipper_detail.order_no = order_header.order_no

	 If exists ( Select 1 from shipper_detail where shipper = @shipper and qty_packed>qty_original)
	 Begin
	 exec ft.ftsp_EMailAlert_OverShipment  @shipper, 	@TranDT = @TranDT out ,	@Result = @ProcResult out -- Added 3-7-14 Andre S. Boulanger Fore-thought, LLC
	 End



end

-- get first updated row
select	@shipper = min ( id )
  from 	inserted

-- loop through all updated records
while ( isnull ( @shipper, -1 ) <> -1 )
begin
	select	@deleted_cu = currency_unit,
		@deleted_status = status,
		@deleted_invoice = invoice_number
	  from	deleted
	 where	id = @shipper

	select	@inserted_cu = currency_unit,
		@inserted_status = status,
		@inserted_invoice = invoice_number,
		@type = isnull ( type, 'Q' )
	  from	inserted
	 where	id = @shipper

	select	@deleted_cu = isnull ( @deleted_cu, '' )
	select	@deleted_status = isnull ( @deleted_status, '' )
	select	@inserted_cu = isnull ( @inserted_cu, '' )
	select	@inserted_status = isnull ( @inserted_status, '' )

	if @deleted_cu <> @inserted_cu
		exec msp_calc_invoice_currency @shipper, null, null, null, null

	else if @inserted_status <> @deleted_status and @inserted_status = 'C'
	begin
/*	
		update	shipper
		set	date_shipped = GetDate ( )
		where	id = @shipper
*/

		update	shipper_detail
		set	total_cost = isnull (
			(	select	sum ( std_quantity * cost )
				from	audit_trail
				where	audit_trail.shipper = convert(varchar,@shipper) and
					part=shipper_detail.part_original and
					isnull ( audit_trail.suffix, 0 ) = isnull ( shipper_detail.suffix, 0 ) and
					audit_trail.type = 'S' ), total_cost )
		from	shipper_detail
		where	shipper_detail.shipper = @shipper
--Ensure sales account 4010 is in shipper_detail
--Ensure sales account 4011 is in shipper_detal for RMAs	
		update	shipper_detail
		set		account_code = '4010'			
		from		shipper_detail,
				shipper
		where	shipper_detail.shipper = @shipper and
				shipper.id = @shipper and
				nullif(account_code,'') is NULL and
				(shipper.type is NULL or shipper.type = 'Q')
		update	shipper_detail
		set		account_code = '4011'			
		from		shipper_detail,
				shipper,
				product_line
		where	shipper_detail.shipper = @shipper and
				shipper.id = @shipper and
				nullif(account_code,'') is NULL and
				(shipper.type  = 'R')
				

		select	@order_no = min(order_no)
		from	shipper_detail
		where	shipper = @shipper
		
		while ( isnull(@order_no,0) > 0 )
		begin
		
			exec msp_calculate_committed_qty @order_no, null, null
			
			select @order_no = isnull ( (
				select	min(order_no)
				from	shipper_detail
				where	shipper = @shipper and
					order_no > @order_no ), 0 )
		end
	end

/*
	update 	shipper
	set	cs_status = destination.cs_status
	from	destination
	where	shipper.id = @shipper and
		destination.destination = shipper.destination
*/		

--	Commented the below if statement as it has to call that proc for all types of shippers
	if isnull ( @inserted_invoice, 0 ) <> isnull ( @deleted_invoice, 0 ) -- and @type = 'Q'
		exec msp_sync_shipper_invoice @shipper
		
	select	@shipper = min(id)
	  from 	inserted
	 where	id > @shipper
end
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [dbo].[shipper_AuditChangeTracking] on [dbo].[shipper] after insert, update, delete
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
	declare
		@connectionID uniqueidentifier =
		(	select
				connection_id
			from
				sys.dm_exec_connections
			where
				session_id = @@spid
		)
	,	@transactionID bigint =
		(	select
				transaction_id
			from
				sys.dm_tran_current_transaction
		)
	,	@newData xml =
		(	select
				*
			from
				Inserted i
			for xml auto
		)
	,	@oldData xml =
		(	select
				*
			from
				Deleted d
			for xml auto
		)
	,	@connectionInfo xml =
		(	select
				session_id
			,	most_recent_session_id
			,	connect_time
			,	net_transport
			,	protocol_type
			,	protocol_version
			,	endpoint_id
			,	encrypt_option
			,	auth_scheme
			,	node_affinity
			,	num_reads
			,	num_writes
			,	last_read
			,	last_write
			,	net_packet_size
			,	client_net_address
			,	client_tcp_port
			,	local_net_address
			,	local_tcp_port
			,	connection_id
			,	parent_connection_id
			from
				sys.dm_exec_connections
			where
				session_id = @@spid
			for xml auto
		)
	,	@sessionInfo xml =
		(	select
				session_id
			,	login_time
			,	host_name
			,	program_name
			,	host_process_id
			,	client_version
			,	client_interface_name
			,	login_name
			,	nt_domain
			,	nt_user_name
			,	status
			,	cpu_time
			,	memory_usage
			,	total_scheduled_time
			,	total_elapsed_time
			,	endpoint_id
			,	last_request_start_time
			,	last_request_end_time
			,	reads
			,	writes
			,	logical_reads
			,	is_user_process
			,	text_size
			,	language
			,	date_format
			,	date_first
			,	quoted_identifier
			,	arithabort
			,	ansi_null_dflt_on
			,	ansi_defaults
			,	ansi_warnings
			,	ansi_padding
			,	ansi_nulls
			,	concat_null_yields_null
			,	transaction_isolation_level
			,	lock_timeout
			,	deadlock_priority
			,	row_count
			,	prev_error
			,	original_login_name
			,	last_successful_logon
			,	last_unsuccessful_logon
			,	unsuccessful_logons
			,	group_id
			from
				sys.dm_exec_sessions
			where
				session_id = @@spid
			for xml auto
		)
	,	@transactionInfo xml =
		(	select
				*
			from
				sys.dm_tran_current_transaction
			for xml auto
		)

	--- <Insert rows="*">
	set	@TableName = 'Audit.DataChanges'
	
	insert
		Audit.DataChanges
	(	ConnectionID
	,	TransactionID
	,	TableName
	,	OldData
	,	NewData
	,	ConnectionInfo
	,	SessionInfo
	,	TransactionInfo
	)
	select
		ConnectionID = @connectionID
	,	TransactionID = @transactionID
	,	TableName = 'dbo.shipper'
	,	OldData = @oldData
	,	NewData = @newData
	,	ConnectionInfo = @connectionInfo
	,	SessionInfo = @sessionInfo
	,	TransactionInfo = @transactionInfo
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
	
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	--- </Insert>
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
	dbo.shipper
...

update
	...
from
	dbo.shipper
...

delete
	...
from
	dbo.shipper
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
DISABLE TRIGGER [dbo].[shipper_AuditChangeTracking] ON [dbo].[shipper]
GO
ALTER TABLE [dbo].[shipper] ADD CONSTRAINT [PK__shipper__4F089A18] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [bwa_shipper_cust_indx] ON [dbo].[shipper] ([customer], [date_shipped]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_shipper_1] ON [dbo].[shipper] ([id], [status], [type]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [bi_shipper_pl1] ON [dbo].[shipper] ([status], [date_stamp]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_shipper_4] ON [dbo].[shipper] ([status], [id]) INCLUDE ([destination]) ON [PRIMARY]
GO
