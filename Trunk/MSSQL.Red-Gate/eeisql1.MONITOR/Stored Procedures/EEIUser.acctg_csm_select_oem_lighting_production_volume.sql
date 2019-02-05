SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [EEIUser].[acctg_csm_select_oem_lighting_production_volume] (@oem varchar(100))
as

-- Created by DW 2019-02-03
-- This procedure is used to return the values for the OEMProduction grid on the evision/empireweb/oem.aspx webpage


-- exec eeiuser.acctg_csm_select_oem_lighting_production_volume @oem = 'Ford'


select	 b.[VP: Manufacturer Group] 
		,b.[Headlamp Supplier]
	    ,b.[VP: Production Nameplate]
		,d.base_part
		,convert(decimal(18,2),avg( d.[Empire_volume_2019] )) as Empire_Volume_2019
		,sum( b.[Vehicle Volume 2019] ) as Vehicle_Volume_2019
		,(select sum(c.[vehicle volume 2019]) from eeiuser.acctg_csm_forward_lighting c where c.[VP: Manufacturer Group] = b.[VP: Manufacturer Group] group by c.[VP: Manufacturer Group]) as oem_sort_index
		,(select sum(a.[vehicle volume 2019]) from eeiuser.acctg_csm_forward_lighting a where a.[VP: Manufacturer Group] = b.[VP: Manufacturer Group] and a.[Headlamp Supplier] = b.[Headlamp Supplier] Group by a.[Headlamp Supplier]) as supplier_sort_index

from eeiuser.acctg_csm_forward_lighting b

left join (select manufacturer, vehicle, base_part, round((sum(cal_19_Totaldemand))/2,0) as [empire_volume_2019]  from eeiuser.acctg_csm_vw_select_sales_forecast where empire_market_subsegment='Head Lamp' and vehicle is not null  group by manufacturer, vehicle, base_part having (sum(cal_19_Totaldemand))/2 > 0 ) d

on b.[VP: Manufacturer Group] = d.manufacturer and b.[VP: Production Brand]+' '+[VP: Production Nameplate] = d.vehicle

where	b.[VP: Manufacturer Group] = @OEM
		and b.[Vehicle Volume 2019]>0 
		and base_part is not null
group by b.[VP: Manufacturer Group], 
		b.[Headlamp Supplier],
		b.[VP: Production Nameplate],
		d.[base_part]

union
select b.manufacturer, b.headlamp_supplier, b.nameplate, 'Unknown', 
convert(decimal(18,2),(case when isnull(vehicle_volume_2019,0) < isnull(empire_volume_2019,0) then 0 else isnull(vehicle_volume_2019,0)-isnull(empire_volume_2019,0) end)) as unknown_volume,
b.vehicle_volume_2019,
b.oem_sort_index,
b.supplier_sort_index
from 
(select manufacturer, vehicle,  round((sum(cal_19_Totaldemand))/2,0) as [empire_volume_2019]  from eeiuser.acctg_csm_vw_select_sales_forecast 
where empire_market_subsegment='Head Lamp' --and vehicle = 'Chevrolet Silverado'  
group by manufacturer, vehicle having (sum(cal_19_Totaldemand))/2 > 0 
) a
full outer join
(select	 b.[VP: Manufacturer Group] as manufacturer
		,b.[Headlamp Supplier] as headlamp_supplier
		,b.[VP: Production Nameplate] as nameplate
	    ,b.[VP: Production Brand]+' '+b.[VP: Production Nameplate] as vehicle
		,sum( b.[Vehicle Volume 2019] ) as Vehicle_Volume_2019
		,(select sum(c.[vehicle volume 2019]) from eeiuser.acctg_csm_forward_lighting c where c.[VP: Manufacturer Group] = b.[VP: Manufacturer Group] group by c.[VP: Manufacturer Group]) as oem_sort_index
		,(select sum(a.[vehicle volume 2019]) from eeiuser.acctg_csm_forward_lighting a where a.[VP: Manufacturer Group] = b.[VP: Manufacturer Group] and a.[Headlamp Supplier] = b.[Headlamp Supplier] Group by a.[Headlamp Supplier]) as supplier_sort_index
from eeiuser.acctg_csm_forward_lighting b
--where [VP: Production Nameplate] = 'Silverado'
group by b.[VP: Manufacturer Group], 
		b.[Headlamp Supplier],
		b.[VP: Production Nameplate],
		b.[VP: Production Brand]+' '+b.[VP: Production Nameplate]
) b
on a.manufacturer = b.manufacturer and a.vehicle = b.vehicle
where	b.manufacturer = @OEM 
	and (case when isnull(vehicle_volume_2019,0) < isnull(empire_volume_2019,0) then 0 else isnull(vehicle_volume_2019,0)-isnull(empire_volume_2019,0) end) > 0


order by 7 desc ,  8 desc, 6 desc, 5 desc

GO
