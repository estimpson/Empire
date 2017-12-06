CREATE TABLE [dbo].[order_detail]
(
[order_no] [numeric] (8, 0) NOT NULL,
[part_number] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[product_name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[quantity] [decimal] (20, 6) NULL,
[price] [decimal] (20, 6) NULL,
[notes] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[assigned] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[shipped] [decimal] (20, 6) NULL,
[invoiced] [decimal] (20, 6) NULL,
[status] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[our_cum] [decimal] (20, 6) NULL,
[the_cum] [decimal] (20, 6) NULL,
[due_date] [datetime] NULL,
[sequence] [decimal] (5, 0) NOT NULL,
[destination] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[unit] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[committed_qty] [decimal] (20, 6) NULL,
[row_id] [int] NULL,
[group_no] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cost] [decimal] (20, 6) NULL,
[plant] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[release_no] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[flag] [int] NULL,
[week_no] [int] NULL,
[std_qty] [decimal] (20, 6) NULL,
[customer_part] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ship_type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dropship_po] [int] NULL,
[dropship_po_row_id] [int] NULL,
[suffix] [int] NULL,
[packline_qty] [decimal] (20, 6) NULL,
[packaging_type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[weight] [decimal] (20, 6) NULL,
[custom01] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom02] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom03] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dimension_qty_string] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[engineering_level] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alternate_price] [decimal] (20, 6) NULL,
[box_label] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pallet_label] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[id] [int] NOT NULL IDENTITY(1, 1),
[EEIEntry] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[eeiqty] [decimal] (20, 6) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [dbo].[mtr_order_detail_d] on [dbo].[order_detail] for delete
as
begin
	-- declarations
	declare	@order_no			numeric(8,0),
		@sequence			numeric(5,0),
		@rowid				integer,
		@part				varchar(25),
		@shiptype			varchar(1),
		@suffix				integer

	-- get first updated/inserted row
	select	@order_no = min(order_no)
	from	deleted

	-- loop through all updated records
	while ( isnull(@order_no,-1) <> -1 )
	begin

		select	@sequence = min(sequence)
		from	deleted
		where	order_no = @order_no

		while ( isnull(@sequence,-1) <> -1 )
		begin

			select	@part = part_number,
				@rowid = row_id,
				@suffix = suffix,
				@shiptype = ship_type
			from	deleted
			where	order_no = @order_no and
				sequence = @sequence

			if isnull(@shiptype,'N') = 'N'
				exec msp_calculate_committed_qty @order_no, @part, @suffix
						
			select	@sequence = min(sequence)
			from	deleted
			where	order_no = @order_no and
				sequence > @sequence

		end

		select	@order_no = min(order_no)
		from	deleted
		where	order_no > @order_no

	end

