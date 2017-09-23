CREATE TABLE [dbo].[shipper_detail]
(
[shipper] [int] NOT NULL,
[part] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[qty_required] [numeric] (20, 6) NULL,
[qty_packed] [numeric] (20, 6) NULL,
[qty_original] [numeric] (20, 6) NULL,
[accum_shipped] [numeric] (20, 6) NULL,
[order_no] [numeric] (8, 0) NULL,
[customer_po] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[release_no] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[release_date] [datetime] NULL,
[type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[price] [numeric] (20, 6) NULL,
[account_code] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[salesman] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tare_weight] [numeric] (20, 6) NULL,
[gross_weight] [numeric] (20, 6) NULL,
[net_weight] [numeric] (20, 6) NULL,
[date_shipped] [datetime] NULL,
[assigned] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[packaging_job] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[note] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[operator] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[boxes_staged] [int] NULL,
[pack_line_qty] [numeric] (20, 6) NULL,
[alternative_qty] [numeric] (20, 6) NULL,
[alternative_unit] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[week_no] [int] NULL,
[taxable] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[price_type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cross_reference] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer_part] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dropship_po] [int] NULL,
[dropship_po_row_id] [int] NULL,
[dropship_oe_row_id] [int] NULL,
[suffix] [int] NULL,
[part_name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[part_original] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[total_cost] [numeric] (20, 6) NULL,
[group_no] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dropship_po_serial] [int] NULL,
[dropship_invoice_serial] [int] NULL,
[stage_using_weight] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alternate_price] [numeric] (20, 6) NULL,
[old_suffix] [int] NULL,
[old_shipper] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[mtr_shipper_detail_d] ON [dbo].[shipper_detail] FOR DELETE
AS
BEGIN
	-- declarations
	DECLARE	@shipper		INTEGER,
		@part			VARCHAR(35),
		@suffix			INTEGER,
		@order_number		NUMERIC(8,0),
		@linecount		INTEGER,
		@part_original		VARCHAR(25),
		@TranDT DATETIME, -------Added 2014-05-13 Andre S. Boulanger Fore-Thought, LLC
		@ProcResult INT, -------Added 2014-05-13 Andre S. Boulanger Fore-Thought, LLC
		@SchedulerInitials varchar(15) -------Added 2014-05-13 Andre S. Boulanger Fore-Thought, LLC


	-- get first updated/deleted row
	SELECT	@shipper = MIN(shipper)
	FROM 	deleted

	SELECT @SchedulerInitials = MAX(COALESCE(NULLIF(d.scheduler,''),'GU'))
	FROM
		shipper s
	JOIN
		destination d ON d.destination = s.destination
	WHERE
		s.id = @shipper
	
	-- loop through all updated records
	WHILE ( ISNULL(@shipper,-1) <> -1 )
	BEGIN

		-- Get the number line items on shipper.
		SELECT	@linecount = COUNT ( 1 )
		  FROM	shipper_detail
		 WHERE	shipper = @shipper
		 
		-- If shipper is now empty, mark it as empty.
		IF @linecount = 0
			UPDATE	shipper
			   SET	status = 'E'
			 WHERE	id = @shipper
	
		SELECT	@part = MIN(part)
		FROM 	deleted
		WHERE	shipper = @shipper

		WHILE ( ISNULL(@part,'') <> '' )
		BEGIN

			SELECT	@suffix = suffix,
				@order_number = order_no,
				@part_original = part_original
			FROM	deleted
			WHERE	shipper = @shipper AND
				part = @part
				
			IF ISNULL ( @order_number, 0 ) > 0
				EXEC msp_calculate_committed_qty @order_number, @part_original, @suffix

				BEGIN
				EXEC ft.ftsp_EMailAlert_ShipperLineItemDeleted  @shipper, @order_number, @part_original, @SchedulerInitials,	@TranDT = @TranDT OUT ,	@Result = @ProcResult OUT
				END
					
			SELECT	@part = MIN(part)
			FROM 	deleted
			WHERE	shipper = @shipper AND
				part > @part

		END

		SELECT	@shipper = MIN(shipper)
		FROM 	deleted
		WHERE	shipper > @shipper

	END

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE trigger [dbo].[mtr_shipper_detail_i] on [dbo].[shipper_detail] for insert
as
begin
	-- declarations
	declare	@shipper		integer,
		@part			varchar(35),
		@suffix			integer,
		@order_number		numeric(8,0),
		@part_original		varchar(25),
		@ShipperType varchar(10),
		@CustomerCode varchar(15)
		

	-- get first updated/inserted row
	select	@shipper = min(shipper)
	from 	inserted
	
	--get shipper type
	
	select @ShipperType = coalesce(type, 'X')
	from	shipper where id = @shipper
	
	--get Customer Code
	
	select @CustomerCode = customer
	from	shipper where id = @shipper


	-- loop through all updated records
	while ( isnull(@shipper,-1) <> -1 )
	begin

		select	@part = min(part)
		from 	inserted
		where	shipper = @shipper

		while ( isnull(@part,'') <> '' )
		begin

			exec msp_calc_invoice_currency @shipper, null, null, @part, null
	
			select	@part_original = part_original,
				@suffix = suffix,
				@order_number = order_no
			from	inserted
			where	shipper = @shipper and
				part = @part
				
			if isnull ( @order_number, 0 ) > 0
				Begin
				
				exec msp_calculate_committed_qty @order_number, @part_original, @suffix
				
				if	@ShipperType = 'R'
				Begin
				--Begin Added 02/15/2012 - Andre S.Boulanger Fore-Thought, LLC
				update	shipper_detail
				set		account_code = coalesce((select sales_return_account from dbo.part_eecustom where part = @part and nullif(sales_return_account,'') is not null), i.account_code,'')
				from		shipper_detail
				join		shipper on dbo.shipper_detail.shipper = dbo.shipper.id
				join		inserted i on shipper_detail.shipper = i.shipper and shipper_detail.part_original = i.part_original
				where	shipper_detail.shipper = @shipper and
							shipper_detail.part_original = @part_original and
							isNull(shipper.type,'X') = 'R'
				--End	Added 02/15/2012
				end
				
				if exists (select 1 from shipper_detail sd join shipper s on sd.shipper = s.id where s.status in  ('O', 'A', 'S') and sd.order_no = @order_number and sd.shipper != @shipper and @CustomerCode like '%NAL%')
				--Begin Added 02/17/2012 - Andre S.Boulanger Fore-Thought, LLC
				
	Begin			
				Declare  
	@OrderDetail table 
