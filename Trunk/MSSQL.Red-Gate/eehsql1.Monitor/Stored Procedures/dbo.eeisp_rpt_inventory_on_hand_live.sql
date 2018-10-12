SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- exec eeisp_rpt_inventory_on_hand_live 'F'

CREATE procedure [dbo].[eeisp_rpt_inventory_on_hand_live] (@PartType char(1))

as

-- TEST VARIABLES
/*
declare @fiscalyear int;
declare @period int;
declare @reason varchar(15);
declare @parttype char(1);
declare @time_stamp datetime;
select @fiscalyear = '2014'
select @period = '11'
select @reason = 'MONTH END'
select @parttype = 'F'
select @time_stamp = '2014-11-30'
*/


--	1) Pull the data into table variables for further use in this sp

declare @eei_part_standard table (part varchar(25), production_price decimal(18,6));
insert into @eei_part_standard
select	part
	   ,price 
from	[EEISQL1].monitor.dbo.part_standard


-- select * from @eei_part_standard

--	2) Pull the data into table variables for further use in this sp

declare @eeh_inv_age_review table (part varchar(25), receivedfiscalyear varchar(4), receivedperiod int, action_item int, excess decimal(18,6));
insert into @eeh_inv_age_review
select		part
		,	receivedfiscalyear
		,	receivedperiod
		,	ISNULL(at_risk,0) as action_item
		,	NEt_RM_104_WK/quantity as excess
from		eeiuser.acctg_inv_age_review 
where		asofdate = (select max(asofdate) from eeiuser.acctg_inv_age_review) 

-- select * from @eeh_inv_age_review


-- 5) Select report data

SELECT	ohd.serial
		,ohd.part
		,eeh_po.Default_vendor		
		,phd.type		
		,phd.product_line		
		,ohd.plant		
		,ohd.location
		,ohd.status
		,ohd.objectbirthdate as object_received_date
		,datediff(d,ohd.objectbirthdate,getdate()) as age
		,ohd.std_quantity
		,eei_psh.production_price as customer_selling_price		
		,pshd.price		
		,pshd.material_cum
		,pshd.labor_cum		
		,pshd.burden_cum
		,pshd.cost_cum
		,(case when InvAge.action_item = 1 then pshd.material_cum*ohd.std_quantity else 0 end) as inv_age_allowance
		,(case when InvAge.action_item = 0 then InvAge.excess*pshd.material_cum*ohd.std_quantity else 0 end) as excess_allowance

 FROM		object ohd
left JOIN	part phd ON ohd.part = phd.part
LEFT JOIN	part_online eeh_po ON ohd.part = eeh_po.part 
left JOIN	part_standard pshd ON  ohd.part = pshd.part
LEFT JOIN	@eei_part_standard eei_psh on ohd.part = eei_psh.part 
LEFT JOIN	@eeh_inv_age_review InvAge on ohd.part = InvAge.part and datepart(m,ohd.objectbirthdate) = InvAge.receivedperiod and datepart(yyyy,ohd.objectbirthdate) = InvAge.receivedfiscalyear

WHERE	isNULL(phd.type, 'X') = @PartType 
 		and ohd.location <> 'PREOBJECT' 
		and isNULL(ohd.user_defined_status, 'XXX') !=  'PRESTOCK' 
		AND ohd.part <>'PALLET'
		AND ohd.quantity > 0





GO
