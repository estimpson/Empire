SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






-- [FT].[ftsp_InventoryGenesis_Dan] 


CREATE proc [FT].[ftsp_InventoryGenesis_dan] 
as

--------------------------------------------------------------------------------------------------------------------------------------------------
/*  1. Get the Objects to evaulate																												*/
--------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE	@RawInvSummary table
			(	AsofDate datetime
				,ReceivedFiscalYear int
				,ReceivedPeriod int			
				,DefaultVendor varchar(50)
				,Part varchar(25)
				,PartName varchar(100)
				,Commodity varchar(30)
				,Quantity numeric (20,6)
				,ExtMaterialCum numeric(20,6)
				,StdPack numeric(20,6)
				,MinOrderQty numeric(20,6)
				,primary key (part, asofdate, receivedfiscalyear, receivedperiod)
			)
			
INSERT	@rawinvSummary		
					
	SELECT		oh.time_stamp as AsofDate
				,YEAR(oh.object_received_date) as ReceivedFiscalYear
				,MONTH(oh.object_received_date) as ReceivedPeriod
				,po.default_vendor		
				,oh.part
				,ph.name
				,ph.commodity				
				,sum(oh.quantity) as quantity
				,sum((oh.quantity*psh.material_cum)) as ext_material_cum
				,MAX(standard_pack) as StdPack
				,(SELECT MIN(min_on_order) FROM part_vendor pv WHERE pv.part = oh.part AND pv.vendor = po.default_vendor) AS MinOrderQtyPrimaryVendor	
			
	FROM		object_historical oh
					JOIN part_standard_historical psh on oh.Time_stamp = psh.time_stamp and oh.part = psh.part
					JOIN part_historical ph on oh.Time_stamp = ph.time_stamp and oh.part = ph.part
					LEFT JOIN part_inventory pi on oh.part = pi.part
					LEFT JOIN part_online po on oh.part = po.part
					LEFT JOIN location on oh.location = location.code

	WHERE		oh.Time_stamp in (Select max(time_stamp) from object_historical where reason = 'MONTH END')	
			and ph.type = 'R'	
			and oh.quantity > 0	
--			and isnull(location.secured_location,'N') != 'Y'

	GROUP BY	ph.type
				,oh.time_stamp 
				,oh.fiscal_year 
				,oh.period 
				,YEAR(oh.object_received_date) 
				,MONTH(oh.object_received_date) 
				,po.default_vendor		
				,oh.part
				,ph.name
				,ph.commodity
				
--select * From @RawInvSummary

		
--------------------------------------------------------------------------------------------------------------------------------------------------
/*  2. Get the FG Demand (via EEH's order_detail)																								*/
--------------------------------------------------------------------------------------------------------------------------------------------------
 
DECLARE @BasePartDemand TABLE 
			(	FG_Part varchar(25),
				FG_20_Wk_Demand	numeric(20,6),
				FG_Avg_Wk_Demand	numeric(20,6), 
				FG_On_Hand	numeric(20,6),
				FG_Net_20_Wk_Demand	numeric(20,6),
				FG_Net_Avg_Wk_Demand numeric(20,6) PRIMARY KEY (FG_Part)
			)

INSERT	@BasePartDemand
      
	SELECT		od.part_number as FG_Part
				,sum(od.quantity)as FG_20_Wk_Demand
				,(SUM(od.quantity)/20)as FG_Avg_Wk_Demand
				,ISNULL(max(onHandQty),0) as FG_On_Hand
				,(CASE WHEN (sum(od.quantity) - IsNull(MAX(o.OnHandQty),0)) < 0 THEN 0 ELSE (Sum(od.quantity) - isNull(MAX(o.OnHandQty),0)) END )as FG_Net_20_Wk_Demand
				,(CASE WHEN (sum(od.quantity) - IsNull(MAX(o.OnHandQty),0)) < 0 THEN 0 ELSE (Sum(od.quantity) - isNull(MAX(o.OnHandQty),0)) END )/20 as FG_Net_Avg_Wk_Demand
	      
	FROM		order_detail od 
					left join (select part, sum(quantity) as onHandQty from object left join location on object.location = location.code where ISNULL(nullif(secured_location,''),'N') != 'Y' group by part) o
					on od.part_number = o.part
					
	WHERE		od.due_date >= DATEADD(dd,-14,GETDATE())
			and od.due_date <= DATEADD(wk,20,GETDATE())
			
	GROUP BY	od.part_number 						    
							    