( 
id int not null Identity (1,1) primary key ,
OrderNo int,
Part varchar(25),
DueDate datetime,
Quantity numeric (20,6),
PriorAccum	numeric(20,6),
Accum numeric(20,6),
RAN varchar(30) 
)
	
insert 
	@OrderDetail
( 
OrderNo,
Part,
DueDate ,
Quantity ,
RAN
 )
	
select
	order_no,
	part_number,
	due_date,
	quantity,
	release_no
from	
	dbo.order_detail
where
	order_no = @Order_number
order by 
	due_date, release_no, id
		
		
update	 od
		set	Accum = (select sum(quantity) from @OrderDetail where ID <= od.ID ),
				PriorAccum = COALESCE((select sum(quantity) from @OrderDetail where ID < od.ID ),0)
				
from
	@OrderDetail od
		

Declare  
	@ShipperDetail table 
( 
id int not null Identity (1,1) primary key,
ShipperID int,
DateStamp datetime,
ScheduledShipTime datetime null,
Quantity numeric(20,6),
PriorAccum numeric (20,6),
Accum numeric(20,6)
)
	
insert 
	@ShipperDetail
( 
ShipperID ,
DateStamp ,
ScheduledShipTime,
Quantity
 )
	
select
	s.id,
	s.date_stamp,
	scheduled_ship_time,
	sd.qty_required
from	
	dbo.shipper s
join
	shipper_detail sd on s.id = sd.shipper
where
	sd.order_no = @Order_number and
	s.status in ('O', 'A', 'S') and
	s.type is NULL
order by 
	ft.fn_DatePart('Year',date_stamp),ft.fn_DatePart('DayofYear',date_stamp), ft.fn_DatePart('Hour',scheduled_ship_time), ft.fn_DatePart('Minute',scheduled_ship_time), ft.fn_DatePart('Second',scheduled_ship_time) , s.id
	
update	 sd
		set	Accum = (select sum(quantity) from @ShipperDetail where ID <= sd.ID),
				PriorAccum = COALESCE((select sum(quantity) from @shipperDetail where ID < sd.ID),0)
from
	@ShipperDetail sd


