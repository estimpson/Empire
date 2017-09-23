SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE	procedure	[dbo].[eeisp_flatten_csm]

as
begin

truncate table	dbo.work_csm_program
insert	dbo.work_csm_program

 (base_part, oem, program, vehicle)
select  distinct(base_part) as base_part, 
   b.sales_parent as oem, 
   b.program as program, 
   b.badge+' '+b.nameplate as vehicle 
from  eeiuser.acctg_csm_base_part_mnemonic a 
   left join eeiuser.acctg_csm_nacsm b on a.mnemonic = b.mnemonic 
where  b.release_id = (Select max(release_id) from eeiuser.acctg_csm_NACSM) 
   and b.program <> '' 
   and a.take_rate*a.family_allocation*a.qty_per <> 0 
order by base_part


declare	@oemlist varchar(1000),
		@basepart varchar(25),
		@program varchar(1000),
		@vehicle varchar(1000)

declare @FlatCSM table (
		
	basepart	varchar(25),
	oem		varchar(1000),
	program	varchar(1000),
	vehicle	varchar(1000))

declare	partlist cursor local for
select distinct base_part from dbo.work_csm_program
open		partlist 
fetch	partlist into	@basepart

While		 @@fetch_status = 0
Begin	
Select	@oemlist  = ''
Select	@program = ''
Select	@vehicle = ''

Select	@oemlist = @oemlist + oem+', '
from		dbo.work_csm_program where base_part = @basepart
group by	oem

Select	@program = @program + program +', '
from		dbo.work_csm_program where base_part = @basepart
group by	program

Select	@vehicle= @vehicle + vehicle+', '
from		dbo.work_csm_program where base_part = @basepart
group by	vehicle

insert	@FlatCSM
Select	@basepart,
		@oemlist,
		@program,
		@vehicle
		

fetch	partlist into	@basepart

end
truncate table FlatCSM
insert	FlatCSM 
Select	basepart,
		left(oem,datalength(oem)-2) oem,
		left(program,datalength(program)-2) program,
		left(vehicle,datalength(vehicle)-2) vehicle
	
from		@FlatCSM

--Select * from FlatCSM

end

GO
