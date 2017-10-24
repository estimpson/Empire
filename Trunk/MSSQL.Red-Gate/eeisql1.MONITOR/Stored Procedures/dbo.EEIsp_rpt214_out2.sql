SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[EEIsp_rpt214_out2] (	@fromdate datetime, @throughdate datetime )
as
Begin
	
	Select max(serial) serial, custom4
		into	#214_in
		from audit_trail
		where type = 'Z'
		group by custom4
	
	create table	#214_out(
				QtyOut numeric(20,6),
				CostOut	numeric(20,6),
				SalesOut	numeric(20,6),
				custom4 varchar(50))
	Insert		#214_out
	Select		Sum(quantity) QtyOut,
				Sum(quantity*material_cum) CostOut,
				Sum(quantity*part_standard.price) SalesOut, 
				custom4
	from		audit_trail
		join		part_standard on audit_trail.part = part_standard.part
		where	type in ( 'S', 'D', 'V') and status <> 'S'  and
				date_stamp >= @fromdate and
		date_stamp<dateadd(dd, -1, @throughdate) 
--and				serial not in (select serial from audit_trail where part like 'ALC%' and from_loc = 'ELPASO' and type = 'S')
				
		group by custom4
		UNION
	
	Select		Sum(quantity) ScrapQtyOut, 
				Sum(quantity*material_cum) ScrapCostOut,
				Sum(quantity*part_standard.price) ScrapSalesOut, 
				custom4
	from		audit_trail
	join		part_standard on audit_trail.part = part_standard.part
	Where	type = 'Q' and
			status = 'S' and
			date_stamp >= @fromdate and
			date_stamp<dateadd(dd, -1, @throughdate)
		group by custom4
--		UNION
--
--Select			Sum(quantity) TransferQtyOut, 
--				Sum(quantity*material_cum)TransferCostOut,
--				Sum(quantity*part_standard.price) TransferSalesOut, 
--				custom4
--	from			audit_trail
--	join		part_standard on audit_trail.part = part_standard.part
--	Where	type = 'T' and
--			to_loc = 'ELPASO' and
--			audit_trail.part like 'ALC%' and
--			date_stamp >= @fromdate and
--			date_stamp<dateadd(dd, -1, @throughdate)
--		group by custom4


	
				
	Select 			Sum(qtyOut) QtyOut,
					Sum(CostOut) CostOut,
					Sum(salesOut) SalesOut,
					#214_out.custom4
	from				#214_out
	join				#214_in on #214_out.custom4 = #214_in.custom4
	group by			#214_out.custom4
	order by 4 ASC
								
		


End
GO
