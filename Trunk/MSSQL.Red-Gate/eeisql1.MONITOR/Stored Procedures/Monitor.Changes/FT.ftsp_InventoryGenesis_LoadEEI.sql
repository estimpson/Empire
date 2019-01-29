SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [FT].[ftsp_InventoryGenesis_LoadEEI]
	@TimeStamp datetime = null
,	@RenameTimeStamp datetime = null
,	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_nulls on
set ansi_warnings on
set	@Result = 999999

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

set @TimeStamp = coalesce
	(	@TimeStamp
	,	(	select
				max(time_stamp)
			from
				[HistoricalData].dbo.object_historical_daily
			--where
			--	reason = 'MONTH END'
		)
	, getdate()
	)

Print @TimeStamp
--------------------------------------------------------------------------------------------------------------------------------------------------
/*  1. Get the Objects to evaulate																												*/
--------------------------------------------------------------------------------------------------------------------------------------------------
--declare @rawInvSummary table
create table	#rawInvSummary
(	AsofDate datetime
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
,	unique
	(	RawPart
	,	ReceivedFiscalYear
	,	ReceivedPeriod
	)
)

insert
	#rawInvSummary
(	AsofDate
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
)
select
	AsofDate = max(oh.time_stamp)
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
		(	select
				min(min_on_order)
			from
				part_vendor pv
			where
				pv.part = oh.part
				and pv.vendor = po.default_vendor
		)
,	MaterialAccum = max(psh.material_cum)
from
	[HistoricalData].dbo.object_historical_daily oh
	join [HistoricalData].dbo.part_standard_historical_daily psh
		on oh.Time_stamp = psh.time_stamp
		   and oh.part = psh.part
	join [HistoricalData].dbo.part_historical_daily ph
		on oh.Time_stamp = ph.time_stamp
		   and oh.part = ph.part
	left join part_inventory pi
		on oh.part = pi.part
	left join part_online po
		on oh.part = po.part
	left join location
		on oh.location = location.code
where
	oh.Time_stamp = @timestamp
	and ph.type = 'F'
	and oh.quantity > 0
--	and coalesce(location.secured_location,'N') != 'Y'
group by
	oh.part
--,	year(oh.object_received_date)
,	year(oh.objectbirthday)
--Last_Date
--,	month(oh.object_received_date)
,	month(oh.objectbirthday)
,	po.default_vendor

update
	ris
