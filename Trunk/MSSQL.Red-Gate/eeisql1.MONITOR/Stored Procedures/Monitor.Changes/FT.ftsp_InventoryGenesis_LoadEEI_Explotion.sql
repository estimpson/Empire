SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [FT].[ftsp_InventoryGenesis_LoadEEI_Explotion]
	@TimeStamp datetime = null
,	@RenameTimeStamp datetime = null
,	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_nulls on
set ansi_warnings on
set	@Result = 999999


DECLARE     @TranCount smallint

DECLARE @ProcReturn integer, @ProcResult integer 
DECLARE @Error integer, @RowCount integer,@ProcName sysname
set    @ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)  -- e.g. dbo.usp_Test

----<Tran Required=Yes AutoCreate=Yes>
SET   @TranCount = @@TranCount
IF    @TranCount = 0 
      BEGIN TRANSACTION @ProcName
ELSE
      SAVE TRANSACTION @ProcName

declare	@PreviousRun datetime


--------------------------------------------------------------------------------------------------------------------------------------------------
/*  10. Delete previous snapshots if they were DAILY, just keed the Month End																	*/
--------------------------------------------------------------------------------------------------------------------------------------------------



if	exists( 
			SELECT 	1
			FROM 
				EEIUser.acctg_inv_age_review_Explotion
			WHERE IsActive=1) BEGIN
	UPDATE EEIUser.acctg_inv_age_review_Explotion 
	SET IsActive=2
		WHERE IsActive=1


			set    @Error = @@Error
             if     @Error != 0 begin
                    set    @Result = 900501
                    RAISERROR ('Error updating in %s.  Error: %d while updating row to table', 16, 1, @ProcName, @Error, 'TestPlan')
                    rollback tran @ProcName
                    return @Result
              end

end

--- <Error Handling>
--declare
--	@CallProcName sysname,
--	@TableName sysname,
--	@ProcName sysname,
--	@ProcReturn integer,
--	@ProcResult integer,
--	@Error integer,
--	@RowCount integer

--set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. FT.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
--declare
--	@TranCount smallint

--set	@TranCount = @@TranCount
--if	@TranCount = 0 begin
--	begin tran @ProcName
--end
--else begin
--	save tran @ProcName
--end
--set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
--------------------------------------------------------------------------------------------------------------------------------------------------
/*	Get the time stamp of the last daily snapshot or use the value passed. */
--------------------------------------------------------------------------------------------------------------------------------------------------

SET @TimeStamp = coalesce
	(	@TimeStamp
	,	(	SELECT 
				max(time_stamp)
			FROM
				[HistoricalData].dbo.object_historical_daily
			--where
			--	reason = 'MONTH END'
		)
	, getdate()
	)


--------------------------------------------------------------------------------------------------------------------------------------------------
/*  1. Get the Objects to evaulate																												*/
--------------------------------------------------------------------------------------------------------------------------------------------------
--declare @rawInvSummary table
CREATE TABLE	#rawInvSummary
(	Serial int
,   AsofDate datetime
,	ReceivedFiscalYear int
,	ReceivedPeriod int
,	DefaultVendor varchar(50)
,	RawPart varchar(25)
,	PartName varchar(100)
,	Commodity varchar(30)
,	OHQty numeric(20,6)
,	OHMaterialCost numeric(20,6)
,	StdPack numeric(20,6)
,	MinOrderQty numeric(20,6)
,	MaterialAccum numeric(20,6)
,	TotalOHQty numeric(20,6)
,	Location varchar(25)
,	last_date datetime
,   objectbirthday datetime
,	unique
	(	Serial
	,	ReceivedFiscalYear
	,	ReceivedPeriod
	)
)

INSERT
	#rawInvSummary
(	Serial	
,	AsofDate
,	ReceivedFiscalYear
,	ReceivedPeriod
,	DefaultVendor
,	RawPart
,	PartName
,	Commodity
,	OHQty
,	OHMaterialCost
,	StdPack
,	MinOrderQty
,	MaterialAccum
,   Location
,	last_date
,   objectbirthday
)
SELECT 
	Serial
,	AsofDate = max(oh.time_stamp)
--,	ReceivedFiscalYear = year(oh.object_received_date)
,	ReceivedFiscalYear = year(oh.objectbirthday)
--,	ReceivedPeriod = month(oh.object_received_date)
,	ReceivedPeriod = month(oh.objectbirthday)
,	DefaultVendor = max(po.default_vendor)
,	RawPart = oh.part
,	PartName = max(ph.name)
,	Commodity = max(ph.commodity)
,	OHQty = sum(oh.Quantity)
,	OHMaterialCost = sum((oh.Quantity * psh.material_cum))
,	StdPack = max(standard_pack)
,	MinOrderQty =
		(	SELECT
				min(min_on_order)
			FROM
				part_vendor pv
			WHERE
				pv.part = oh.part
				and pv.vendor = po.default_vendor
		)
,	MaterialAccum = max(psh.material_cum),
	oh.location,
	oh.last_date,
	oh.objectbirthday
FROM
	[HistoricalData].dbo.object_historical_daily oh
	join [HistoricalData].dbo.part_standard_historical_daily psh
		ON oh.Time_stamp = psh.time_stamp
		   and oh.part = psh.part
	join [HistoricalData].dbo.part_historical_daily ph
		ON oh.Time_stamp = ph.time_stamp
		   and oh.part = ph.part
	left join part_inventory pi
		ON oh.part = pi.part
	left join part_online po
		ON oh.part = po.part
	left join location
		ON oh.location = location.code
