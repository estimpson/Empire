SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- exec eeiuser.acctg_inv_rm_doh_by_part

CREATE procedure [eeiuser].[acctg_inv_rm_doh_by_part]
as

----------------------------------------------------------------
create table #vendor_subtotal 
(	asofdate datetime,
	default_vendor varchar(50),
	quantity decimal(18,6),
	ext_material_cum decimal(18,6)
)

insert into #vendor_subtotal
select		asofdate,
			default_vendor,
			sum(quantity),
			sum(ext_material_cum) 
from		eeiuser.acctg_inv_age_review
group by	asofdate,
			default_vendor
			
--select * from #vendor_subtotal order by 1,2
-----------------------------------------------------------------
create table #part_total
(	default_vendor varchar(50),
	asofdate datetime,
	part varchar(50),
	quantity decimal(18,6),
	ext_material_cum decimal(18,6),
	days_on_hand decimal(18,6),
	part_weight decimal(18,6),
	part_value decimal(18,6)
)

insert into #part_total
	select	ar1.default_vendor, 
			ar1.asofdate,
			ar1.part,
			sum(ar1.quantity) as quantity,
			sum(ar1.ext_material_cum) as ext_amount,
			(case when (sum(ar1.weeks_to_exhaust)*7)>1825 then 1825 else sum(ar1.weeks_to_exhaust)*7 end) as days_on_hand,
		 	
		 	(case when (
		 			 	Select SUM(vst.ext_material_cum) from #vendor_subtotal vst where ar1.default_vendor = vst.default_vendor and ar1.asofdate = vst.asofdate
		 			 	) = 0 
		 			then 0 
		 			else (
		 			 	sum(ar1.ext_material_cum)/(select sum(vst.ext_material_cum) from #vendor_subtotal vst where ar1.default_vendor = vst.default_vendor and ar1.asofdate = vst.asofdate)
		 			 	)
		 			end
		 	) as part_weight,
		 	
			((case when (sum(ar1.weeks_to_exhaust)*7)>1825 then 1825 else sum(ar1.weeks_to_exhaust)*7 end)
			*
		 	(case when (
		 			 	Select SUM(vst.ext_material_cum) from #vendor_subtotal vst where ar1.default_vendor = vst.default_vendor and ar1.asofdate = vst.asofdate
		 			 	) = 0 
		 			then 0 
		 			else (
		 			 	sum(ar1.ext_material_cum)/(select sum(vst.ext_material_cum) from #vendor_subtotal vst where ar1.default_vendor = vst.default_vendor and ar1.asofdate = vst.asofdate)
		 			 	)
		 			end
			)) as part_value
			
from		eeiuser.acctg_inv_age_review ar1
group by	ar1.asofdate, 
			ar1.default_vendor,
			ar1.part

select (case when days_on_hand < 730 then 'ACTIVE' else 'OBSOLETE' end) as status, * from #part_total order by 1,2,3
---------------------------------------------------------------------------------------------------------------------
--create table #vendor_total
--(	default_vendor varchar(50),
--	asofdate datetime,
--	quantity decimal(18,6),
--	ext_material_cum decimal(18,6),
--	days_on_hand decimal(18,6),
--	vendor_weight decimal(18,6),
--	vendor_value decimal(18,6)
--)

--insert into #vendor_total
--	select	pt.default_vendor, 
--			pt.asofdate,
--			sum(pt.quantity) as quantity,
--			sum(pt.ext_material_cum) as ext_amount,
--			sum(pt.part_value) as days_on_hand,
		 	
--		 	(case when (
--		 			 	Select SUM(pt1.ext_material_cum) from #part_total pt1 where pt1.asofdate = pt.asofdate
--		 			 	) = 0 
--		 			then 0
--		 			else (
--		 			 	sum(pt.ext_material_cum)/(select sum(pt1.ext_material_cum) from #part_total pt1 where pt.asofdate = pt1.asofdate)
--		 			 	)
--		 			end
--		 	) as vendor_weight,
		 	
--			(SUM(pt.part_value)
--			*
--		 	(case when (
--		 			 	Select SUM(pt1.ext_material_cum) from #part_total pt1 where pt1.asofdate = pt.asofdate
--		 			 	) = 0 
--		 			then 0
--		 			else (
--		 			 	sum(pt.ext_material_cum)/(select sum(pt1.ext_material_cum) from #part_total pt1 where pt.asofdate = pt1.asofdate)
--		 			 	)
--		 			end		
--			)) as vendor_value
			
--from		#part_total pt
--group by	pt.asofdate, 
--			pt.default_vendor
			

--select * from #vendor_total order by 2,1
----------------------------------------------------------------------------------------------------------------------------------------------------------
--select		vt.asofdate,
--			sum(vt.quantity) as quantity,
--			SUM(vt.ext_material_cum) as ext_material_cum,
--			SUM(vt.vendor_value) as weighted_average_days_on_hand
--from		#vendor_total vt
--group by	vt.asofdate
--order by	1
-----------------------------------------------------------------------------------------------------------------------------------------------------------



drop table #vendor_subtotal
drop table #part_total
--drop table #vendor_total





GO
