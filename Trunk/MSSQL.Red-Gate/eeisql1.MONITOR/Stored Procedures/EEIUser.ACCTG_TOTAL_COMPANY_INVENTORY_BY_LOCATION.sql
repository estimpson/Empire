SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [EEIUser].[ACCTG_TOTAL_COMPANY_INVENTORY_BY_LOCATION] 

(@fiscal_year varchar(4), @period char(2), 
@eei_FG_harness_labor numeric(5,3), @eei_FG_harness_burden numeric(5,3), @eei_FG_pcb_labor numeric(5,3), @eei_FG_pcb_burden numeric(5,3),
@eeh_WIP_harness_labor numeric(5,3), @eeh_WIP_harness_burden numeric(5,3), @eeh_WIP_pcb_labor numeric(5,3), @eeh_WIP_pcb_burden numeric(5,3),
@eeh_FG_harness_labor numeric(5,3), @eeh_FG_harness_burden numeric(5,3), @eeh_FG_pcb_labor numeric(5,3), @eeh_FG_pcb_burden numeric(5,3)
)

as

-- EXEC EEIUSER.ACCTG_TOTAL_COMPANY_INVENTORY_BY_LOCATION '2017', '4',   '00.135', '00.143', '00.030', '00.180',    '00.220', '00.034', '00.043', '00.050',    '00.030', '00.035', '00.130', '00.020'

create table #EEI_Result_Set
(		database_name varchar(10),
		type varchar(1),
		product_line varchar(25),
		plant varchar(10),
		location varchar(10),
		serial int,
		part varchar(25),
		quantity numeric(20,6),
		price numeric(20,6),
		ext_price numeric(20,6),
		material_cum numeric(20,6),
		ext_material_cum numeric(20,6),
		labor_cum numeric(20,6),
		ext_labor_cum numeric(20,6),
		burden_cum numeric(20,6),
		ext_burden_cum numeric(20,6),
		user_defined_status varchar(30),
		objectBirthday datetime
)

delete #EEI_Result_Set

insert into #EEI_Result_Set
select	'EEH',
		ph.type,
		ph.product_line,
		oh.plant,
		oh.location,
		oh.serial,
		oh.part,
		oh.quantity,
		psh.price,
		oh.quantity*psh.price as ext_price,
		psh.material_cum,
		oh.quantity*psh.material_cum as ext_material_cum,
		psh.labor_cum,
		(case when ph.product_line = 'PCB' then oh.quantity*psh.material_cum*@eei_FG_pcb_labor else oh.quantity*psh.material_cum*@eei_FG_pcb_labor end) as ext_labor_cum,
		psh.burden_cum,
		(case when ph.product_line = 'PCB' then oh.quantity*psh.material_cum*@eei_FG_pcb_Burden else oh.quantity*psh.material_cum*@eei_FG_pcb_Burden end) as ext_Burden_cum,
		oh.user_defined_status,
		oh.objectBirthday

from historicaldata.dbo.object_historical oh
join historicaldata.dbo.part_historical ph on oh.part = ph.part and oh.reason = ph.reason and oh.time_stamp = ph.time_stamp
join historicaldata.dbo.part_standard_historical psh on oh.part = psh.part and oh.reason = psh.reason and oh.time_stamp = psh.time_stamp
where oh.reason = 'MONTH END'
and oh.part <> 'PALLET'
and oh.user_defined_status not in ('PREOBJECT','PRE-OBJECT','PRESTOCk')
and oh.fiscal_year = '2017'
and oh.period = 4


create table #EEH_Result_Set
(		database_name varchar(10),
		type varchar(1),
		product_line varchar(25),
		plant varchar(10),
		location varchar(10),
		serial int,
		part varchar(25),
		quantity numeric(20,6),
		price numeric(20,6),
		ext_price numeric(20,6),
		material_cum numeric(20,6),
		ext_material_cum numeric(20,6),
		labor_cum numeric(20,6),
		ext_labor_cum numeric(20,6),
		burden_cum numeric(20,6),
		ext_burden_cum numeric(20,6),
		user_defined_status varchar(30),
		objectBirthday datetime
)

-- 5. Get Data from EEH database

delete #EEH_Result_Set