WHERE
	oh.Time_stamp = @timestamp
	and ph.type = 'F'
	and oh.quantity > 0
--	and coalesce(location.secured_location,'N') != 'Y'
GROUP BY
	oh.part
--,	year(oh.object_received_date)
,	year(oh.objectbirthday)
--Last_Date
--,	month(oh.object_received_date)
,	month(oh.objectbirthday)
,	po.default_vendor,
	serial,oh.location,oh.last_date,oh.objectbirthday



			set    @Error = @@Error
            if     @Error != 0 begin
                    set    @Result = 900501
                    RAISERROR ('Error inserting in %s.  Error: %d while inserting row to table', 16, 1, @ProcName, @Error, 'TestPlan')
                    rollback tran @ProcName
                    return @Result
             end
----update
----	ris
----set TotalOHQty = (select sum(OHQty) from #rawInvSummary where RawPart = ris.RawPart)
----from
------  @rawInvSummary ris (Table Variable version)
----	#rawInvSummary ris

--select
--	*
--from
--	@rawInvSummary

/*	Get raw-finished xref. */
--declare	@rawFinX table
CREATE TABLE #rawFinX
(	RawPart varchar(25)
,	FinishedPart varchar(25)
,	XQty float not null
,	primary key
	(	RawPart
	,	FinishedPart
	)
)

-- insert @rawFinX -- table variable version
INSERT #rawFinX
SELECT 
	RawPart = xr.ChildPart
,	FinishedPart = xr.TopPart
,	XQty = sum(xr.XQty)
FROM
	FT.XRt xr
	join (	SELECT DISTINCT RawPart 
			FROM  #rawInvSummary ) ris
		ON ris.RawPart = xr.ChildPart
	--join dbo.part pFin
	--	on pFin.part = xr.TopPart
	--	and pFin.Type = 'F'
	--	and pFin.Class = 'M'
GROUP BY
	xr.TopPart
,	xr.ChildPart


			set    @Error = @@Error
            if     @Error != 0 begin
                    set    @Result = 900501
                    RAISERROR ('Error inserting in %s.  Error: %d while inserting row to table', 16, 1, @ProcName, @Error, 'TestPlan')
                    rollback tran @ProcName
                    return @Result
             end
--select
--	*
--from
--	@rawFinX
--where
--	RawPart = '1013303'

/*	Get the End of Production data for Finished Good Base Parts.*/
--declare @BasePartEOP table -- table variable version
CREATE TABLE #BasePartEOP
(	BasePart char(7) primary key
,	EOP datetime
,	EOPWeeks int
)

-- insert @BasePartEOP
INSERT #BasePartEOP
(	BasePart
,	EOP
,	EOPWeeks
)
SELECT
	BasePart = acvscd.base_part
,	EOP = max(acvscd.eop_display)
,	EOPWeeks =
	CASE
		WHEN max(acvscd.eop_display) > dateadd(year, 2, getdate()) THEN 104
		WHEN max(acvscd.eop_display) < getdate() THEN 0
		ELSE datediff(week, getdate(), max(acvscd.eop_display))
	END
FROM
	(
		SELECT 	base_part, eop_display
		FROM	Monitor.EEIUser.acctg_csm_vw_select_sales_forecast acvscd

		UNION 

		SELECT 	base_part = left( part_number, 7), eop_display = Max(due_date) 
		FROM	order_detail
		WHERE	quantity > 0
		GROUP BY  left( part_number, 7)
	) acvscd
--from
--	Monitor.EEIUser.acctg_csm_vw_select_sales_forecast acvscd
GROUP BY
	acvscd.base_part

			set    @Error = @@Error
			if     @Error != 0 begin
                    set    @Result = 900501
                    RAISERROR ('Error inserting in %s.  Error: %d while inserting row to table', 16, 1, @ProcName, @Error, 'TestPlan')
                    rollback tran @ProcName
                    return @Result
             end
--select
--	BasePart = acvscd.base_part
--,	EOP = max(acvscd.eop_display)
--,	EOPWeeks =
--	case
--		when max(acvscd.eop_display) > dateadd(year, 2, getdate()) then 104
--		when max(acvscd.eop_display) < getdate() then 0
--		else datediff(week, getdate(), max(acvscd.eop_display))
--	end
--from
--	csm_NACSM acvscd
--group by
--	acvscd.base_part

--This next copuple of lines where the orignal, was replaced from a table that is populate from the view.
--select
--	*
--from
----need to change getdate() to @rawinvsummary.asofdate
--	openquery(EEISQL1, '
--select
--	BasePart = acvscd.base_part
--,	EOP = max(acvscd.eop_display)
--,	EOPWeeks =
--	case
--		when max(acvscd.eop_display) > dateadd(year, 2, getdate()) then 104
--		when max(acvscd.eop_display) < getdate() then 0
--		else datediff(week, getdate(), max(acvscd.eop_display))
--	end
--from
--	Monitor.EEIUser.acctg_csm_vw_select_csmdemandwitheeiadjustments_dw2_NEW_with_MaterialCum acvscd
--group by
--	acvscd.base_part
--'	)

--select
--	*
--from
--	@BasePartEOP

/*  Get service demand. */
-- declare	@EEI_serviceForecast table
CREATE TABLE #EEI_serviceForecast
(	ServiceBasePart varchar(25) primary key
,	ServicePart varchar(255) null
,	OnHand int null
,	CurrentYearSales int null
,	TotalDemand numeric(20,6)
)

--insert @EEI_serviceForecast
INSERT #EEI_serviceForecast
SELECT DISTINCT
	ServiceBasePart = sdf.[Base Part]
,	ServicePart = sdf.[Part Number]
,	OnHand = sdf.[Inventory on Hand (Current)]
,	CurrentYearSales = sdf.[2012 Service shipments]
,	TotalDemand =
		coalesce(sdf.[2012 Service], 0) + 
		coalesce(sdf.[2013 Service], 0) + 
		coalesce(sdf.[2014 Service], 0) + 
		coalesce(sdf.[2015 Service], 0) + 
		coalesce(sdf.[2016 Service], 0) + 
		coalesce(sdf.[2017 Service], 0) + 
		coalesce(sdf.[2018 Service], 0) + 
		coalesce(sdf.[2019 Service], 0) + 
		coalesce(sdf.[2020 Service], 0) + 
		coalesce(sdf.[2021 Service], 0) + 
		coalesce(sdf.[2022 Service], 0) + 
		coalesce(sdf.[2023 Service], 0) + 
		coalesce(sdf.[2024 Service], 0) + 
		coalesce(sdf.[2025 Service], 0)
FROM
	 MONITOR.EEIACCT.ServiceDemandForecast sdf


			 set    @Error = @@Error
            if     @Error != 0 begin
                    set    @Result = 900501
                    RAISERROR ('Error inserting in %s.  Error: %d while inserting row to table', 16, 1, @ProcName, @Error, 'TestPlan')
                    rollback tran @ProcName
                    return @Result
             end
--declare	@demandSource table
CREATE TABLE #demandSource
(	rm_part1 varchar(50) not null
,	RunFrom varchar(100) null
,	primary key (rm_part1)
)

--insert	@demandSource
INSERT #demandSource
SELECT 
	rm_part1 = xr.ChildPart
,	RunFrom =
		CASE
			WHEN
				max(sf.ServiceBasePart) is not null
				and max(fgDemand.FGDemandPart) is not null then 'Active MPS and Service List'
			WHEN
				max(sf.ServiceBasePart) is null
				and max(fgDemand.FGDemandPart) is not null then 'Active MPS'
			WHEN
				max(sf.ServiceBasePart) is not null
				and max(fgDemand.FGDemandPart) is null then 'Active Service List'
		END
FROM
	FT.XRt xr
	join dbo.part pRaw
		ON pRaw.part = xr.ChildPart
		--and pRaw.type = 'R'
	left join #EEI_serviceForecast sf
		ON sf.ServiceBasePart = left(xr.TopPart, 7)
	left join
	(	SELECT
	 		FGDemandPart = od.part_number
	 	FROM
	 		dbo.order_detail od
	 	GROUP BY
	 		od.part_number
	) fgDemand
		on fgDemand.FGDemandPart = xr.TopPart
GROUP BY
	xr.ChildPart
HAVING
	MAX(sf.ServiceBasePart) is not null
	or MAX(fgDemand.FGDemandPart) is not null
ORDER BY
	1, 2

			set    @Error = @@Error
            if     @Error != 0 begin
                    set    @Result = 900501
                    RAISERROR ('Error inserting in %s.  Error: %d while inserting row to table', 16, 1, @ProcName, @Error, 'TestPlan')
                    rollback tran @ProcName
                    return @Result
             end	
--select
--	*
--from
--	@EEI_serviceForecast

--select
--	*
--from
--	@demandSource

/*	Get the finished description of raw parts. */
--declare	@rawPartsFinishedDescription table
CREATE TABLE #rawPartsFinishedDescription
(	RawPart varchar(25) primary key
,	ActiveFinished varchar(max)
,	Service varchar(max)
,	InactiveFinished varchar(max)
)

--declare	@rawDemand table
CREATE TABLE #rawDemand
(	RawPart varchar(25)
,	FinishedPart varchar(25)
,	Demand numeric(20,6) not null
,	ServiceForecast numeric(20,6) not null
,	XQty float not null
,	EOPDT datetime null
,	primary key
	(	RawPart
	,	FinishedPart
	)
)

--insert	@rawDemand
INSERT #rawDemand
SELECT
	RawPart = rfx.RawPart
,	FinishedPart = rfx.FinishedPart
,	Demand = coalesce(odDemand.Qty, 0)
,	ServiceForecast = coalesce(serviceForcast.TotalDemand, 0)
,	XQty = rfx.XQty
,	EOPDT = bpe.EOP
FROM
	#rawFinX rfx
	left join #BasePartEOP bpe
		ON bpe.BasePart = left(rfx.FinishedPart, 7)
	left join
	(	SELECT 
	 		FinishedPart = od.part_number
	 	,	Qty = sum(od.quantity)
	 	FROM
	 		dbo.order_detail od
	 	WHERE 
	 		od.quantity > 0
	 	GROUP BY
	 		od.part_number
	) odDemand
		ON odDemand.FinishedPart = rfx.FinishedPart
	left join
	(	SELECT 
			FG_Part = (SELECT  max(FinishedPart) FROM #rawFinX WHERE left(FinishedPart, 7) = sf.ServiceBasePart)
		,	sf.TotalDemand
		FROM
			#EEI_serviceForecast sf
	) serviceForcast
		ON serviceForcast.FG_Part = rfx.FinishedPart

			set    @Error = @@Error
            if     @Error != 0 begin
                    set    @Result = 900501
                    RAISERROR ('Error inserting in %s.  Error: %d while inserting row to table', 16, 1, @ProcName, @Error, 'TestPlan')
                    rollback tran @ProcName
                    return @Result
             end

declare
	rawParts cursor local for
SELECT  DISTINCT
	RawPart
FROM
	#rawDemand

OPEN rawParts

WHILE
	1 = 1 BEGIN
	
	DECLARE
		@rawPart varchar(25)
	,	@activePartList varchar(4000)
	,	@servicePartList varchar(4000)
	,	@inactivePartList varchar(4000)
	
	FETCH
		rawParts
	INTO
		@rawPart
	
	IF	@@FETCH_STATUS != 0 BEGIN
		BREAK
	END
	
	SET	@activePartList = ''
	SET @servicePartList = ''
	SET @inactivePartList = ''
	
	SELECT
		@activePartList = @activePartList +
		'( ' + rd.FinishedPart +
			' Qty: ' + convert(varchar(12), convert(numeric(10,2), rd.XQty)) +
			' Dmd: ' + convert(varchar(12), convert(numeric(10,0), rd.Demand)) +
			' EOP: ' + coalesce(convert(varchar(12), rd.EOPDT, 101), 'N/A') +
		' )'
	FROM
		#rawDemand rd
	WHERE
		rd.Demand > 0
		and rd.RawPart = @rawPart
	ORDER BY
		rd.FinishedPart
	
	SELECT 
		@servicePartList = @servicePartList +
		'( ' + rd.FinishedPart +
			' Qty: ' + convert(varchar(12), convert(numeric(10,2), rd.XQty)) +
			' Dmd: ' + convert(varchar(12), convert(numeric(10,0), rd.ServiceForecast)) +
			' EOP: ' + coalesce(convert(varchar(12), rd.EOPDT, 101), 'N/A') +
		' )'
	FROM
		#rawDemand rd
	WHERE
		rd.ServiceForecast > 0
		and rd.RawPart = @rawPart
	ORDER BY
		rd.FinishedPart
	
	SELECT
		@inactivePartList = @inactivePartList +
		'( ' + rd.FinishedPart +
			' Qty: ' + convert(varchar(12), convert(numeric(10,2), rd.XQty)) +
			' Dmd: 0' +
			' EOP: ' + coalesce(convert(varchar(12), rd.EOPDT, 101), 'N/A') +
		' ), '
	FROM
		#rawDemand rd
	WHERE
		coalesce(rd.Demand, 0) <= 0
		and coalesce(rd.ServiceForecast, 0) <= 0
		and rd.RawPart = @rawPart
	ORDER BY
		rd.FinishedPart
	
	INSERT
		#rawPartsFinishedDescription
	SELECT 
		RawPart = @rawPart
	,	ActiveFinished = left(@activePartList, datalength(nullif(@activePartList, '')) - 2)
	,	Service = left(@servicePartList, datalength(nullif(@servicePartList, '')) - 2)
	,	InactiveFinished = left(@inactivePartList, datalength(nullif(@inactivePartList, '')) - 2)

			set    @Error = @@Error
            if     @Error != 0 begin
                    set    @Result = 900501
                    RAISERROR ('Error inserting in %s.  Error: %d while inserting row to table', 16, 1, @ProcName, @Error, 'TestPlan')
                    rollback tran @ProcName
                    return @Result
             end
END
CLOSE
	rawParts
DEALLOCATE
	rawParts

--select
--	*
--from
--	@rawPartsFinishedDescription
--where
--	RawPart = '1013303'

--------------------------------------------------------------------------------------------------------------------------------------------------
/*  2. Get the FG Demand (via EEH's order_detail)																								*/
--------------------------------------------------------------------------------------------------------------------------------------------------
--declare	@BasePartDemand table
CREATE TABLE #BasePartDemand
(	FG_Part varchar(25)
,	FG_20_Wk_Demand numeric(20,6)
,	FG_Avg_Wk_Demand numeric(20,6)
,	FG_On_Hand numeric(20,6)
,	FG_Net_20_Wk_Demand numeric(20,6)
,	FG_Net_Avg_Wk_Demand numeric(20,6)
,	FG_Max_OrderDate datetime
,	WeeksRemainProduction int
	primary key
	(	FG_Part
	)
)

INSERT	#BasePartDemand
SELECT
	od.part_number as FG_Part
,	sum(od.Quantity) as FG_20_Wk_Demand
,	(sum(od.Quantity) / 20) as FG_Avg_Wk_Demand
,	coalesce(max(onHandQty),0) as FG_On_Hand
--,	(case when (sum(od.Quantity) - coalesce(max(o.OnHandQty),0)) < 0 then 0
--		  else (sum(od.Quantity) - coalesce(max(o.OnHandQty),0))
--	 end) as FG_Net_20_Wk_Demand
,	sum(od.Quantity) as FG_Net_20_Wk_Demand

--,	(case when (sum(od.Quantity) - coalesce(max(o.OnHandQty),0)) < 0 then 0
--		  else (sum(od.Quantity) - coalesce(max(o.OnHandQty),0))
--	 end) / 20 as FG_Net_Avg_Wk_Demand  --under states the rate of consumption.
,	(sum(od.Quantity) / 20) as FG_Net_Avg_Wk_Demand
,	max( od.due_date )
,	WeeksRemainProduction = 20
FROM
	order_detail od
	left join
	(	SELECT
			part
		,	sum(Quantity) as onHandQty
		FROM
			object
			left join location
				on object.location = location.code
		--where
		--	coalesce(nullif(secured_location,''),'N') != 'Y'
		GROUP BY
			part
	) o
		ON od.part_number = o.part
WHERE 
	od.due_date >= dateadd(dd,-14,getdate())
	and od.due_date <= dateadd(wk,20,getdate())
GROUP BY
	od.part_number


			set    @Error = @@Error
            if     @Error != 0 begin
                    set    @Result = 900501
                    RAISERROR ('Error inserting in %s.  Error: %d while inserting row to table', 16, 1, @ProcName, @Error, 'TestPlan')
                    rollback tran @ProcName
                    return @Result
             end

UPDATE	#BasePartDemand
SET		WeeksRemainProduction = CASE WHEN EOPWeeks > 20 THEN 20 ELSE EOPWeeks END
FROM	#BasePartDemand PartDemand
		join #BasePartEOP PartEOP ON  PartEOP.BasePart = Left(PartDemand.FG_Part, 7)

			set    @Error = @@Error
             if     @Error != 0 begin
                    set    @Result = 900501
                    RAISERROR ('Error updating in %s.  Error: %d while updating row to table', 16, 1, @ProcName, @Error, 'TestPlan')
                    rollback tran @ProcName
                    return @Result
              end

-- todo requerimeitno menor a 1 por semana debe ser ignorado
UPDATE	#BasePartDemand
SET		FG_20_Wk_Demand =  CASE WHEN FG_Avg_Wk_Demand <= 1 THEN 0 ELSE FG_20_Wk_Demand END,
		FG_Avg_Wk_Demand =  CASE WHEN FG_Avg_Wk_Demand <= 1 THEN 0 ELSE FG_Avg_Wk_Demand END,
		FG_Net_20_Wk_Demand =  CASE WHEN FG_Avg_Wk_Demand <= 1 THEN 0 ELSE FG_Net_20_Wk_Demand END

			 set    @Error = @@Error
             if     @Error != 0 begin
                    set    @Result = 900501
                    RAISERROR ('Error updating in %s.  Error: %d while updating row to table', 16, 1, @ProcName, @Error, 'TestPlan')
                    rollback tran @ProcName
                    return @Result
              end

UPDATE	#BasePartDemand
SET		FG_Net_Avg_Wk_Demand = FG_Net_20_Wk_Demand / WeeksRemainProduction,
		FG_Avg_Wk_Demand = FG_20_Wk_Demand / WeeksRemainProduction
WHERE	WeeksRemainProduction > 0
			set    @Error = @@Error
             if     @Error != 0 begin
                    set    @Result = 900501
                    RAISERROR ('Error updating in %s.  Error: %d while updating row to table', 16, 1, @ProcName, @Error, 'TestPlan')
                    rollback tran @ProcName
                    return @Result
              end

--select
--	*
--from
--	@BasePartDemand

--------------------------------------------------------------------------------------------------------------------------------------------------
/*  4. Calculate the RM Demand																													*/
--------------------------------------------------------------------------------------------------------------------------------------------------
--declare	@DemandData table
CREATE TABLE #DemandData
(	RM_Part varchar(50)
,	FG_On_Hand numeric(18,6)
,	FG_Net_20_Wk_Demand numeric(18,6)
,	FG_Net_Avg_Wk_Demand numeric(18,6)
,	BOMQty numeric(18,6)
,	RM_Net_20_Wk_Demand numeric(18,6)
,	RM_Net_Avg_Wk_Demand numeric(18,6)
,	RM_Net_104_WkDemand numeric(18,6)
,	FG_Total_Demand numeric(18,6)
,	WeeksRemainProduction int
)

INSERT
	#DemandData
SELECT
	RM_Part
,	sum(FG_On_Hand) as FG_On_Hand
,	sum(FG_Net_20_Wk_Demand) as FG_Net_20_Wk_Demand
,	sum(FG_Net_Avg_Wk_Demand) as FG_Net_Avg_Wk_Demand
,	avg(a.XQty) as BomQty --????
,	sum(RM_Net_20_Wk_Demand) as RM_Net_20_Wk_Demand
,	sum(RM_Net_Avg_Wk_Demand) as RM_Net_Avg_Wk_Demand
,	sum(RM_Net_104_WkDemand) as RM_Net_104_WkDemand
,	sum( FG_20_Wk_Demand ) as FG_Total_Demand
,	max( WeeksRemainProduction ) as WeeksRemainProduction
FROM
	(	SELECT
			RM_Part = coalesce(prodDemand.RM_Part, serviceDemand.RM_Part)
		,	FG_Part = coalesce(prodDemand.FG_Part, serviceDemand.FG_Part)
		,	FG_On_Hand = coalesce(prodDemand.FG_On_Hand, 0)
		,	FG_Net_20_Wk_Demand = coalesce(prodDemand.FG_Net_20_Wk_Demand, 0)
		,	FG_Net_Avg_Wk_Demand = coalesce(prodDemand.FG_Net_Avg_Wk_Demand, 0)
		,	XQty = coalesce(prodDemand.XQty, serviceDemand.XQty)
		,	RM_Net_20_Wk_Demand = coalesce(prodDemand.RM_Net_20_Wk_Demand, 0)
		,	RM_Net_Avg_Wk_Demand = coalesce(prodDemand.RM_Net_Avg_Wk_Demand, 0)
		,	RM_Net_104_WkDemand = coalesce(serviceDemand.FG_Total_Demand, prodDemand.RM_Net_104_WkDemand)
		,	FG_20_Wk_Demand = coalesce(  prodDemand.FG_20_Wk_Demand, 0 )
		,	WeeksRemainProduction = coalesce( prodDemand.WeeksRemainProduction, 0 )
		FROM
			(	SELECT 
					RM_Part = rfx.RawPart
				,	bpd.FG_Part
				,	bpd.FG_On_Hand
				,	bpd.FG_20_Wk_Demand
				,	bpd.FG_Net_20_Wk_Demand
				,	bpd.FG_Net_Avg_Wk_Demand
				,	rfx.XQty
				,	(bpd.FG_Net_20_Wk_Demand * rfx.XQty) as RM_Net_20_Wk_Demand
				,	(bpd.FG_Net_Avg_Wk_Demand * rfx.XQty) as RM_Net_Avg_Wk_Demand
				,	coalesce((bpd.FG_Net_Avg_Wk_Demand * rfx.XQty * bpe.EOPWeeks), (bpd.FG_Net_20_Wk_Demand * rfx.XQty)) as RM_Net_104_WkDemand
				,	WeeksRemainProduction
				FROM
					#BasePartDemand bpd
					left join #rawFinX rfx
						on bpd.FG_Part = rfx.FinishedPart
					left join #BasePartEOP bpe
						on bpe.BasePart = left(bpd.FG_Part, 7)
			) prodDemand -- Get the total demand from orders.
			FULL join
			(	SELECT 
					RM_Part = rfx.RawPart
				,	FG_Part = rfx.FinishedPart
				,	XQty = rfx.XQty
				,	FG_Total_Demand = (sf.TotalDemand * rfx.XQty)
				FROM
					#EEI_serviceForecast sf
					left join #rawFinX rfx
						ON left (rfx.FinishedPart, 7) = sf.ServiceBasePart
						and rfx.FinishedPart =
							(	SELECT
									max(FinishedPart)
								FROM
									#rawFinX
								WHERE
									sf.ServiceBasePart = left(FinishedPart, 7)
							)
			) serviceDemand -- Get the total demand from service forecast.
			ON prodDemand.RM_Part = serviceDemand.RM_Part
			and prodDemand.FG_Part = serviceDemand.FG_Part
	) a
GROUP BY
	RM_Part

		set    @Error = @@Error
            if     @Error != 0 begin
                    set    @Result = 900501
                    RAISERROR ('Error inserting in %s.  Error: %d while inserting row to table', 16, 1, @ProcName, @Error, 'TestPlan')
                    rollback tran @ProcName
                    return @Result
             end

--select
--	*
--from
--	@DemandData
--where
--	RM_Part = '1013303'
	
--------------------------------------------------------------------------------------------------------------------------------------------------
/*  5. Get the RM on order																														*/
--------------------------------------------------------------------------------------------------------------------------------------------------
--declare @rawOnOrder table
CREATE TABLE #rawOnOrder
(	RMPart1 varchar(25)
,	QtyOnOrder numeric(18,6)
)

INSERT
	#rawOnOrder
SELECT 
	part_number as RMPart1
,	sum(pd.quantity)
FROM 
	dbo.po_detail pd
WHERE
	part_number in
	(	SELECT 
			RawPart
		FROM
			#rawInvSummary ris
	)
GROUP BY
	part_number

			set    @Error = @@Error
            if     @Error != 0 begin
                    set    @Result = 900501
                    RAISERROR ('Error inserting in %s.  Error: %d while inserting row to table', 16, 1, @ProcName, @Error, 'TestPlan')
                    rollback tran @ProcName
                    return @Result
             end

--select
--	*
--from
--	@rawOnOrder
--where
--	RMPart1 = '1013303'

/*	Get the last material issue for every part. */
--declare @lastMI table
CREATE TABLE #lastMI
(	RawPart varchar(25) primary key
,	LastTranDT datetime
)

INSERT
	#lastMI
SELECT 
	RawPart = atMI.part
,	LastTranDT = max(atMI.date_stamp)
FROM
	audit_trail atMI with (readuncommitted)
	join part pRaw with (readuncommitted)
		on pRaw.part = atMI.part
		and pRaw.type = 'R'
WHERE
	atMI.type = 'M'
GROUP BY
	atMI.part

			set    @Error = @@Error
            if     @Error != 0 begin
                    set    @Result = 900501
                    RAISERROR ('Error inserting in %s.  Error: %d while inserting row to table', 16, 1, @ProcName, @Error, 'TestPlan')
                    rollback tran @ProcName
                    return @Result
             end

--select
--	*
--from
--	@lastMI

--------------------------------------------------------------------------------------------------------------------------------------------------
/*  9. Get the Inactive programs where no finished demand is associated with these programs	but the part is on the finished good BOM			*/
--------------------------------------------------------------------------------------------------------------------------------------------------
IF	@RenameTimeStamp is not null BEGIN
	UPDATE
		aiar
	SET
		asofdate = @RenameTimeStamp
	FROM
		EEIUser.acctg_inv_age_review_Explotion aiar
	WHERE
		aiar.asofdate = @TimeStamp
END

--select	*
--from	#rawInvSummary

INSERT
	MONITOR.eeiuser.acctg_inv_age_review_Explotion
(	Serial	
,	asofdate
,	ReceivedFiscalYear
,	receivedperiod
,	default_vendor
,	part
,	part_name
,	commodity
,	quantity
,	ext_material_cum
,	std_pack
,	min_order_qty
,	min_empire_sop
,	max_empire_eop
,	fg_on_hand
,	FG_Net_20_Wk_Demand
,	FG_Net_Avg_Wk_Demand
,	RM_Net_20_Wk_Demand
,	RM_Net_Avg_Wk_Demand
,	weeks_to_exhaust
,	exhaust_date
,	classification
,	on_hold
,	active_demand
,	max_date_material_issued
,	category
,	active_where_used
,	service_where_used
,	inactive_where_used
,	note
,	review_note
,	assigned_party
,	corrective_action
,	at_risk
,	percent_total
,	RM_Net_104_WkDemand
,	Net_RM_104_Wk
,	Net_RM_104_Wk_Material
,	WeeksRemainProduction
,	Location
,   objectbirthday
,   IsActive
)
SELECT 
	ris.serial
,	ris.AsOfDate
,	ris.ReceivedFiscalYear
,	ris.ReceivedPeriod
,	ris.DefaultVendor
,	ris.RawPart
,	ris.PartName
,	ris.Commodity
,	ris.OHQty
,	ris.OHMaterialCost
,	ris.StdPack
,	ris.MinOrderQty
,	min_empire_sop = null
,	max_empire_eop = null
,	dd.FG_On_Hand
,	dd.FG_Net_20_Wk_Demand
,	dd.FG_Net_Avg_Wk_Demand
,	dd.RM_Net_20_Wk_Demand
,	dd.RM_Net_Avg_Wk_Demand
,	Weeks_to_Exhaust = (ris.OHQty / ris.TotalOHQty) * ris.OHQty / nullif(dd.RM_Net_Avg_Wk_Demand, 0)
,	ExhaustDate =
	CASE
		WHEN (ris.OHQty / ris.TotalOHQty) * ris.OHQty / nullif(dd.RM_Net_avg_Wk_demand, 0) < (28000 / 7) THEN dateadd(day, ((ris.OHQty / ris.TotalOHQty) * ris.OHQty / dd.RM_Net_avg_Wk_Demand) * 7, ris.AsOfDate)
		ELSE '2100-01-01'
	END
,	classification = null
,	on_hold = null
,	coalesce(ds.RunFrom, 'Obsolete') as RunFrom
,	lm.LastTranDT
,	Category =		CASE
					WHEN coalesce(ds.RunFrom, 'obsolete') = 'obsolete' 
						THEN
							CASE
							WHEN datediff(day, lm.LastTranDT, ris.AsOfDate) > 365 
								THEN 'Obsolete > 365 days'
							ELSE 'Obsolete < 365 days' END
					ELSE RunFrom
			END
,	rpfd.ActiveFinished
,	rpfd.Service
,	rpfd.InactiveFinished
,	note = null
,	review_note = null
,	assigned_party = null
,	corrective_action = null
,	at_risk = 0 
,	percent_total = ris.OHQty / ris.TotalOHQty
,	RM_Net_104_WkDemand = coalesce(dd.RM_Net_104_WkDemand, 0)
,	Net_RM_104_Wk =
	CASE WHEN ris.TotalOHQty > dd.FG_Total_Demand THEN (ris.TotalOHQty - dd.FG_Total_Demand) * (ris.OHQty / ris.TotalOHQty)
		ELSE 
			CASE WHEN ris.OHQty > (ris.OHQty / ris.TotalOHQty) * coalesce(dd.RM_Net_104_WkDemand, 0)
					THEN ris.OHQty - (ris.OHQty / ris.TotalOHQty) * coalesce(dd.RM_Net_104_WkDemand, 0)
				ELSE 0
			END
		END
,	Net_RM_104_Wk_Material =
	CASE WHEN ris.TotalOHQty > dd.FG_Total_Demand THEN round( (ris.TotalOHQty - dd.FG_Total_Demand) * (ris.OHQty / ris.TotalOHQty),0)
		ELSE
			CASE WHEN ris.OHQty > (ris.OHQty / ris.TotalOHQty) * coalesce(dd.RM_Net_104_WkDemand, 0)
				THEN (ris.OHQty - (ris.OHQty / ris.TotalOHQty) * coalesce(dd.RM_Net_104_WkDemand, 0)) 
				ELSE 0
			END
		END * ris.MaterialAccum
,	dd.WeeksRemainProduction
,   ris.location
,   ris.objectbirthday
,   IsActive=1
FROM
	#rawInvSummary ris
	LEFT JOIN #DemandData dd
		ON dd.RM_Part = ris.RawPart
	LEFT JOIN #rawOnOrder roo
		ON roo.RMpart1 = ris.RawPart
	LEFT JOIN #rawPartsFinishedDescription rpfd
		ON rpfd.RawPart = ris.RawPart
	LEFT JOIN #demandSource ds
		ON ds.rm_part1 = ris.RawPart
	LEFT JOIN #lastMI lm
		ON lm.RawPart = ris.RawPart
ORDER BY
	3 DESC
,	1

			set    @Error = @@Error
            if     @Error != 0 begin
                    set    @Result = 900501
                    RAISERROR ('Error inserting in %s.  Error: %d while inserting row to table', 16, 1, @ProcName, @Error, 'TestPlan')
                    rollback tran @ProcName
                    return @Result
             end

/*Update Idle */
UPDATE revie
SET			 Idle_status= CASE WHEN datediff(day,objectbirthday,getdate())> 45 THEN 'Idle for more 45 days' ELSE '' END,
			Area= CASE WHEN revie.Location like 'LOSTt%' THEN 'LOST WAREHOUSE' 
						  WHEN revie.Location like '%FIS' THEN 'LOST WAREHOUSE' 
						  WHEN revie.Location like 'L-TRAN%' THEN 'LOST WAREHOUSE' 			 
						  WHEN revie.part  like '%-PT%' THEN 'Engineering Samples' 			 
						  WHEN revie.Location like 'TRAN%' and datediff(day,revie.last_date,getdate())>21 THEN 'LOST WAREHOUSE' 			 
													 ELSE '' END ,

													 Scheduler=isnull (po.buyer ,''),
													 Customer=SUBSTRING(revie.part,0,4)
													
FROM EEIUser.acctg_inv_age_review_Explotion revie LEFT JOIN monitor.dbo.po_header po 
			ON po.blanket_part =revie.part  
			
			WHERE asofdate = (SELECT MAX(asofdate) FROM eeiuser.acctg_inv_age_review)  

			set    @Error = @@Error
             if     @Error != 0 begin
                    set    @Result = 900501
                    RAISERROR ('Error updating in %s.  Error: %d while updating row to table', 16, 1, @ProcName, @Error, 'TestPlan')
                    rollback tran @ProcName
                    return @Result
              end
/*	Carry forward notes. */


UPDATE
	aiar
SET
	classification = aiarold.classification
,	note = aiarOld.note
,	review_note = aiarOld.review_note
,	assigned_party = aiarOld.assigned_party
,	corrective_action = aiarOld.corrective_action
,	at_risk = isnull(aiarOld.at_risk,0)

FROM
	EEIUser.acctg_inv_age_review_Explotion aiar
	JOIN EEIUser.acctg_inv_age_review_Explotion aiarOld
		ON aiarOld.asofdate =
			(	SELECT
					max(asofdate)
				FROM
					EEIUser.acctg_inv_age_review_Explotion
				WHERE
					asofdate < @TimeStamp
			)
		and aiarOld.receivedfiscalyear = aiar.receivedfiscalyear
		and aiarOld.receivedperiod = aiar.receivedperiod
		and aiarOld.part = aiar.Part
WHERE
	aiar.asofdate = @TimeStamp

			set    @Error = @@Error
             if     @Error != 0 begin
                    set    @Result = 900501
                    RAISERROR ('Error updating in %s.  Error: %d while updating row to table', 16, 1, @ProcName, @Error, 'TestPlan')
                    rollback tran @ProcName
                    return @Result
              end

--------------------------------------------------------------------------------------------------------------------------------------------------
/*  10. Delete previous snapshots if they were DAILY, just keed the Month End																	*/
--------------------------------------------------------------------------------------------------------------------------------------------------

IF	exists( 
			SELECT 	1
			FROM
				EEIUser.acctg_inv_age_review_Explotion
			WHERE IsActive=2) BEGIN


					UPDATE EEIUser.acctg_inv_age_review_Explotion 
					SET CategoryIdle=review2.CategoryIdle
					FROM (SELECT 	serial,CategoryIdle
							FROM
								EEIUser.acctg_inv_age_review_Explotion
							WHERE IsActive=2) review2
							WHERE EEIUser.acctg_inv_age_review_Explotion .serial=review2.serial and IsActive=1

			set    @Error = @@Error
             if     @Error != 0 begin
                    set    @Result = 900501
                    RAISERROR ('Error updating in %s.  Error: %d while updating row to table', 16, 1, @ProcName, @Error, 'TestPlan')
                    rollback tran @ProcName
                    return @Result
              end
		

				DELETE  FROM
								EEIUser.acctg_inv_age_review_Explotion
							WHERE IsActive=2

			set    @Error = @@Error
             if     @Error != 0 begin
                    set    @Result = 900501
                    RAISERROR ('Error deleting in %s.  Error: %d while deleting row to table', 16, 1, @ProcName, @Error, 'TestPlan')
                    rollback tran @ProcName
                    return @Result
              end


END


if	@TranCount = 0 begin
	commit transaction @ProcName
end
--- </Body>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>

/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go

declare
	@TimeStamp datetime

set	@TimeStamp = null

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FT.ftsp_InventoryGensis_Eric
	@TimeStamp = @TimeStamp
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

select
	*
from
	EEH.eeiuser.acctg_inv_age_review_Explotion aiar
where
	aiar.asofdate = '2011-12-31 23:52:00.937'
go

--commit
if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/







GO
