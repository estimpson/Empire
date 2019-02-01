SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- exec eeisp_rpt_object_historical '2017','12','MONTH END','F', '0.013', '0.08', '2017-12-31'

CREATE procedure [dbo].[eeisp_rpt_object_historical] (@FiscalYear int, @Period int, @Reason varchar(15), @PartType char(1), @spi_labor_percentage decimal(18,6), @spi_burden_percentage decimal(18,6), @time_stamp datetime )

as

-- TEST VARIABLES
 /*
declare @fiscalyear int;
declare @period int;
declare @reason varchar(15);
declare @parttype char(1);
declare @spi_labor_percentage decimal(18,6);
declare @spi_burden_percentage decimal(18,6);
declare @time_stamp datetime;
select @fiscalyear = '2017'
select @period = '12'
select @reason = 'MONTH END'
select @parttype = 'F'
select @spi_labor_percentage = '.013'
select @spi_burden_percentage = '.08'
select @time_stamp = '2017-12-31'

 */

--	1) Get the timestamp of the last snapshot in EEISQL1 for the month 

declare @eei_time_stamp datetime;
select @eei_time_stamp = MAX(time_stamp) 
from	HistoricalData.dbo.part_standard_historical 
where	fiscal_year = @fiscalyear
	and period = @period

 -- select @eei_time_stamp


--	2) Get the timestamp of the last snapshot in EEHSQL1 for the month

declare @eeh_time_stamp datetime
select @eeh_time_stamp = (select max(time_stamp) from [EEHSQL1].[HistoricalData].dbo.object_historical where time_Stamp>= @time_stamp and time_stamp < dateadd(d,1,@time_stamp))

-- select @eeh_time_stamp


--	3) Pull the data into table variables for further use in this sp

declare @eei_part_standard_historical table (part varchar(25), production_price decimal(18,6), eei_material_cum DECIMAL(18,6), eei_labor_cum DECIMAL(18,6), eei_burden_cum DECIMAL(18,6),eei_frozen_material_cum DECIMAL(18,6));
insert into @eei_part_standard_historical
(	part,
	production_price,
	eei_material_cum,
	eei_labor_cum,
	eei_burden_cum,
	eei_frozen_material_cum
)
select	part
	   ,price
	   ,material_cum
	   ,labor_cum
	   ,burden_cum
	   ,frozen_material_cum 
from	HistoricalData.dbo.part_standard_historical 
where time_stamp = @EEI_time_stamp

-- select * from @eei_part_standard_historical


--  4) Pull the data into table variables for further use in this sp

DECLARE @eeh_part_standard_historical TABLE (part VARCHAR(25), transfer_price DECIMAL(18,6), eeh_material_cum DECIMAL(18,6), eeh_labor_cum DECIMAL(18,6), eeh_burden_cum DECIMAL(18,6), eeh_frozen_material_cum DECIMAL(18,6));
INSERT INTO @eeh_part_standard_historical
(
    part,
    transfer_price,
    eeh_material_cum,
    eeh_labor_cum,
    eeh_burden_cum,
    eeh_frozen_material_cum
)
SELECT part
		,price
		,material_cum
		,labor_cum
		,burden_cum
		,frozen_material_cum
FROM [EEHSQL1].HistoricalData.dbo.part_standard_historical
WHERE time_stamp = @eeh_time_stamp

-- select * from @eeh_part_standard_historical


--	5) Pull the data into table variables for further use in this sp

--declare @eeh_inv_age_review table (part varchar(25), receivedfiscalyear varchar(4), receivedperiod int, action_item int, excess decimal(18,6));
--insert into @eeh_inv_age_review
--select		part
--		,	receivedfiscalyear
--		,	receivedperiod
--		,	ISNULL(at_risk,0) as action_item
--		,	NEt_RM_104_WK/quantity as excess
--from		[EEHSQL1].monitor.eeiuser.acctg_inv_age_review 
--where		asofdate = (select max(asofdate) from eeiuser.acctg_inv_age_review where asofdate>= @time_stamp and asofdate < dateadd(d,1,@time_stamp))