end
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE trigger [dbo].[mtr_order_detail_i] on [dbo].[order_detail] for insert
as
begin
	-- declarations

	--2017/12/04 asb FT, LLC - Added customer part update on order detail; some cases whare an application is not writing customer_part on insert to order_detail


	declare	@order_no	numeric(8,0),
		@sequence	numeric(5,0),
		@part		varchar(25),
		@configurable	varchar(1),
		@count		smallint,
		@suffix		integer,
		@type		varchar(1),
		@shiptype	varchar(1),
		@box_label	varchar(25),
		@pallet_label	varchar(25),
		@customer	varchar(10),
		@price_type	char(1),
		@quantity numeric(20,6),
		@customertype VARCHAR(25),
		@customerpart VARCHAR(50)
	
	-- get first updated/inserted row
	select	@order_no = min(order_no)
	from	inserted

	-- loop through all updated records
	while ( isnull(@order_no,-1) <> -1 )
	begin

		select	@sequence = min(sequence)
		from	inserted
		where	order_no = @order_no

		select @quantity=isNULL(quantity,0)
        from inserted
        where order_no=@order_no
        and sequence=@sequence

		while ( isnull(@sequence,-1) <> -1 )
		begin

			exec msp_calc_order_currency @order_no, null, null, @sequence, null

			-- check if a suffix is needed only for normal orders
			select	@type = order_type,
				@part = blanket_part,
				@box_label = box_label,
				@pallet_label = pallet_label,
				@customer = order_header.customer,
				@customertype = ISNULL(region_code, 'EXTERNAL'),
				@customerpart = order_header.customer_part
			from	order_header
			JOIN	customer ON order_header.customer = dbo.customer.customer
			where	order_no = @order_no
			
			select	@shiptype = ship_type
			from	inserted
			where	order_no = @order_no and
				sequence = @sequence
				
			if @type = 'N'
			begin
				-- create suffix if part is configurable
				select	@part = part_number
				from	inserted
				where	order_no = @order_no and
					sequence = @sequence
					
				select	@configurable = configurable
				from	part_inventory
				where	part = @part
	
				if IsNull ( @configurable, 'N' ) = 'Y'
				begin
					select @count = 1
					
					while ( @count > 0 )
					begin
					
						select	@suffix = next_suffix
						from	part_inventory
						where	part = @part
						
						select	@suffix = IsNull ( @suffix, 1 )
						
						update	part_inventory set
							next_suffix = @suffix + 1
						where	part = @part
						
						select	@count = count(suffix)
						from	order_detail
						where	part_number = @part and
							suffix = @suffix
						
						if @count <= 0
							select	@count = count(suffix)
							from	shipper_detail
							where	part = @part and
								suffix = @suffix
								
						if @count <= 0
							select	@count = count(suffix)
							from	object
							where	part = @part and
								suffix = @suffix
								
						if @count <= 0
							update 	order_detail 
							set	suffix = @suffix
							where	order_no = @order_no and
								sequence = @sequence
					end
				end
				else				
					-- create part_customer record if customer_additional.auto_profile is set to 'Y'
					-- and part is not configurable
					if isnull ( ( select isnull ( auto_profile, 'N' ) from customer where customer = @customer ), 'N' ) = 'Y' and
					   not exists ( select 1 from part_customer where customer = @customer and part = @part )
					begin
						if ( select isnull(category,'') from customer where customer = @customer ) > ''
							select @price_type = 'C'
						else
							select @price_type = 'B'
							
						insert into part_customer ( part, customer, customer_part, customer_standard_pack, taxable, customer_unit, type, upc_code, blanket_price )
						select @part, @customer, isnull(customer_part,''), std_qty, null, unit, @price_type, null, null from inserted where order_no = @order_no and sequence = @sequence
					end
			end
			else
				update	order_detail
						
				set		--EEIqty=@quantity,
						box_label = @box_label,
						pallet_label = @pallet_label
				where	order_no = @order_no and
						sequence = @sequence

				update	order_detail
						
				set		customer_part = @customerpart
				where	order_no = @order_no and
						sequence = @sequence and
						nullif(customer_part,'') is NULL
						
				update	
					Order_Detail
				set		
					Order_Detail.EEIqty=inserted.quantity
				from		
					inserted
				join		
					Order_Detail on inserted.order_no = Order_Detail.order_no 
					and inserted.sequence = Order_Detail.sequence
				where	
					Order_Detail.order_no  = @order_no and
					Inserted.EEIQty is NULL AND
					@customertype != 'INTERNAL' 
						
			if isnull(@shiptype,'N') = 'N'
				exec msp_calculate_committed_qty @order_no, @part, @suffix
				
			select	@sequence = min(sequence)
			from	inserted
			where	order_no = @order_no and
				sequence > @sequence

		end

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


CREATE trigger [dbo].[mtr_order_detail_u]
on [dbo].[order_detail]
for update
as
---------------------------------------------------------------------------------------
--	This trigger propagates price changes and calls for recalculation of committed
--	quantities for quantity or due date changes.
--
--	Declarations:
--	I.	Loop through all updated records for price changes.
--		A. Calculate standard price.
--	II.	Loop through all normal updated records for quantity or due date changes.
--		A. Calculate committed quantity.
--	III. Loop through all dropship updated records for quantity or due date changes.
--		A. Calculate committed dropship quantity.
---------------------------------------------------------------------------------------