declare @OrderRANAlert table(
				OrderNo int null,
				Part varchar(25) null,
				RAN varchar(50) null,
				RANQuantiy int null,
				RanDueDate datetime null,
				ShipperID  int,
				ShipperDateStamp datetime null,
				ScheduledShipTime datetime null
				)


insert	@OrderRANAlert
        (	OrderNo,
			Part,  
			RAN ,
			RANQuantiy ,
			RanDueDate ,
			ShipperID,
			ShipperDateStamp,
			ScheduledShipTime
        )

select
	od.OrderNo, 	
	od.Part,
	RAN,
	CalculatedRanQuantity= case
		when od.Accum<=sd.Accum and od.PriorAccum>=sd.PriorAccum
		then od.quantity
		when od.Accum>=sd.Accum and od.PriorAccum<=sd.PriorAccum
		then sd.Accum-sd.PriorAccum
		when od.Accum>=sd.PriorAccum and od.PriorAccum<=sd.PriorAccum
		then od.Accum-sd.PriorAccum
		when od.Accum>sd.PriorAccum and od.PriorAccum<=sd.Accum
		then sd.Accum-od.priorAccum
		else	0
		end,
	RANDueDate = od.DueDate,
	ShipperID = sd.ShipperID,
	ShipperDateStamp = sd.DateStamp,
	ScheduledShipTime =sd.ScheduledShipTime
from		
	@OrderDetail od 
join
	@ShipperDetail sd on sd.PriorAccum <= od.PriorAccum
where
	case
		when od.Accum<=sd.Accum and od.PriorAccum>=sd.PriorAccum
		then od.quantity
		when od.Accum>=sd.Accum and od.PriorAccum<=sd.PriorAccum
		then sd.Accum-sd.PriorAccum
		when od.Accum>=sd.PriorAccum and od.PriorAccum<=sd.PriorAccum
		then od.Accum-sd.PriorAccum
		when od.Accum>sd.PriorAccum and od.PriorAccum<=sd.Accum
		then sd.Accum-od.priorAccum
		else	0
		end >0
	
	
	DECLARE @tableHTML  NVARCHAR(MAX) ;

