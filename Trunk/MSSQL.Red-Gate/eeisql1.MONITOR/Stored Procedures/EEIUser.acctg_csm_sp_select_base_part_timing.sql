SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [EEIUser].[acctg_csm_sp_select_base_part_timing] (@base_part varchar(30), @release_id char(7)) 
as 

--For Testing:

-- exec eeiuser.acctg_csm_sp_select_base_part_timing @base_part = 'TRW1152', @release_id = '2018-10' 


--declare @base_part varchar(20)
--declare @release_id varchar(8)
--select @base_part = 'TRW1152' 
--select @release_id = '2018-10'

select	a.assembly_plant, 
		a.program, 
		a.badge as brand, 
		a.vehicle, 
		a.csm_sop, 
		a.csm_eop,
		b.changedate,
		b.changetype,
		b.exterior,
		b.interior,
		b.engine,
		b.transmission,
		b.Chassis,
		b.Suspension,
		b.Location
from eeiuser.acctg_csm_vw_select_sales_forecast a 
join eeiuser.acctg_csm_mid_model b 
 on a.program = b.program and a.vehicle = b.brand+' '+b.productionnameplate
where	base_part = @base_part 
	and release_id = @release_id
	and b.changetype <> 'EN - End' 
	and b.changedate <> b.sop



GO