-- select * from @eeh_inv_age_review


-- 6) Select report data

SELECT	phd.product_line	
		,ohd.part
		,ohd.serial
		,eei_po.Default_vendor		
		,phd.type		
			
		,ohd.plant		
		,ohd.location
		,ohd.status
		--,ohd.object_received_date
		--,datediff(d,ohd.object_received_date,@eeh_time_stamp) as age
		
		,ohd.std_quantity
		,eei_psh.production_price as customer_selling_price	
		,ohd.std_quantity*eei_psh.production_price as ext_customer_selling_price
					
		,pshd.price		
		,ohd.std_quantity*pshd.price as ext_price
		,pshd.material_cum
		,ohd.std_quantity*pshd.material_cum as ext_material_cum
		,pshd.labor_cum	
		,ohd.std_quantity*pshd.labor_cum as ext_labor_cum	
		,pshd.burden_cum
		,ohd.std_quantity*pshd.burden_cum as ext_burden_cum
		,pshd.cost_cum
		,ohd.std_quantity*pshd.cost_cum as ext_cost_cum
		
		,a.salespriceaccum AS spi_selling_price
		,ohd.std_quantity*a.salespriceaccum as ext_spi_selling_price
		,a.materialAccum AS spi_material_cum
		,ohd.std_quantity*a.materialaccum as ext_spi_material_cum
		,a.salespriceaccum*@spi_labor_percentage AS spi_labor_cum
		,ohd.std_quantity*a.salespriceaccum*@spi_labor_percentage as ext_spi_labor_cum
		,a.salespriceaccum*@spi_burden_percentage AS spi_burden_cum
		,ohd.std_quantity*a.salespriceaccum*@spi_burden_percentage as ext_spi_burden_cum
		
		,a.salespriceaccum-a.materialaccum-a.laboraccum-a.burdenaccum AS spi_bip
		,ohd.std_quantity*(a.salespriceaccum-a.materialaccum-(a.salespriceaccum*@spi_labor_percentage)-(a.salespriceaccum*@spi_burden_percentage)) as ext_spi_bip

		--,(case when InvAge.action_item = 1 then pshd.material_cum*ohd.std_quantity else 0 end) as inv_age_allowance
		--,(case when InvAge.action_item = 0 then InvAge.excess*pshd.material_cum*ohd.std_quantity else 0 end) as excess_allowance

 FROM		HistoricalData.dbo.object_historical ohd
LEFT JOIN	HistoricalData.dbo.part_historical phd ON ohd.part = phd.part and phd.time_stamp = @eei_time_stamp
LEFT JOIN	HistoricalData.dbo.part_standard_historical pshd ON  ohd.part = pshd.part and pshd.time_stamp = @eei_time_stamp
LEFT JOIN	part_online eei_po ON ohd.part = eei_po.part 
LEFT JOIN	@eei_part_standard_historical eei_psh on ohd.part = eei_psh.part 
--LEFT JOIN	@eeh_inv_age_review InvAge on ohd.part = InvAge.part and datepart(m,ohd.object_received_date) = InvAge.receivedperiod and datepart(yyyy,ohd.object_received_date) = InvAge.receivedfiscalyear
LEFT JOIN	(SELECT		aaa.part, aaa.materialaccum, aaa.laboraccum, aaa.burdenaccum, aaa.salespriceaccum 
				FROM	[EEHSQL1].Monitor.acct.SubsidiaryPartStandard aaa 
					join (select part, MAX(effectivedate) as effectivedate 
							FROM [EEHSQL1].Monitor.acct.SubsidiaryPartStandard 
							group by part
						 ) bbb 
					on aaa.part = bbb.part 
				   and aaa.effectivedate = bbb.effectivedate
            ) a ON ohd.part = a.part 
WHERE	isNULL(phd.type, 'X') = @PartType 
 		and ohd.location <> 'PREOBJECT' 
		and isNULL(ohd.user_defined_status, 'XXX') <>  'PRESTOCK' 
		AND ohd.part <>'PALLET'
		AND ohd.quantity > 0
		AND ohd.time_stamp = @eei_time_stamp



GO