SET @tableHTML =
    N'<H1>NAL Order Having Mutiple Shippers</H1>' +
    N'<table border="1">' +
    N'<tr><th>OrderNo</th>' +
    N'<th>Part</th><th>RAN</th><th>RANQty</th><th>RANDueDate</th><th>ShipperID</th><th>ShipperDateStamp</th>' +
    N'<th>ScheduledShipTime</th></tr>' +
    CAST ( ( SELECT td = eo.OrderNo, '',
                    td = eo.Part, '',
                    td = eo.RAN, '',
                    td = eo.RANQuantiy, '',
                    td = eo.RanDueDate, '',
                    td = eo.ShipperID, '',
                     td = eo.ShipperDateStamp, '',
                    td = eo.ScheduledShipTime
              FROM @OrderRANAlert  eo
              order by 1,2,3  
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' ;
    
exec msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
    @recipients = 'MMinth@empireelect.com; Mcalix@empireelect.com', -- varchar(max)
    @copy_recipients = 'aboulanger@fore-thought.com;dwest@empireelect.com', -- varchar(max)
    --@blind_copy_recipients = 'aboulanger@fore-thought.com;estimpson@fore-thought.com', -- varchar(max)
    @subject = N'Mutiple Shippers Scheduled to Dock for NAL', -- nvarchar(255)
    @body = @TableHTML, -- nvarchar(max)
    @body_format = 'HTML', -- varchar(20)
    @importance = 'High' -- varchar(6)

	End						
										
										
				--End	Added 02/17/2012
				
				
				End
					
			select	@part = min(part)
			from 	inserted
			where	shipper = @shipper and
				part > @part

		end

		select	@shipper = min(shipper)
		from 	inserted
		where	shipper > @shipper

	end

end
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE trigger [dbo].[mtr_shipper_detail_u] on [dbo].[shipper_detail] for update
as
begin
	-- declarations

	--added call to ft.ftsp_EMailAlert_ShipperQtyRequiredEdit to Alert schedulers in the event shipper_detail qty_required is reduced (indicating a short shipment) Andre S. Boulanger Fore-Thought, LLC 2014-03-07
	
	
	declare	@shipper		integer,
		@part			varchar(35),
		@inserted_ap		numeric(20,6),
		@inserted_qty_required	numeric(20,6),
		@deleted_ap		numeric(20,6),
		@deleted_qty_required	numeric(20,6),
		@order_number		numeric(8,0),
		@suffix			integer,
		@shipper_status		varchar(1),
		@ShipperType varchar(1),		-------Added 2014-03-07 Andre S. Boulanger Fore-Thought, LLC
		@part_original		varchar(25),
		@TranDT datetime, -------Added 2014-03-07 Andre S. Boulanger Fore-Thought, LLC
		@ProcResult int, -------Added 2014-03-07 Andre S. Boulanger Fore-Thought, LLC
		@inserted_qty_original	numeric(20,6)  -------Added 2014-03-07 Andre S. Boulanger Fore-Thought, LLC

	-- get first updated/inserted row
	select	@shipper = min(shipper)
	from 	inserted


	-------Added 2014-03-07 Andre S. Boulanger Fore-Thought, LLC
	Select @ShipperType =  coalesce(type,'')
	From
		shipper
		where
				id = @shipper

	-- loop through all updated records
	while ( isnull(@shipper,-1) <> -1 )
	begin

		select	@part = min(part)
		from 	inserted
		where	shipper = @shipper

		while ( isnull(@part,'') <> '' )
		begin

			select	@deleted_ap = alternate_price,
				@deleted_qty_required = qty_required
			from	deleted
			where	shipper = @shipper and
				part = @part

			select @deleted_ap = isnull(@deleted_ap,-1)

			select	@inserted_ap = alternate_price,
				@inserted_qty_required = qty_required,
				@order_number = order_no,
				@suffix = suffix,
				@part_original = part_original,
				@inserted_qty_original = qty_original
			from	inserted
			where	shipper = @shipper and
				part = @part

			select @inserted_ap = isnull(@inserted_ap,-1)

			if @deleted_ap <> @inserted_ap
				exec msp_calc_invoice_currency @shipper, null, null, @part, null
	
			select	@shipper_status = status
			from	shipper
			where	id = @shipper
			
				if isnull ( @order_number, 0 ) > 0
				if isnull ( @deleted_qty_required, 0 ) <> isnull ( @inserted_qty_required, 0 )
					
					exec msp_calculate_committed_qty @order_number, @part_original, @suffix
--------		Added 2014-03-07 Andre S. Boulanger Fore-Thought, LLC
					
					if (isnull ( @deleted_qty_required, 0 ) > isnull ( @inserted_qty_required, 0 )	) and @ShipperType = ''	 and isnull ( @inserted_qty_required, 0 )	<  @inserted_qty_original
					Begin
					 exec ft.ftsp_EMailAlert_ShipperQtyRequiredEdit  @shipper, @order_number, @part_original, 	@TranDT = @TranDT out ,	@Result = @ProcResult out
					End
			select	@part = min(part)
			from 	inserted
			where	shipper = @shipper and
				part > @part

		end

		select	@shipper = min(shipper)
		from 	inserted
		where	shipper > @shipper

	end

end
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [dbo].[shipper_detail_AuditChangeTracking] on [dbo].[shipper_detail] after insert, update, delete
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
	,	TableName = 'dbo.shipper_detail'
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
	dbo.shipper_detail
...

update
	...
from
	dbo.shipper_detail
...

delete
	...
from
	dbo.shipper_detail
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
ALTER TABLE [dbo].[shipper_detail] ADD CONSTRAINT [PK__shipper___1060F3D411C057AF] PRIMARY KEY CLUSTERED  ([shipper], [part]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_shipper_detail_3] ON [dbo].[shipper_detail] ([customer_po], [customer_part]) INCLUDE ([shipper]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_date_shipped] ON [dbo].[shipper_detail] ([date_shipped]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_shipper_detail_4] ON [dbo].[shipper_detail] ([date_shipped] DESC, [part_original]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_shipper_detail_5] ON [dbo].[shipper_detail] ([part_original], [date_shipped] DESC) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_shipper_detail_1] ON [dbo].[shipper_detail] ([part_original], [order_no], [shipper], [qty_required]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_shipper_detail_2] ON [dbo].[shipper_detail] ([shipper], [part_original]) INCLUDE ([customer_part], [customer_po], [order_no], [qty_packed], [qty_required]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[shipper_detail] ADD CONSTRAINT [FK__shipper_d__shipp__149CC45A] FOREIGN KEY ([shipper]) REFERENCES [dbo].[shipper] ([id])
GO