insert into #EEH_Result_Set
select	'EEH',
		ph.type,
		ph.product_line,
		oh.plant,
		oh.location,
		oh.serial,
		oh.part,
		oh.quantity,
		psh.price,
		oh.quantity*psh.price as ext_price,
		psh.material_cum,
		oh.quantity*psh.material_cum as ext_material_cum,
		psh.labor_cum,
		(case when ph.type = 'WIP' then (case when ph.product_line = 'PCB' then oh.quantity*psh.material_cum*@eeh_WIP_pcb_labor else oh.quantity*psh.material_cum*@eeh_WIP_harness_labor end) else (case when ph.product_line = 'PCB'   then oh.quantity*psh.material_cum*@eeh_FG_pcb_labor else oh.quantity*psh.material_cum*@eeh_FG_harness_labor end)end) as ext_labor_cum,
		psh.burden_cum,
		(case when ph.type = 'WIP' then (case when ph.product_line = 'PCB' then oh.quantity*psh.material_cum*@eeh_WIP_pcb_burden else oh.quantity*psh.material_cum*@eeh_WIP_harness_burden end) else (case when ph.product_line = 'PCB' then oh.quantity*psh.material_cum*@eeh_FG_pcb_burden else oh.quantity*psh.material_cum*@eeh_FG_harness_burden end)end) as ext_burden_cum,
		oh.user_defined_status,
		oh.objectBirthDate

from eehsql1.historicaldata.dbo.object_historical oh
join eehsql1.historicaldata.dbo.part_historical ph on oh.part = ph.part and oh.reason = ph.reason and oh.time_stamp = ph.time_stamp
join eehsql1.historicaldata.dbo.part_standard_historical psh on oh.part = psh.part and oh.reason = psh.reason and oh.time_stamp = psh.time_stamp
where oh.reason = 'MONTH END'
and oh.part <> 'PALLET'
and oh.user_defined_status not in ('PREOBJECT','PRE-OBJECT','PRESTOCk')
and oh.fiscal_year = @fiscal_year
and oh.period = @period




















--declare	@Syntax nvarchar (4000)
--set	@Syntax = N'delete	#EEH_Result_Set

--				insert	#EEH_Result_Set
--				select	*
--				from	OpenQuery ( [EEHSQL1], ''
--												select	''''EEH'''',
--														ph.type,
--														ph.product_line,
--														oh.plant,
--														oh.location,
--														oh.serial,
--														oh.part,
--														oh.quantity,
--														psh.price,
--														oh.quantity*psh.price as ext_price,
--														psh.material_cum,
--														oh.quantity*psh.material_cum as ext_material_cum,
--														psh.labor_cum,
--														0,--(case when ph.type = ''''WIP'''' then (case when ph.product_line = ''''PCB'''' then oh.quantity*psh.material_cum*' + cast(@eeh_WIP_pcb_labor as numeric(10,6)) + ' else oh.quantity*psh.material_cum*' + cast(@eeh_WIP_harness_labor as numeric(10,6)) + ' end) else (case when ph.product_line = ''''PCB''''   then oh.quantity*psh.material_cum*' + cast(@eeh_FG_pcb_labor as numeric(10,6)) + ' else oh.quantity*psh.material_cum*'+ cast(@eeh_FG_harness_labor as numeric(10,6)) + ' end)end) as ext_labor_cum,
--														psh.burden_cum,
--														0,--(case when ph.type = ''''WIP'''' then (case when ph.product_line = ''''PCB'''' then oh.quantity*psh.material_cum*' + cast(@eeh_WIP_pcb_burden as numeric(10,6)) + ' else oh.quantity*psh.material_cum*' + cast(@eeh_WIP_harness_burden as numeric(10,6)) + ' end) else (case when ph.product_line = ''''PCB'''' then oh.quantity*psh.material_cum*' + cast(@eeh_FG_pcb_burden as numeric(10,6)) + ' else oh.quantity*psh.material_cum*'+ cast(@eeh_FG_harness_burden as numeric(10,6)) + ' end)end) as ext_burden_cum,
--														oh.user_defined_status,
--														oh.objectBirthDate
													

--												from historicaldata.dbo.object_historical oh
--												join historicaldata.dbo.part_historical ph on oh.part = ph.part and oh.reason = ph.reason and oh.time_stamp = ph.time_stamp
--												join historicaldata.dbo.part_standard_historical psh on oh.part = psh.part and oh.reason = psh.reason and oh.time_stamp = psh.time_stamp
--												where oh.reason = ''''MONTH END''''
--												and oh.part <> ''''PALLET''''
--												and oh.user_defined_status not in (''''PREOBJECT'''',''''PRE-OBJECT'''',''''PRESTOCK'''')
--												and oh.fiscal_year = ''''' + @fiscal_year + '''''
--												and oh.period = ' + convert(char, @period) + '

--									''
--						)'

--execute	sp_executesql
--	@Syntax


		
select * from #EEI_Result_Set a
union
select * from #EEH_Result_Set b
GO
