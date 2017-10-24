SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- To fix any invoices have been posted to the wrong ledger_account
CREATE procedure [EEIUser].[acctg_fix_sales_account_codes_on_shippers]

as

declare @beg_date datetime
declare @end_date datetime

select @beg_date = dateadd(d,-1,getdate())
select @end_date = getdate()


declare @results table (id int, date_shipped datetime, customer varchar(50), part_original varchar(50),qty_packed decimal(18,6),price decimal(18,6), account_code varchar(10), product_line varchar(50), correct_account_code varchar(10))
insert into @results
select	id, 
		s.date_shipped, 
		customer, 
		part_original, 
		qty_packed, 
		price, 
		account_code, 
		product_line,
		'4030' as correct_account_code
from	shipper s 
		join shipper_detail sd on s.id = sd.shipper 
		join part p on sd.part_original = p.part 
where	s.date_shipped >= @beg_date
	and s.date_shipped < @end_date
	and p.type = 'F'
	and p.product_line = 'WIRE HARN - EEH' 
	and account_code <> '4030' 
	and s.type <> 'R'
	and s.posted <> 'Y'
union
select	id, 
		s.date_shipped, 
		customer, 
		part_original, 
		qty_packed, 
		price, 
		account_code, 
		product_line,
		'4031' as correct_account_code
from	shipper s 
		join shipper_detail sd on s.id = sd.shipper 
		join part p on sd.part_original = p.part 
where	s.date_shipped >= @beg_date
	and s.date_shipped < @end_date
	and p.type = 'F'
	and p.product_line = 'WIRE HARN - EEH' 
	and account_code <> '4031' 
	and s.type = 'R'
	and s.posted <> 'Y'
	union
select	id, 
		s.date_shipped, 
		customer, 
		part_original, 
		qty_packed, 
		price, 
		account_code, 
		product_line,
		'4040' as correct_account_code 
from	shipper s 
		join shipper_detail sd on s.id = sd.shipper 
		join part p on sd.part_original = p.part 
where	s.date_shipped >= @beg_date
	and s.date_shipped < @end_date
	and p.type = 'F'
	and p.product_line = 'WIRE HARN - EEI' 
	and account_code <> '4040' 
	and s.type <> 'R'
		and s.posted <> 'Y'
		union
select	id, 
		s.date_shipped, 
		customer, 
		part_original, 
		qty_packed, 
		price, 
		account_code, 
		product_line,
		'4041' as correct_account_code 
from	shipper s 
		join shipper_detail sd on s.id = sd.shipper 
		join part p on sd.part_original = p.part 
where	s.date_shipped >= @beg_date
	and s.date_shipped < @end_date
	and p.type = 'F'
	and p.product_line = 'WIRE HARN - EEI' 
	and account_code <> '4041' 
	and s.type = 'R'
	
		and s.posted <> 'Y'union
select	id, 
		s.date_shipped, 
		customer, 
		part_original, 
		qty_packed, 
		price, 
		account_code, 
		product_line,
		'4050' as correct_account_code
from	shipper s 
		join shipper_detail sd on s.id = sd.shipper 
		join part p on sd.part_original = p.part 
where	s.date_shipped >= @beg_date
	and s.date_shipped < @end_date
	and p.type = 'F'
	and p.product_line = 'ES3 COMPONENTS' 
	and account_code <> '4050' 
	and s.type <> 'R'
		and s.posted <> 'Y'
		union
select	id, 
		s.date_shipped, 
		customer, 
		part_original, 
		qty_packed, 
		price, 
		account_code, 
		product_line,
		'4051' as correct_account_code
from	shipper s 
		join shipper_detail sd on s.id = sd.shipper 
		join part p on sd.part_original = p.part 
where	s.date_shipped >= @beg_date
	and s.date_shipped < @end_date
	and p.type = 'F'
	and p.product_line = 'ES3 COMPONENTS' 
	and account_code <> '4051' 
	and s.type = 'R'
	
		and s.posted <> 'Y'
		union
select	id, 
		s.date_shipped, 
		customer, 
		part_original, 
		qty_packed, 
		price, 
		account_code, 
		product_line,
		'4060' as correct_account_code
from	shipper s 
		join shipper_detail sd on s.id = sd.shipper 
		join part p on sd.part_original = p.part 
where	s.date_shipped >= @beg_date
	and s.date_shipped < @end_date
	and p.product_line = 'BULBED ES3 COMPONENTS' 
	and p.type = 'F'
	and account_code <> '4060' 
	and s.type <> 'R'
			and s.posted <> 'Y'
			union
select	id, 
		s.date_shipped, 
		customer, 
		part_original, 
		qty_packed, 
		price, 
		account_code, 
		product_line,
		'4061' as correct_account_code
from	shipper s 
		join shipper_detail sd on s.id = sd.shipper 
		join part p on sd.part_original = p.part 
where	s.date_shipped >= @beg_date
	and s.date_shipped < @end_date
	and p.product_line = 'BULBED ES3 COMPONENTS' 
	and p.type = 'F'
	and account_code <> '4061' 
	and s.type = 'R'
		and s.posted <> 'Y'
		union
select	id, 
		s.date_shipped, 
		customer, 
		part_original, 
		qty_packed, 
		price, 
		account_code, 
		product_line,
		'4070' as correct_account_code
from	shipper s 
		join shipper_detail sd on s.id = sd.shipper 
		join part p on sd.part_original = p.part 
where	s.date_shipped >= @beg_date
	and s.date_shipped < @end_date
	and p.product_line = 'OUTSOURCED ES3 COMPONENTS' 
	and p.type = 'F'
	and account_code <> '4070' 
	and s.type <> 'R'
		and s.posted <> 'Y'
		union
select	id, 
		s.date_shipped, 
		customer, 
		part_original, 
		qty_packed, 
		price, 
		account_code, 
		product_line,
		'4071' as correct_account_code 
from	shipper s 
		join shipper_detail sd on s.id = sd.shipper 
		join part p on sd.part_original = p.part 
where	s.date_shipped >= @beg_date
	and s.date_shipped < @end_date
	and p.product_line = 'OUTSOURCED ES3 COMPONENTS' 
	and p.type = 'F'
	and account_code <> '4071' 
	and s.type = 'R'
		and s.posted <> 'Y'
		union
select	id, 
		s.date_shipped, 
		customer, 
		part_original, 
		qty_packed, 
		price, 
		account_code, 
		product_line,
		'4080' as correct_account_code
from	shipper s 
		join shipper_detail sd on s.id = sd.shipper 
		join part p on sd.part_original = p.part 
where	s.date_shipped >= @beg_date
	and s.date_shipped < @end_date
	and p.product_line = 'PCB'
	and p.type = 'F' 
	and account_code <> '4080' 
	and s.type <> 'R'
		and s.posted <> 'Y'
		union
select	id, 
		s.date_shipped, 
		customer, 
		part_original, 
		qty_packed, 
		price, 
		account_code, 
		product_line,
		'4081' as correct_account_code
from	shipper s 
		join shipper_detail sd on s.id = sd.shipper 
		join part p on sd.part_original = p.part 
where	s.date_shipped >= @beg_date
	and s.date_shipped < @end_date
	and p.product_line = 'PCB'
	and p.type = 'F' 
	and account_code <> '4081' 
	and s.type = 'R'	
	and s.posted <> 'Y'
order by 8,7,4


update sd set account_code = r.correct_account_code from shipper_detail sd join @results r on sd.shipper = r.id and sd.part_original = r.part_original
update s set posted = 'N' from shipper s join @results r on s.id = r.id 


GO
