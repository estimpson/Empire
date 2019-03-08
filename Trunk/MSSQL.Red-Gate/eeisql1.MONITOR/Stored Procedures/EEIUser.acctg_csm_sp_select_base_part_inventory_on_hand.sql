SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [EEIUser].[acctg_csm_sp_select_base_part_inventory_on_hand] (@base_part varchar(25))
as

-- exec eeiuser.acctg_csm_sp_select_base_part_inventory_on_hand 'VAL0386'


select o.part, o.plant, o.location, l.secured_location, sum(o.quantity) as quantity, sum(o.quantity*ps.material_cum) as trf_value 
from object o
join part_standard ps on o.part = ps.part
join location l on o.location = l.code
where o.part like @base_part+'%'
group by o.part, o.plant, o.location, l.secured_location


GO