--select * from @basepartdemand order by fg_part

--------------------------------------------------------------------------------------------------------------------------------------------------
/*  3. Get the RM BOM Qty per FG																												*/
--------------------------------------------------------------------------------------------------------------------------------------------------
 
DECLARE	@FlatRawBOM table
			(	FG_Part varchar(25),
				RM_Part varchar(25),
				BomQty numeric(20,6)
			)

INSERT @FlatRawBOM

	select		finishedpart as FG_Part
				,rawpart as RM_Part
				,quantity as BomQty
	
	from		vweeibom
	
	where		RawPart in	(	select	Part
								from	@RawInvSummary
							)
			
-- select * from @flatrawbom


--------------------------------------------------------------------------------------------------------------------------------------------------
/*  4. Calculate the RM Demand																													*/
--------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE	@demanddata table
	(	RM_Part varchar(50),
		FG_On_Hand numeric(18,6),
		FG_Net_20_Wk_Demand numeric(18,6),
		FG_Net_Avg_Wk_Demand numeric(18,6),
		BOMQty numeric(18,6),
		RM_Net_20_Wk_Demand numeric(18,6),
		RM_Net_Avg_Wk_Demand numeric(18,6)
	)
	
INSERT @demanddata

	select		RM_Part
				,SUM(FG_On_Hand) as FG_On_Hand
				,SUM(FG_Net_20_Wk_Demand) as FG_Net_20_Wk_Demand
				,SUM(FG_Net_Avg_Wk_Demand) as FG_Net_Avg_Wk_Demand
				,AVG(BOMQty) as BomQty
				,SUM(RM_Net_20_Wk_Demand) as RM_Net_20_Wk_Demand
				,SUM(RM_Net_Avg_Wk_Demand) as RM_Net_Avg_Wk_Demand
				
	from		(	select		frb.RM_Part
								,bpd.FG_Part
								,bpd.FG_On_Hand
								,bpd.FG_Net_20_Wk_Demand
								,bpd.FG_Net_Avg_Wk_Demand
								,frb.BomQty
								,(bpd.FG_Net_20_Wk_Demand*frb.BomQty) as RM_Net_20_Wk_Demand
								,(bpd.FG_Net_Avg_Wk_Demand*frb.BomQty) as RM_Net_Avg_Wk_Demand

					from		@BasePartDemand bpd
									left join	@FlatRawBOM frb on bpd.FG_Part = frb.FG_Part
				) a
	group by	RM_Part
				
-- select * from @demanddata


--------------------------------------------------------------------------------------------------------------------------------------------------
/*  5. Get the RM on order																														*/
--------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @Rawonorder table
			(	RMPart1 varchar(25)
				,qtyonorder numeric(18,6)
			)

INSERT @Rawonorder
	
	select		part_number as RMPart1
				,SUM(quantity)
				
	from		po_detail
	where		part_number in		(	select	part
										from	@rawinvsummary
									)
	group by	part_number

-- select * from @rawonorder


--------------------------------------------------------------------------------------------------------------------------------------------------
/*  6. Get the active programs and the finished demand associated with these programs															*/
--------------------------------------------------------------------------------------------------------------------------------------------------

declare @rawpartfinishedpartsactive table
			(	rawpart varchar(25) NOT NULL
				,finishedpart varchar(100) NOT NULL
				,quantity numeric (38,12) NULL
				,primary key (rawpart, finishedpart)
			)

