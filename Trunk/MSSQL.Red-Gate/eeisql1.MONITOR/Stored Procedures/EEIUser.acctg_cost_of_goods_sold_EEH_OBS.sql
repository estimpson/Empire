SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE proc [EEIUser].[acctg_cost_of_goods_sold_EEH_OBS] (@beg_date date, @end_date date)

as

--    EXEC EEIUSER.ACCTG_COST_OF_GOODS_SOLD @BEG_DATE = '2018-04-01', @END_DATE = '2018-04-30'


/* Created:				2012-06-06		Dan West	Created stored procedure to return EEI COGS 
   Revised:				2016-12-06		Dan West	Updated procedure to use historical costs
   
   Useage:				Used for Crystal Report \\srvdata1\acctg\monthend\[yyyy]\[mm]\EEI\04 Cost of Goods Sold\[yyyy]-[mm] Cost of Goods Sold - EEH Material Cost - xxxxx.rpt"
   
   Dependencies:		EEISQL1.MONITOR.DBO.SHIPPER
						EEISQL1.MONITOR.DBO.SHIPPER_DETAIL
						EEISQL1.MONITOR.FT.FTSP_BOMPerPart_Incremental
						EEISQL1.HISTORICALDATA.DBO.PART_HISTORICAL_DAILY
						EEISQL1.HISTORICALDATA.DBO.PART_STANDARD_HISTORICAL_DAILY
						EEHSQL1.HISTORICALDATA.DBO.PART_HISTORICAL_DAILY
						EEHSQL1.HISTORICALDATA.DBO.PART_STANDARD_HISTORICAL_DAILY
*/

begin
--------------------------------------------------------------------------------------
--1. Format dates for use later on in the procedure (need a varchar for the openquery)
--------------------------------------------------------------------------------------

-- DECLARE	@BEG_DATE DATE = '2017-05-01'
--		   ,@END_DATE DATE = '2017-05-31'

DECLARE @beg_datetime datetime = @beg_date
	   ,@end_datetime datetime = dateadd(d,1,@end_date)

-- SELECT @beg_datetime
-- SELECT @end_datetime

DECLARE @beg_datetime_varchar varchar(19) = @beg_datetime
	   ,@end_datetime_varchar varchar(19) = @end_datetime

-- SELECT @Beg_DateTime
-- SELECT @End_DateTime


-------------------------------------------------------------------
--2. Retrieve the EEH Historical Costs for the selected date range
-------------------------------------------------------------------

IF object_id(N'tempdb..#eeh_costs') IS NOT NULL
	DROP TABLE #eeh_costs
	
CREATE TABLE #eeh_costs 
	(
		time_stamp datetime not null,
		part varchar(25) not null,
		product_line varchar(25) not null default('Not Specified'),
		type varchar(1) not null,
		material_cum decimal(18,6),
		labor_cum decimal(18,6),
		burden_cum decimal(18,6),
		cost_cum decimal(18,6)
		primary key (time_stamp, part)
	)
create nonclustered index IDX_EEH_COSTS_Time_stamp on #EEH_COSTS(time_stamp)