--	Declarations:
declare	@OrderNo numeric(8,0),
	@Sequence numeric(5,0),
	@RowID integer,
	@Part varchar(25),
	@Suffix integer

--	I.	Loop through all updated records for price changes.
declare AltPriceUpdates cursor local for
select	deleted.order_no,
	deleted.sequence
from	deleted
	join order_detail on order_detail.order_no = deleted.order_no and
		order_detail.id = deleted.id and
		coalesce(order_detail.alternate_price, -1) != coalesce(deleted.alternate_price, -1)

open	AltPriceUpdates

fetch	AltPriceUpdates
into	@OrderNo,
	@Sequence

while	@@fetch_status = 0 begin

--		A. Calculate standard price.
		exec msp_calc_order_currency @OrderNo, null, null, @Sequence, null
		
	fetch	AltPriceUpdates
	into	@OrderNo,
		@Sequence
end

close	AltPriceUpdates
deallocate
	AltPriceUpdates

--	II.	Loop through all normal updated records for quantity or due date changes.
declare NormalOrderQtyDateChanges cursor local for
select	deleted.order_no,
	deleted.part_number,
	deleted.suffix
from	deleted
	join order_detail on order_detail.order_no = deleted.order_no and
		order_detail.id = deleted.id and
		(order_detail.quantity != deleted.quantity or
			order_detail.due_date != deleted.due_date)
where	deleted.ship_type = 'N'

open	NormalOrderQtyDateChanges

fetch	NormalOrderQtyDateChanges
into	@OrderNo,
	@Part,
	@Suffix

while	@@fetch_status = 0 begin

--		A. Calculate committed quantity.
	exec msp_calculate_committed_qty @OrderNo, @Part, @Suffix
		
	fetch	NormalOrderQtyDateChanges
	into	@OrderNo,
		@Part,
		@Suffix
end

close	NormalOrderQtyDateChanges
deallocate
	NormalOrderQtyDateChanges

--	III. Loop through all dropship updated records for quantity or due date changes.
declare DropShipOrderQtyDateChanges cursor local for
select	deleted.order_no,
	deleted.row_id
from	deleted
	join order_detail on order_detail.order_no = deleted.order_no and
		order_detail.id = deleted.id and
		(order_detail.quantity != deleted.quantity or
			order_detail.due_date != deleted.due_date)
where	deleted.ship_type = 'D'

open	DropShipOrderQtyDateChanges

fetch	DropShipOrderQtyDateChanges
into	@OrderNo,
	@RowID

while	@@fetch_status = 0 begin
	
--		A. Calculate committed dropship quantity.
	exec msp_calc_committed_dropship @OrderNo, @RowID
		
	fetch	DropShipOrderQtyDateChanges
	into	@OrderNo,
		@RowID
end

close	DropShipOrderQtyDateChanges
deallocate
	DropShipOrderQtyDateChanges

GO
ALTER TABLE [dbo].[order_detail] ADD CONSTRAINT [pk_order_detail] PRIMARY KEY NONCLUSTERED  ([id]) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [ix_order_detail_1] ON [dbo].[order_detail] ([order_no], [due_date], [sequence]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_order_detail_2] ON [dbo].[order_detail] ([order_no], [part_number], [packaging_type], [quantity], [due_date], [type], [id], [destination], [std_qty]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_order_detail_3] ON [dbo].[order_detail] ([part_number], [order_no], [packaging_type], [quantity], [due_date], [type], [id], [destination], [std_qty]) ON [PRIMARY]
GO
CREATE STATISTICS [_dta_stat_1259867555_2_14_43_16_26] ON [dbo].[order_detail] ([destination], [part_number], [due_date], [id], [std_qty], [order_no], [sequence])
GO
CREATE STATISTICS [_dta_stat_1259867555_2_5_14_3_43_16] ON [dbo].[order_detail] ([id], [destination], [order_no], [sequence], [part_number], [quantity], [due_date], [type])
GO