insert	@rawpartfinishedpartsactive

	SELECT	RawPart,
			'( '+ FinishedPart + ' Qty: '+ CONVERT(VARCHAR(20),CONVERT(DECIMAL(10,2),Quantity))+
			' Dmd: '+(CONVERT(VARCHAR(20),CONVERT(DECIMAL(10,0),ISNULL((SELECT SUM(quantity) FROM order_detail WHERE part_number = FinishedPart),0) ))) + ' )',
			Quantity
	FROM	[dbo].[vweeiBOM]
	where	FinishedPart in (select distinct(part_number) from order_detail where quantity >0)

--select * from @rawpartfinishedpartsactive


declare	@RawPart varchar(25),
		@FinishedPartList varchar(1000)

declare @FlatFinishedGoods table 
			(	RawPart	varchar(25),
				FinishedParts	varchar(1000)
			)

declare	Rawpartlist cursor local for
	select	distinct RawPart 
	from	@rawpartfinishedpartsactive
open	Rawpartlist 
fetch	Rawpartlist into	@RawPart

While		 @@fetch_status = 0
Begin	
Select	@FinishedPartList  = ''


Select		@FinishedPartList = @FinishedPartList + FinishedPart +', '
from		@rawpartfinishedpartsactive
where		RawPart = @RawPart
group by	FinishedPart



insert	@FlatFinishedGoods
Select	@Rawpart,
		@FinishedPartList
		
		

fetch	Rawpartlist into	@RawPart

END


declare @flatfinishedpartactive table
			(	rawpart2 varchar(25) NOT NULL
				,finihedParts1 varchar(MAX) NULL
				,primary key (rawpart2)
			)

insert	@flatfinishedpartactive
Select	RawPart,
		left(FinishedParts,datalength(FinishedParts)-2)
	
from		@FlatFinishedGoods

--Select	* FROM	@flatfinishedpartactive



--------------------------------------------------------------------------------------------------------------------------------------------------
/*  7. Get the inactive programs where no finished demand is associated with these programs	but the part is on the finished good BOM			*/
--------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @rawpartfinishedpartsinactive table
			(	rawpart varchar(25) NOT NULL
				,finishedpart varchar(100) NOT NULL
				,quantity numeric (38,12) NULL
				,primary key (rawpart, finishedpart)
			)

INSERT	@rawpartfinishedpartsinactive

	SELECT	RawPart,
			'( '+ FinishedPart + ' Qty: '+ CONVERT(VARCHAR(20),CONVERT(DECIMAL(10,2),Quantity))+
			' Dmd: '+(CONVERT(VARCHAR(20),CONVERT(DECIMAL(10,0),ISNULL((SELECT SUM(quantity) FROM order_detail WHERE part_number = FinishedPart),0) ))) + ' )',
			Quantity
	FROM	[dbo].[vweeiBOM]
	where	FinishedPart not in (select distinct(part_number) from order_detail where quantity > 0)

--select * from @rawpartfinishedpartsinactive


declare	@RawPartinactive varchar(25),
		@FinishedPartListinactive varchar(1000)

declare @FlatFinishedGoodsinactive table 
			(	RawPart	varchar(25),
				FinishedParts	varchar(1000)
			)

declare	Rawpartlistinactive cursor local for
	select	distinct RawPart 
	from	@rawpartfinishedpartsinactive
open	Rawpartlistinactive 
fetch	Rawpartlistinactive into	@RawPartinactive

While		 @@fetch_status = 0
Begin	
Select	@FinishedPartListinactive  = ''

Select		@FinishedPartListinactive = @FinishedPartListinactive + FinishedPart +', '
from		@rawpartfinishedpartsinactive
where		RawPart = @RawPartinactive
group by	FinishedPart

insert	@FlatFinishedGoodsinactive
Select	@Rawpartinactive,
		@FinishedPartListinactive
		
fetch	Rawpartlistinactive into	@RawPartinactive

END


declare @flatfinishedpartinactive table
			(	rawpart3 varchar(25) NOT NULL
				,finihedParts2 varchar(MAX) NULL
				,primary key (rawpart3)
			)

insert	@flatfinishedpartinactive
Select	RawPart,
		left(FinishedParts,datalength(FinishedParts)-2)
	
from		@FlatFinishedGoodsinactive