set TotalOHQty = (select sum(OHQty) from #rawInvSummary where RawPart = ris.RawPart)
from
--  @rawInvSummary ris (Table Variable version)
	#rawInvSummary ris

--select
--	*
--from
--	@rawInvSummary

/*	Get raw-finished xref. */
--declare	@rawFinX table
create table #rawFinX
(	RawPart varchar(25)
,	FinishedPart varchar(25)
,	XQty float not null
,	primary key
	(	RawPart
	,	FinishedPart
	)
)

-- insert @rawFinX -- table variable version
insert #rawFinX
select
	RawPart = xr.ChildPart
,	FinishedPart = xr.TopPart
,	XQty = sum(xr.XQty)
from
	FT.XRt xr
	join (	select distinct RawPart 
			from  #rawInvSummary ) ris
		on ris.RawPart = xr.ChildPart
	--join dbo.part pFin
	--	on pFin.part = xr.TopPart
	--	and pFin.Type = 'F'
	--	and pFin.Class = 'M'
group by
	xr.TopPart
,	xr.ChildPart

--select
--	*
--from
--	@rawFinX
--where
--	RawPart = '1013303'

/*	Get the End of Production data for Finished Good Base Parts.*/
--declare @BasePartEOP table -- table variable version
create table #BasePartEOP
(	BasePart char(7) primary key
,	EOP datetime
,	EOPWeeks int
)

-- insert @BasePartEOP
insert #BasePartEOP
(	BasePart
,	EOP
,	EOPWeeks
)
select
	BasePart = acvscd.base_part
,	EOP = max(acvscd.eop_display)
,	EOPWeeks =
	case
		when max(acvscd.eop_display) > dateadd(year, 2, getdate()) then 104
		when max(acvscd.eop_display) < getdate() then 0
		else datediff(week, getdate(), max(acvscd.eop_display))
	end
from
	(
		select	base_part, eop_display
		from	Monitor.EEIUser.acctg_csm_vw_select_sales_forecast acvscd

		union 

		select	base_part = left( part_number, 7), eop_display = Max(due_date) 
		from	order_detail
		where	quantity > 0
		group by  left( part_number, 7)
	) acvscd
--from
--	Monitor.EEIUser.acctg_csm_vw_select_sales_forecast acvscd
group by
	acvscd.base_part

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
create table #EEI_serviceForecast
(	ServiceBasePart varchar(25) primary key
,	ServicePart varchar(255) null
,	OnHand int null
,	CurrentYearSales int null
,	TotalDemand numeric(20,6)
)

--insert @EEI_serviceForecast
insert #EEI_serviceForecast
select distinct
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
from
	 MONITOR.EEIACCT.ServiceDemandForecast sdf

--declare	@demandSource table
create table #demandSource
(	rm_part1 varchar(50) not null
,	RunFrom varchar(100) null
,	primary key (rm_part1)
)

--insert	@demandSource
insert #demandSource
select
	rm_part1 = xr.ChildPart
,	RunFrom =
		case
			when
				max(sf.ServiceBasePart) is not null
				and max(fgDemand.FGDemandPart) is not null then 'Active MPS and Service List'
			when
				max(sf.ServiceBasePart) is null
				and max(fgDemand.FGDemandPart) is not null then 'Active MPS'
			when
				max(sf.ServiceBasePart) is not null
				and max(fgDemand.FGDemandPart) is null then 'Active Service List'
		end
from
	FT.XRt xr
	join dbo.part pRaw
		on pRaw.part = xr.ChildPart
		--and pRaw.type = 'R'
	left join #EEI_serviceForecast sf
		on sf.ServiceBasePart = left(xr.TopPart, 7)
	left join
	(	select
	 		FGDemandPart = od.part_number
	 	from
	 		dbo.order_detail od
	 	group by
	 		od.part_number
	) fgDemand
		on fgDemand.FGDemandPart = xr.TopPart
group by
	xr.ChildPart
having
	max(sf.ServiceBasePart) is not null
	or max(fgDemand.FGDemandPart) is not null
order by
	1, 2

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
create table #rawPartsFinishedDescription
(	RawPart varchar(25) primary key
,	ActiveFinished varchar(max)
,	Service varchar(max)
,	InactiveFinished varchar(max)
)

--declare	@rawDemand table
create table #rawDemand
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
insert #rawDemand
select
	RawPart = rfx.RawPart
,	FinishedPart = rfx.FinishedPart
,	Demand = coalesce(odDemand.Qty, 0)
,	ServiceForecast = coalesce(serviceForcast.TotalDemand, 0)
,	XQty = rfx.XQty
,	EOPDT = bpe.EOP
from
	#rawFinX rfx
	left join #BasePartEOP bpe
		on bpe.BasePart = left(rfx.FinishedPart, 7)
	left join
	(	select
	 		FinishedPart = od.part_number
	 	,	Qty = sum(od.quantity)
	 	from
	 		dbo.order_detail od
	 	where
	 		od.quantity > 0
	 	group by
	 		od.part_number
	) odDemand
		on odDemand.FinishedPart = rfx.FinishedPart
	left join
	(	select
			FG_Part = (select max(FinishedPart) from #rawFinX where left(FinishedPart, 7) = sf.ServiceBasePart)
		,	sf.TotalDemand
		from
			#EEI_serviceForecast sf
	) serviceForcast
		on serviceForcast.FG_Part = rfx.FinishedPart

declare
	rawParts cursor local for
select distinct
	RawPart
from
	#rawDemand

open rawParts

while
	1 = 1 begin
	
	declare
		@rawPart varchar(25)
	,	@activePartList varchar(4000)
	,	@servicePartList varchar(4000)
	,	@inactivePartList varchar(4000)
	
	fetch
		rawParts
	into
		@rawPart
	
	if	@@FETCH_STATUS != 0 begin
		break
	end
	
	set	@activePartList = ''
	set @servicePartList = ''
	set @inactivePartList = ''
	
	select
		@activePartList = @activePartList +
		'( ' + rd.FinishedPart +
			' Qty: ' + convert(varchar(12), convert(numeric(10,2), rd.XQty)) +
			' Dmd: ' + convert(varchar(12), convert(numeric(10,0), rd.Demand)) +
			' EOP: ' + coalesce(convert(varchar(12), rd.EOPDT, 101), 'N/A') +
		' )'
	from
		#rawDemand rd
	where
		rd.Demand > 0
		and rd.RawPart = @rawPart
	order by
		rd.FinishedPart
	
	select
		@servicePartList = @servicePartList +
		'( ' + rd.FinishedPart +
			' Qty: ' + convert(varchar(12), convert(numeric(10,2), rd.XQty)) +
			' Dmd: ' + convert(varchar(12), convert(numeric(10,0), rd.ServiceForecast)) +
			' EOP: ' + coalesce(convert(varchar(12), rd.EOPDT, 101), 'N/A') +
		' )'
	from
		#rawDemand rd
	where
		rd.ServiceForecast > 0
		and rd.RawPart = @rawPart
	order by
		rd.FinishedPart
	
	select
		@inactivePartList = @inactivePartList +
		'( ' + rd.FinishedPart +
			' Qty: ' + convert(varchar(12), convert(numeric(10,2), rd.XQty)) +
			' Dmd: 0' +
			' EOP: ' + coalesce(convert(varchar(12), rd.EOPDT, 101), 'N/A') +
		' ), '
	from
		#rawDemand rd
	where
		coalesce(rd.Demand, 0) <= 0
		and coalesce(rd.ServiceForecast, 0) <= 0
		and rd.RawPart = @rawPart
	order by
		rd.FinishedPart
	
	insert
		#rawPartsFinishedDescription
	select
		RawPart = @rawPart
	,	ActiveFinished = left(@activePartList, datalength(nullif(@activePartList, '')) - 2)
	,	Service = left(@servicePartList, datalength(nullif(@servicePartList, '')) - 2)
	,	InactiveFinished = left(@inactivePartList, datalength(nullif(@inactivePartList, '')) - 2)
end
close
	rawParts
deallocate
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
create table #BasePartDemand
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

insert	#BasePartDemand
select
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
from
	order_detail od
	left join
	(	select
			part
		,	sum(Quantity) as onHandQty
		from
			object
			left join location
				on object.location = location.code
		--where
		--	coalesce(nullif(secured_location,''),'N') != 'Y'
		group by
			part
	) o
		on od.part_number = o.part
where
	od.due_date >= dateadd(dd,-14,getdate())
	and od.due_date <= dateadd(wk,20,getdate())
group by
	od.part_number


update	#BasePartDemand
set		WeeksRemainProduction = case when EOPWeeks > 20 then 20 else EOPWeeks end
from	#BasePartDemand PartDemand
		join #BasePartEOP PartEOP on  PartEOP.BasePart = Left(PartDemand.FG_Part, 7)

-- todo requerimeitno menor a 1 por semana debe ser ignorado
update	#BasePartDemand
set		FG_20_Wk_Demand = case when FG_Avg_Wk_Demand <= 1 then 0 else FG_20_Wk_Demand end,
		FG_Avg_Wk_Demand = case when FG_Avg_Wk_Demand <= 1 then 0 else FG_Avg_Wk_Demand end,
		FG_Net_20_Wk_Demand = case when FG_Avg_Wk_Demand <= 1 then 0 else FG_Net_20_Wk_Demand end


update	#BasePartDemand
set		FG_Net_Avg_Wk_Demand = FG_Net_20_Wk_Demand / WeeksRemainProduction,
		FG_Avg_Wk_Demand = FG_20_Wk_Demand / WeeksRemainProduction
where	WeeksRemainProduction > 0

--select
--	*
--from
--	@BasePartDemand

--------------------------------------------------------------------------------------------------------------------------------------------------
/*  4. Calculate the RM Demand																													*/
--------------------------------------------------------------------------------------------------------------------------------------------------
--declare	@DemandData table
create table #DemandData
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

insert
	#DemandData
select
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
from
	(	select
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
		from
			(	select
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
				from
					#BasePartDemand bpd
					left join #rawFinX rfx
						on bpd.FG_Part = rfx.FinishedPart
					left join #BasePartEOP bpe
						on bpe.BasePart = left(bpd.FG_Part, 7)
			) prodDemand -- Get the total demand from orders.
			full join
			(	select
					RM_Part = rfx.RawPart
				,	FG_Part = rfx.FinishedPart
				,	XQty = rfx.XQty
				,	FG_Total_Demand = (sf.TotalDemand * rfx.XQty)
				from
					#EEI_serviceForecast sf
					left join #rawFinX rfx
						on left (rfx.FinishedPart, 7) = sf.ServiceBasePart
						and rfx.FinishedPart =
							(	select
									max(FinishedPart)
								from
									#rawFinX
								where
									sf.ServiceBasePart = left(FinishedPart, 7)
							)
			) serviceDemand -- Get the total demand from service forecast.
			on prodDemand.RM_Part = serviceDemand.RM_Part
			and prodDemand.FG_Part = serviceDemand.FG_Part
	) a
group by
	RM_Part

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
create table #rawOnOrder
(	RMPart1 varchar(25)
,	QtyOnOrder numeric(18,6)
)

insert
	#rawOnOrder
select
	part_number as RMPart1
,	sum(pd.quantity)
from
	dbo.po_detail pd
where
	part_number in
	(	select
			RawPart
		from
			#rawInvSummary ris
	)
group by
	part_number

--select
--	*
--from
--	@rawOnOrder
--where
--	RMPart1 = '1013303'

/*	Get the last material issue for every part. */
--declare @lastMI table
create table #lastMI
(	RawPart varchar(25) primary key
,	LastTranDT datetime
)

insert
	#lastMI
select
	RawPart = atMI.part
,	LastTranDT = max(atMI.date_stamp)
from
	audit_trail atMI with (readuncommitted)
	join part pRaw with (readuncommitted)
		on pRaw.part = atMI.part
		and pRaw.type = 'R'
where
	atMI.type = 'M'
group by
	atMI.part

--select
--	*
--from
--	@lastMI

--------------------------------------------------------------------------------------------------------------------------------------------------
/*  9. Get the Inactive programs where no finished demand is associated with these programs	but the part is on the finished good BOM			*/
--------------------------------------------------------------------------------------------------------------------------------------------------
if	@RenameTimeStamp is not null begin
	update
		aiar
	set
		asofdate = @RenameTimeStamp
	from
		EEIUser.acctg_inv_age_review aiar
	where
		aiar.asofdate = @TimeStamp
end

--select	*
--from	#rawInvSummary

insert
	MONITOR.eeiuser.acctg_inv_age_review
(	asofdate
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
)
select
	ris.AsOfDate
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
	case
		when (ris.OHQty / ris.TotalOHQty) * ris.OHQty / nullif(dd.RM_Net_avg_Wk_demand, 0) < (28000 / 7) then dateadd(day, ((ris.OHQty / ris.TotalOHQty) * ris.OHQty / dd.RM_Net_avg_Wk_Demand) * 7, ris.AsOfDate)
		else '2100-01-01'
	end
,	classification = null
,	on_hold = null
,	coalesce(ds.RunFrom, 'Obsolete') as RunFrom
,	lm.LastTranDT
,	Category =		case
					when coalesce(ds.RunFrom, 'obsolete') = 'obsolete' 
						then
							case
							when datediff(day, lm.LastTranDT, ris.AsOfDate) > 365 
								then 'Obsolete > 365 days'
							else 'Obsolete < 365 days' end
					else RunFrom
			end
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
	case when ris.TotalOHQty > dd.FG_Total_Demand then (ris.TotalOHQty - dd.FG_Total_Demand) * (ris.OHQty / ris.TotalOHQty)
		else 
			case when ris.OHQty > (ris.OHQty / ris.TotalOHQty) * coalesce(dd.RM_Net_104_WkDemand, 0)
					then ris.OHQty - (ris.OHQty / ris.TotalOHQty) * coalesce(dd.RM_Net_104_WkDemand, 0)
				else 0
			end
		end
,	Net_RM_104_Wk_Material =
	case when ris.TotalOHQty > dd.FG_Total_Demand then round( (ris.TotalOHQty - dd.FG_Total_Demand) * (ris.OHQty / ris.TotalOHQty),0)
		else 
			case when ris.OHQty > (ris.OHQty / ris.TotalOHQty) * coalesce(dd.RM_Net_104_WkDemand, 0)
				then (ris.OHQty - (ris.OHQty / ris.TotalOHQty) * coalesce(dd.RM_Net_104_WkDemand, 0)) 
				else 0
			end
		end * ris.MaterialAccum
,	dd.WeeksRemainProduction
from
	#rawInvSummary ris
	left join #DemandData dd
		on dd.RM_Part = ris.RawPart
	left join #rawOnOrder roo
		on roo.RMpart1 = ris.RawPart
	left join #rawPartsFinishedDescription rpfd
		on rpfd.RawPart = ris.RawPart
	left join #demandSource ds
		on ds.rm_part1 = ris.RawPart
	left join #lastMI lm
		on lm.RawPart = ris.RawPart
order by
	3 desc
,	1

/*	Carry forward notes. */
update
	aiar
set
	classification = aiarold.classification
,	note = aiarOld.note
,	review_note = aiarOld.review_note
,	assigned_party = aiarOld.assigned_party
,	corrective_action = aiarOld.corrective_action
,	at_risk = isnull(aiarOld.at_risk,0)
from
	EEIUser.acctg_inv_age_review aiar
	join EEIUser.acctg_inv_age_review aiarOld
		on aiarOld.asofdate =
			(	select
					max(asofdate)
				from
					EEIUser.acctg_inv_age_review
				where
					asofdate < @TimeStamp
			)
		and aiarOld.receivedfiscalyear = aiar.receivedfiscalyear
		and aiarOld.receivedperiod = aiar.receivedperiod
		and aiarOld.part = aiar.Part
where
	aiar.asofdate = @TimeStamp

	declare	@PreviousRun datetime


--------------------------------------------------------------------------------------------------------------------------------------------------
/*  10. Delete previous snapshots if they were DAILY, just keed the Month End																	*/
--------------------------------------------------------------------------------------------------------------------------------------------------

select	@PreviousRun = max(asofdate)
from
	EEIUser.acctg_inv_age_review
where
	asofdate < @TimeStamp

if	exists( 
			select	1
			from
				[HistoricalData].dbo.object_historical_daily
			where time_stamp = @PreviousRun
					and reason = 'DAILY' ) begin
		delete from EEIUser.acctg_inv_age_review where	asofdate = @PreviousRun

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
	EEH.eeiuser.acctg_inv_age_review aiar
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
