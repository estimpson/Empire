SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--exec eeiuser.acctg_csm_flatten_programs


CREATE procedure [EEIUser].[acctg_csm_flatten_programs_original]
as
create table #a
	(	
	base_part varchar(25),
	oem varchar(1000),
	program varchar(1000),
	vehicle varchar(1000)
	)

declare Demand cursor local for
select		distinct(base_part) as base_part, 
			b.sales_parent as oem, 
			b.program as program, 
			b.badge+' '+b.nameplate as vehicle 
from		eeiuser.acctg_csm_base_part_mnemonic a 
			left join eeiuser.acctg_csm_nacsm b on a.mnemonic = b.mnemonic 
where		b.release_id = '2008-08'	
			and b.program <> '' 
			and a.take_rate*a.family_allocation*a.qty_per <> 0 
order by	base_part

open Demand

declare		@base_part varchar(25),
			@oem varchar(255),
			@program varchar(255),
			@vehicle varchar(255)

fetch		Demand
into		@base_part,
			@oem,
			@program,
			@vehicle

insert into #a
select @base_part, @oem, @program, @vehicle



while		@@fetch_status = 0 begin

		update	#a 
		set		#a.oem = (case when @oem = #a.oem then #a.oem else #a.oem+', '+@oem end),
				#a.program = (case when @program = #a.program then #a.program else #a.program+', '+@program end),
				#a.vehicle = (case when @vehicle = #a.vehicle then #a.vehicle else #a.vehicle+', '+@vehicle end)

		fetch	Demand
		into	@base_part,
				@oem,
				@program,
				@vehicle

end

select * from #a
GO