declare	@Syntax nvarchar (4000)
set		@Syntax = N'delete #eeh_costs

				insert	#eeh_costs
				select	*
				from	OpenQuery ( [EEHSQL1], ''SELECT     convert(datetime,pshd.time_stamp) as time_stamp,
															pshd.part,
															isnull(phd.product_line,''''Not Specified'''') as product_line,
															phd.type,
															pshd.material_cum,
															pshd.labor_cum,
															pshd.burden_cum,
															pshd.cost_cum
												 FROM		HistoricalData.dbo.part_standard_historical_daily	pshd
													   JOIN	HistoricalData.dbo.part_historical_daily			phd		ON		pshd.time_stamp = phd.time_stamp and pshd.part = phd.part
												 WHERE		pshd.time_stamp >= ''''' + @beg_datetime_varchar + '''''
														and pshd.time_stamp <  ''''' + @end_datetime_varchar + '''''
														and pshd.reason <> ''''Global Rollup''''
														and phd.type = ''''F''''

												''										   
								  )'
-- select distinct(time_stamp), reason from eehsql1.historicaldata.dbo.part_standard_historical_daily where time_stamp >= '2018-01-01' and time_stamp < '2018-02-01'

execute	sp_executesql
	@Syntax

--  This checks for duplicate time_stamps per day; haven't added a max time_stamp per day because we should not have dupliate entries per day and we should know and correct them rather then work around them
--	select time_stamp, part, count(part) from historicaldata.dbo.eeh_costs a group by time_stamp, part having count(part)>=2


-------------------------------------------------------------------
--3. Retrieve the EEI Historical Costs for the selected date range
-------------------------------------------------------------------

IF object_id(N'tempdb..#eei_costs') IS NOT NULL
	DROP TABLE #eei_costs
	
CREATE TABLE #eei_costs 
	(
		time_stamp datetime not null,
		part varchar(25) not null,
		product_line varchar(25) not null,
		type varchar(1) not null,
		material_cum decimal(18,6),
		labor_cum decimal(18,6),
		burden_cum decimal(18,6),
		cost_cum decimal(18,6),
		frozen_material_cum decimal(18,6)
		primary key (time_stamp, part)
	)
--create nonclustered index IDX_eei_costs_time_stamp on #eei_costs(time_stamp)

INSERT #eei_costs
SELECT		convert(datetime,pshd.time_stamp) as time_stamp,
			pshd.part,
			isnull(phd.product_line,'Not Specified') as product_line,
			phd.type,
			pshd.material_cum,
			pshd.labor_cum,
			pshd.burden_cum,
			pshd.cost_cum,
			pshd.frozen_material_cum
FROM		HistoricalData.dbo.part_standard_historical_daily	pshd
	JOIN	HistoricalData.dbo.part_historical_daily			phd		ON		pshd.time_stamp = phd.time_stamp and pshd.part = phd.part
WHERE		
			pshd.time_stamp >= @beg_datetime
		and pshd.time_stamp <  @end_datetime		
		and pshd.reason <> 'Global Rollup'		
		and phd.type = 'F'

--select * from #eei_costs where part = 'DFN0002-HB13' order by 1


-------------------------------------------------------------------

IF object_id(N'tempdb..#csm_costs') IS NOT NULL
	DROP TABLE #csm_costs
	
CREATE TABLE #csm_costs 
	(
		base_part varchar(25) not null,
		mc_Jan_18 decimal(18,6)
		primary key (base_part)
	)
--create nonclustered index IDX_eei_costs_time_stamp on #eei_costs(time_stamp)

INSERT #csm_costs
SELECT		base_part,
			mc_jan_19
from [EEIUser].[acctg_csm_vw_select_material_cost]
			

--select * from #csm_costs where base_part = 'DFN0002' order by 1


--------------------------------------------------------------------------------------------------------------------------------------
--4. Return the result set
-------------------------------------------------------------------

 SELECT		(case when left(shipper_detail.part_original,7) in (select distinct base_part from eeiuser.acctg_csm_base_part_attributes where product_line = 'PCBe' and release_id = '2018-12') then 'PCBe' else isnull(eei_costs.product_line,'Not Specified') end) as product_line, 
			shipper_detail.shipper,			
			shipper.type,
			shipper.customer,			
			shipper.destination,			
			shipper.date_shipped,
			shipper_detail.part_original, 
			eei_costs.type as part_type,			
			shipper_detail.qty_packed, 
			shipper_detail.boxes_staged,
			shipper_detail.price, 
			isnull(shipper_detail.qty_packed,0)*isnull(shipper_detail.price,0) as ext_price,		
			eei_costs.material_cum,
			isnull(shipper_detail.qty_packed,0)*isnull(eei_costs.material_cum,0) as ext_transfer_price, 
			eei_costs.frozen_material_cum,
			isnull(shipper_detail.qty_packed,0)*isnull(eei_costs.frozen_material_cum,0) as ext_frozen_material_cum,
			eeh_costs.material_cum,
			isnull(shipper_detail.qty_packed,0)*isnull(eeh_costs.material_cum,0) as ext_eeh_material_cum,
			csm_costs.mc_Jan_18,
			isnull(shipper_detail.qty_packed,0)*isnull(csm_costs.mc_jan_18,0) as ext_csm_material_cum,
			ic.TopPart, 
			ic.ChildPart, 
			ic.BulbedPrice,
			isnull(shipper_detail.qty_packed,0)*isnull(ic.bulbedPrice,0) as ext_Bulbed_Price, 
			ic.UnbulbedPrice, 
			isnull(shipper_detail.qty_packed,0)*isnull(ic.UnbulbedPrice,0) as ext_Unbulbed_Price,
			isnull(shipper_detail.price,0)-isnull(ic.UnbulbedPrice,0) as incremental_price,
			(isnull(shipper_detail.qty_packed,0)*isnull(shipper_detail.price,0))-(isnull(shipper_detail.qty_packed,0)*isnull(ic.unbulbedPrice,0)) as ext_incremental_price, 
			ic.BulbedMaterialCost,
			isnull(shipper_detail.qty_packed,0)*isnull(ic.BulbedMaterialCost,0) as ext_Bulbed_material_cost,
			ic.UnbulbedMaterialCost,
			isnull(shipper_detail.qty_packed,0)*isnull(ic.UnbulbedMaterialCost,0) as ext_unBulbed_material_cost,
			ic.IncrementalMaterialCost,
			isnull(shipper_detail.qty_packed,0)*isnull(ic.incrementalMaterialCost,0) as ext_incremental_material_cost
 FROM        EEHSQL1.MONITOR.dbo.shipper shipper 
 		JOIN EEHSQL1.MONITOR.dbo.shipper_detail shipper_detail		ON shipper.id = shipper_detail.shipper
	LEFT OUTER JOIN #eei_costs eei_costs				ON shipper_detail.part_original = eei_costs.part AND convert(date,shipper.date_shipped) = convert(date, eei_costs.time_stamp)
	LEFT OUTER JOIN #eeh_costs eeh_costs				ON shipper_detail.part_original = eeh_costs.part AND convert(date,shipper.date_shipped) = convert(date, eeh_costs.time_stamp)
	LEFT OUTER JOIN FT.Ftsp_BOMPerPart_incremental IC	ON ic.toppart = shipper_detail.part_original
	LEFT OUTER JOIN #csm_costs csm_costs				ON left(shipper_detail.part_original,7) = csm_costs.base_part 
 WHERE		shipper.destination <> 'EMPHOND' 
		AND shipper.date_shipped >= @beg_datetime
		AND shipper.date_shipped <  @end_datetime

order by	eei_costs.product_line, 
			shipper_detail.part_original

--option(recompile)

end









GO
