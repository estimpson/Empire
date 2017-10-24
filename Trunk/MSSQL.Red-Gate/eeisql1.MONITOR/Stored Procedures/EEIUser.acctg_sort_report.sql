SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[acctg_sort_report] (@from_date datetime, @through_date datetime)
as 

declare @Results table
( groupno int, serial int, part varchar(25), location varchar(10), user_defined_status varchar(25), note varchar(200), status char(1), quantity numeric(20,6), cum_quantity numeric(20,6))

declare @groupno int
set @groupno = 0

declare @laststatus char(1)
set	@laststatus = 'X'

declare @serial int, @part varchar(25), @location varchar(10), @user_defined_status varchar(25), @note varchar(200), @status char(1), @quantity numeric(20,6), @cum_quantity numeric(20,6)

DECLARE GROUP_SORT CURSOR local
for
select	serial, 
		part, 
		location,
		user_defined_status,
		note, 
		status,
		quantity,
		(select sum(quantity)from object o where o.serial <= object.serial and o.part = object.part) as cum_quantity
from	object where part in (
		
					select	part_number 
					from	order_detail 
					where	due_date >= @from_date 
						and due_date <= @through_date 
						and part_number in (	
												
												select	part 
												from	object 
												where	status = 'H'
											)
							)
order by part, serial

open GROUP_SORT

while	1=1 begin

	fetch	GROUP_SORT
	into	@serial, @part, @location, @user_defined_status, @note, @status, @quantity, @cum_quantity
	
	if	@@fetch_status != 0 begin
		break
	end
	
	if @laststatus != @status begin
		set @groupno = @groupno + 1
		set @laststatus = @status
	end
	
	insert
		@Results
	values
	(	@groupno, @serial, @part, @location, @user_defined_status, @note, @status, @quantity, @cum_quantity)
end

close GROUP_SORT
deallocate
	GROUP_SORT

select
	groupno, serial, a.part, location, user_defined_status, note, status, quantity, cum_quantity,
	(select sum(order_detail.quantity) from order_detail where a.part = order_detail.part_number and order_detail.due_date >= '2011-01-21' and order_detail.due_date <= '2011-01-24') as required_qty
from
	@Results a
	join part_inventory on a.part = part_inventory.part
where (select sum(order_detail.quantity)+part_inventory.standard_pack-.5 from order_detail where a.part = order_detail.part_number and order_detail.due_date >= '2011-01-21' and order_detail.due_date <= '2011-01-24') >= cum_quantity
	
	order by groupno, a.part, serial

	
GO
