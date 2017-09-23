CREATE TABLE [dbo].[order_header]
(
[order_no] [numeric] (8, 0) NOT NULL,
[customer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[order_date] [datetime] NULL,
[contact] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[blanket_part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[model_year] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer_part] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[box_label] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pallet_label] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[standard_pack] [decimal] (20, 6) NULL,
[our_cum] [decimal] (20, 6) NULL,
[the_cum] [decimal] (20, 6) NULL,
[order_type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[amount] [decimal] (20, 6) NULL,
[shipped] [decimal] (20, 6) NULL,
[deposit] [decimal] (20, 6) NULL,
[artificial_cum] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[shipper] [int] NULL,
[status] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[location] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ship_type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[unit] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[revision] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer_po] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[blanket_qty] [decimal] (20, 6) NULL,
[price] [decimal] (20, 6) NULL,
[price_unit] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[salesman] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zone_code] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[term] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dock_code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[package_type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[plant] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[notes] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[shipping_unit] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line_feed_code] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fab_cum] [decimal] (15, 2) NULL,
[raw_cum] [decimal] (15, 2) NULL,
[fab_date] [datetime] NULL,
[raw_date] [datetime] NULL,
[po_expiry_date] [datetime] NULL,
[begin_kanban_number] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[end_kanban_number] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line11] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line12] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line13] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line14] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line15] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line16] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line17] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom01] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom02] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom03] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[quote] [int] NULL,
[due_date] [datetime] NULL,
[engineering_level] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[currency_unit] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alternate_price] [decimal] (20, 6) NULL,
[show_euro_amount] [smallint] NULL,
[cs_status] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_customer_part] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[order_status] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [dbo].[mtr_order_header_i] on [dbo].[order_header] for insert
as
begin
	-- declarations
	declare	@order_no	numeric(8,0),
			@inserted_status varchar(20)

	-- get first updated/inserted row
	select	@order_no = min(order_no)
	from	inserted

	-- loop through all updated records and call procedure to calculate the currency price
	while ( isnull(@order_no,-1) <> -1 )
	begin

		exec msp_calc_order_currency @order_no, null, null, null, null

		select	@inserted_status = isnull(cs_status,'')
		from	inserted
		where	order_no = @order_no

		update 	shipper 
		set		cs_status = @inserted_status
		from 	shipper_detail
		where 	shipper.id = shipper_detail.shipper and
				shipper_detail.order_no = @order_no

		select	@order_no = min(order_no)
		from	inserted
		where	order_no > @order_no

	end

end
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE trigger [dbo].[mtr_order_header_u]
on [dbo].[order_header]
for update
as
-- declarations
declare	@order_no	numeric(8,0),
	@deleted_cu	varchar(3),
	@deleted_ap	numeric(20,6),
	@deleted_status varchar(20),
	@deleted_box_label varchar(25),
	@deleted_pallet_label varchar(25),
	@inserted_cu varchar(3),
	@inserted_ap numeric(20,6),
	@inserted_status varchar(20),
	@inserted_box_label varchar(25),
	@inserted_pallet_label varchar(25),
	@type varchar(1),
	@InsertedCurrentRevLevel char(1),
	@DeletedCurrentRevLevel char(1),
	@InsertedPartNumber varchar(25)

-- get first updated/inserted row
select	@order_no = min(order_no)
from	inserted

-- loop through all updated records and call procedure to generate kanban and calculate the currency price.
while ( isnull(@order_no,-1) <> -1 )
begin
	EXECUTE	msp_generate_kanban @order_no

	select	@inserted_cu = currency_unit,
		@inserted_ap = alternate_price,
		@inserted_status = cs_status,
		@inserted_box_label = box_label,
		@inserted_pallet_label = pallet_label,
		@type = order_type,
		@InsertedCurrentRevLevel = isNull(status,'O'),
		@InsertedPartNumber = isNull(blanket_part,'')
	from	inserted
	where	order_no = @order_no

	select	@deleted_cu = currency_unit,
		@deleted_ap = alternate_price,
		@deleted_status = cs_status,
		@deleted_box_label = box_label,
		@deleted_pallet_label = pallet_label,
		@DeletedCurrentRevLevel = isNull(status,'O')
	from	deleted
	where	order_no = @order_no

	select @inserted_cu = isnull(@inserted_cu,'')
	select @inserted_ap = isnull(@inserted_ap,0)
	select @inserted_status = isnull(@inserted_status,'')
	select @inserted_box_label = isnull ( @inserted_box_label, '' )
	select @inserted_pallet_label = isnull ( @inserted_pallet_label, '' )
	select @deleted_cu = isnull(@deleted_cu,'')
	select @deleted_ap = isnull(@deleted_ap,0)
	select @deleted_status = isnull(@deleted_status,'')
	select @deleted_box_label = isnull ( @deleted_box_label, '' )
	select @deleted_pallet_label = isnull ( @deleted_pallet_label, '' )

	if 	@inserted_cu <> @deleted_cu or
		@inserted_ap <> @deleted_ap
		exec msp_calc_order_currency @order_no, null, null, null, null
/*	else if @inserted_status <> @deleted_status
		update 	shipper 
		set	cs_status = @inserted_status
		from 	shipper_detail
		where 	shipper.id = shipper_detail.shipper and
			shipper_detail.order_no = @order_no
*/
	if	@type = 'B' and
		( @inserted_box_label <> @deleted_box_label or
		@inserted_pallet_label <> @deleted_pallet_label )
		update	order_detail
		set	box_label = @inserted_box_label,
			pallet_label = @inserted_pallet_label
		where	order_no = @order_no
	

		
/*
Andre S. Boulanger	2011/11/18	Added code that set CurrentRevLevel in part_eecustom when Active Rev on the order  is modified
*/

	if @InsertedCurrentRevLevel!=@DeletedCurrentRevLevel and @InsertedCurrentRevLevel = 'A'
	begin
		update part_eecustom set CurrentRevLevel ='N' where  left(part,7) = left(@InsertedPartNumber,7)
		update	part_eecustom set CurrentRevLevel ='Y' where  part = @InsertedPartNumber
	End
		
	select	@order_no = min(order_no)
	from	inserted
	where	order_no > @order_no

end
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [dbo].[tr_order_header_customer_part_iu] on [dbo].[order_header] after insert, update
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
GO
DISABLE TRIGGER [dbo].[tr_order_header_customer_part_iu] ON [dbo].[order_header]
GO
ALTER TABLE [dbo].[order_header] ADD CONSTRAINT [PK_order_header] PRIMARY KEY CLUSTERED  ([order_no]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ixOrderHeader_1] ON [dbo].[order_header] ([blanket_part]) INCLUDE ([customer], [destination], [order_no]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_order_header_2] ON [dbo].[order_header] ([destination]) INCLUDE ([customer_part], [customer_po], [order_no]) ON [PRIMARY]
GO
CREATE STATISTICS [_dta_stat_1291867669_6_1_5_2] ON [dbo].[order_header] ([destination], [customer], [blanket_part], [order_no])
GO