--Select	* FROM	@flatfinishedpartinactive


--------------------------------------------------------------------------------------------------------------------------------------------------
/*  8. Get the inactive programs where no finished demand is associated with these programs	but the part is on the finished good BOM			*/
--------------------------------------------------------------------------------------------------------------------------------------------------

declare @demandsource table
( rm_part1 varchar(50) NOT NULL
, runfrom varchar(100) NULL
, primary key (rm_part1)
)

insert @demandsource

SELECT	distinct mps.part
						,runfrom='Active MPS'
				FROM	master_prod_sched mps inner join part p on mps.part=p.part 
				WHERE	p.type='r' 
				UNION
				SELECT	distinct x.ChildPart
						,runfrom='Active service list'
				FROM	Monitor.ft.xrt x inner join part p on x.childpart=p.part
				WHERE	x.TopPart in ( select part from eeisql1.monitor.dbo.part_eecustom where isnull(ServicePart,'N') = 'Y' )
						and p.type='r'
						and x.ChildPart not in (	SELECT	distinct mps.part
													FROM	master_prod_sched mps inner join part p on mps.part=p.part 
													WHERE	p.type='r' 
												)


--------------------------------------------------------------------------------------------------------------------------------------------------
/*  9. Get the inactive programs where no finished demand is associated with these programs	but the part is on the finished good BOM			*/
--------------------------------------------------------------------------------------------------------------------------------------------------


insert into EEH.eeiuser.acctg_inv_age_review

select	AsofDate
		,receivedfiscalyear
		,ReceivedPeriod
		,DefaultVendor
		,aaa.part
		,partname
		,commodity
		,quantity
		,extmaterialcum
		,stdpack
		,minorderqty
		,NULL
		,NULL	
		,FG_On_Hand
		,FG_Net_20_Wk_Demand
		,FG_Net_Avg_Wk_Demand
		,RM_Net_20_Wk_Demand
		,RM_Net_Avg_Wk_Demand
		,NULLIF((Case when ISNULL(RM_Net_Avg_Wk_Demand,0) = 0 then NULL else (quantity/RM_Net_avg_Wk_Demand) end),NULL) as Weeks_to_Exhaust
		,NULLIF((Case when ISNULL(RM_Net_Avg_Wk_Demand,0) = 0 then '2100-01-01' else (Case when (quantity/RM_Net_avg_Wk_demand) < (28000/7) then dateadd(d,(quantity/RM_Net_avg_Wk_Demand)*7,AsofDate) else '2100-01-01' end) end),NULL) as Exhaust_Date
		,NULL
		,NULL
		,ISNULL(runfrom,'Obsolete') as runfrom
		,maxdateMi
		,(case when ISNULL(runfrom,'obsolete')='obsolete' then 'Investigating' else (case when datediff(d,maxdateMi,getdate())>365 then 'Obsolete > 365 days' else 'Inactive < 365 days' end) end) as new_status
		,finihedParts1 as active_where_used
		,finihedParts2 as inactive_where_used
		,NULL
		,NULL
		,NULL
		
		
	
from
		(	select * from @RawInvSummary ris
 				left join @demanddata dd on ris.part = dd.RM_Part
				left join @rawonorder roo on ris.Part = roo.RMpart1	
				left join @flatfinishedpartactive ffpa on ris.Part = ffpa.rawpart2
				left join @FlatFinishedpartinactive ffpi on ris.Part = ffpi.rawpart3
				left join @demandsource ds on ris.Part = ds.rm_part1
				) aaa


left join	(	select	a.part,
						max(a.date_stamp) as maxdateMi 
				from	audit_trail a inner join part p on a.part=p.part 
				where	p.type='r' 
					and a.type='m'
				group by a.part
			) cc on aaa.Part = cc.part
				


order by 3 desc, 1	



--create index ix_audit_trail_toloc_type_fromloc on dbo.audit_trail (to_loc, type, from_loc)
--create index ix_audit_trail_serial_type_date_stamp on dbo.audit_trail (serial, type, date_stamp)







GO
