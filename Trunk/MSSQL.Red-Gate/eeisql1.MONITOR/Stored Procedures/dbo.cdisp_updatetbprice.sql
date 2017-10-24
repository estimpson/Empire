SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [dbo].[cdisp_updatetbprice]
as
declare	@cnt integer,
	@part varchar(25),
	@customer varchar(10),
	@price decimal(20,6)

--	Count if any enteries are there for today.
select	@cnt = count (1)
from	part_customer_tbp
where	--convert ( varchar(10), effect_date, 111 ) <= convert ( varchar(10), getdate (), 111)
	effect_date < dbo.fn_Tomorrow ()

if isnull ( @cnt, 0 ) > 0 begin
	--	Declare a cursor for the records from tbp table.
	declare	tbpcursor cursor local for
	select	tbp.part,
		tbp.customer,
		tbp.price
	from	part_customer_tbp as tbp
		join part_eecustom as p on p.part = tbp.part
	where	--convert ( varchar(10), tbp.effect_date, 111 ) <= convert ( varchar(10), getdate (), 111 ) and
		tbp.effect_date < dbo.fn_Tomorrow () and
		tbp.effect_date =
		(	select	max ( tbp2.effect_date )
			from	part_customer_tbp as tbp2
			where	tbp2.part = tbp.part and
				tbp2.customer = tbp2.customer and
				--convert ( varchar(10), tbp2.effect_date, 111 ) <= convert ( varchar(10), getdate (), 111 ) ) and
				tbp2.effect_date < dbo.fn_Tomorrow () ) and
		isnull ( p.tb_pricing, '0' ) = '1'
	
	--	Open cursor.
	open	tbpcursor
	
	--	fetch data.
	fetch	tbpcursor
	into	@part,
		@customer,
		@price
	
	while @@fetch_status = 0 begin
		--	update	sales order header.
		update	order_header
		set	alternate_price = @price
		where	customer = @customer and
			blanket_part = @part and
			isnull ( status, 'O' ) in ('A','O')
			and customer_po not like '%SAMPLE%' --and customer_po not like '%TBD%'
		
		--	update	sales order detail.
		update	order_detail
		set	order_detail.alternate_price = @price
		from	order_detail as od
			join order_header as oh on oh.order_no = od.order_no
		where	od.part_number = @part and
			oh.customer = @customer and
			isnull ( oh.status, 'O' ) in ('A','O')
			and customer_po not like '%SAMPLE%' --and customer_po not like '%TBD%' 
			-- (2013-06-17) We removed the constraint for 'TBD' because when the PO is updated then the price will be updated anyway; we were trying to prevent price updates on ECNs that needed to be validated because we didn't have a PO yet (confirmation of price)
		
		--	update	part standard.
		update	part_standard
		set	price = @price
		where	part = @part
		
		--	update	part customer.
		update	part_customer
		set	blanket_price = @price
		where	part = @part and
			customer = @customer
		
		--	update	part customer_price_matrix.
		update	part_customer_price_matrix
		set	alternate_price = @price
		where	part = @part and
			customer = @customer and
			qty_break = 1
		
		--	fetch data.
		fetch	tbpcursor
		into	@part,
			@customer,
			@price
	end
	
	--	Close cursor.
	close	tbpcursor
	deallocate
		tbpcursor
end



GO
