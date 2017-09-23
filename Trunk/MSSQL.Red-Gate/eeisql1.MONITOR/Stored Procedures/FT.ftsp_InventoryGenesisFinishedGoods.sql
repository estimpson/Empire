SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





-- [FT].[ftsp_InventoryGenesisFinishedGoods] 


CREATE proc [FT].[ftsp_InventoryGenesisFinishedGoods] 
as

--------------------------------------------------------------------------------------------------------------------------------------------------
/*  1. Get the Objects to evaulate																												*/
--------------------------------------------------------------------------------------------------------------------------------------------------
DECLARE	@SerialGenesis table ( 
			Serial int PRIMARY KEY,
			Date_Stamp datetime,
			type char(1) )
INSERT	@SerialGenesis
        ( Serial ,
          Date_Stamp,
          type
        )
SELECT	Serial
		,isnull((select min(date_stamp) from audit_trail where serial = oh.Serial and type in ('R', 'A', 'B', 'J', 'H')),'2005-01-01')
		,isnull((select min(type) from audit_trail where serial = oh.Serial and date_stamp = (select min(date_stamp) from audit_trail where serial = oh.Serial and type in ('R', 'A', 'B', 'J', 'H')) AND type in ('R', 'A', 'B', 'J', 'H')),'L')
FROM	dbo.object_historical oh
WHERE	ISNULL(oh.quantity,0) > 0 and
		part != 'PALLET' AND
		oh.Time_stamp = (Select max(time_stamp) from object_historical where reason = 'MONTH END')
ORDER BY 2


DECLARE	@FinInvSummary table
			(	AsofDate datetime
				,ReceivedFiscalYear int
				,ReceivedPeriod int			
				,DefaultVendor varchar(50)
				,Part varchar(25)
				,PartName varchar(100)
				,ProductLine varchar(30)
				,Quantity numeric (20,6)
				,ExtMaterialCum numeric(20,6)
				,StdPack numeric(20,6)
				,primary key (part, asofdate, receivedfiscalyear, receivedperiod)
			)
			
INSERT	@FinInvSummary		
					
	SELECT		oh.time_stamp as AsofDate
				,YEAR(sg.date_stamp) as ReceivedFiscalYear
				,MONTH(sg.date_stamp) as ReceivedPeriod
				,po.default_vendor		
				,oh.part
				,ph.name
				,ph.product_line				
				,sum(oh.quantity) as quantity
				,sum((oh.quantity*psh.material_cum)) as ext_material_cum
				,MAX(standard_pack) as StdPack
				
			
	FROM		object_historical oh
					JOIN @SerialGenesis sg ON oh.serial = sg.Serial
					JOIN part_standard_historical psh on oh.Time_stamp = psh.time_stamp and oh.part = psh.part
					JOIN part_historical ph on oh.Time_stamp = ph.time_stamp and oh.part = ph.part
					LEFT JOIN part_inventory pi on oh.part = pi.part
					LEFT JOIN part_online po on oh.part = po.part
					LEFT JOIN location on oh.location = location.code

	WHERE		oh.Time_stamp in (Select max(time_stamp) from object_historical where reason = 'MONTH END')	
			and ph.type = 'F'	
			and oh.quantity > 0	
--			and isnull(location.secured_location,'N') != 'Y'

	GROUP BY	ph.type
				,oh.time_stamp 
				,oh.fiscal_year 
				,oh.period 
				,YEAR(sg.date_stamp) 
				,MONTH(sg.date_stamp) 
				,po.default_vendor		
				,oh.part
				,ph.name
				,ph.product_line
				
--select * From @FinInvSummary

		
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

	select		DISTINCT part as FG_Part
				,part as RM_Part
				,1 as BomQty
	
	from		@FinInvSummary
	

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
										from	@FinInvSummary
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

	SELECT	RM_part,
			'( '+ FG_Part + ' Qty: '+ CONVERT(VARCHAR(20),CONVERT(DECIMAL(10,2),1))+
			' Dmd: '+(CONVERT(VARCHAR(20),CONVERT(DECIMAL(10,0),ISNULL((SELECT SUM(quantity) FROM order_detail WHERE part_number = FG_Part),0) ))) + ' )',
			1
	FROM	@FlatRawBOM
	where	FG_Part in (select distinct(part_number) from order_detail where quantity >0)

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
				,finihedParts1 varchar(255) NULL
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

		SELECT	RM_part,
			'( '+ FG_Part + ' Qty: '+ CONVERT(VARCHAR(20),CONVERT(DECIMAL(10,2),1))+
			' Dmd: '+(CONVERT(VARCHAR(20),CONVERT(DECIMAL(10,0),ISNULL((SELECT SUM(quantity) FROM order_detail WHERE part_number = FG_Part),0) ))) + ' )',
			1
	FROM	@FlatRawBOM
	where	FG_Part NOT in (select distinct(part_number) from order_detail where quantity >0)


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
				,finihedParts2 varchar(255) NULL
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

/*declare @demandsource table
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
				WHERE	x.TopPart in ('TRW0012-HD01','TRW0088-HG02','TRW0096-HA01','TRW0275-HD01','VSL0107-HC01','MER0015-HB03','MER0026-HC02','FNG0042-HC00','RMP0019-HB01','DEN0003-HE00','ALC0001-HF13','ALC0016-HE10','ALC0023-HC00','ALC0024-HD01','ALC0086-HB07S','ALC0095-HB01S','ALC0117-HA09S','ALC0126-HB05S','ALC0166-HA03','GRD0013-HC01','NAL0025-HB04','NAL0027-HA06','NAL0028-HA07','RMP0020-HC00','AUT0009-HA04','AUT0024-HD02','AUT0035-HF05S','AUT0036-HF05S','AUT0037-HF05S','AUT0038-HF05S','AUT0043-HC12','AUT0048-HA02','AUT0063-HA04','AUT3254-DSA02','DAT0001-HF01','DAT0027-HD01','DAT0028-HC01','DEC0002-HB03','FRD0025-HA01S','FRD4200-HA00','GMC0018-HA00','GMC0024-HA00','GMC0043-HA03','GMC0044-HA01','GMC0068-HA00','GMC0078-HA00','GMC0079-HA01','GMC0080-HA01','GMC0084-HA03','GMC0089-HA00','GMS0001-HA02','INA0201-HD00','VAL0115-HB01','VAL0131-HB01','VAL0156-HA02','VAL0159-HC02','VAL0241-HA00S','VIS0085-HB00','VPP0119-HA04','VPP0167-HB02','VSL0124-HA03','VSL0170-HA03','WEB5400-HA00')
					and p.type='r'
					and x.ChildPart not in (	SELECT	distinct mps.part
												FROM	master_prod_sched mps inner join part p on mps.part=p.part 
												WHERE	p.type='r' 
											)

*/
--------------------------------------------------------------------------------------------------------------------------------------------------
/*  9. Get the inactive programs where no finished demand is associated with these programs	but the part is on the finished good BOM			*/
--------------------------------------------------------------------------------------------------------------------------------------------------

--insert into eeiuser.acctg_inv_age_review

select	AsofDate
		,receivedfiscalyear
		,ReceivedPeriod
		,DefaultVendor
		,aaa.part
		,partname
		,ProductLine
		,quantity
		,extmaterialcum
		,stdpack
		,NULL
		,NULL
		,NULL	
		,FG_On_Hand
		,FG_Net_20_Wk_Demand
		,FG_Net_Avg_Wk_Demand
		,RM_Net_20_Wk_Demand
		,RM_Net_Avg_Wk_Demand
		,NULLIF((Case when ISNULL(RM_Net_Avg_Wk_Demand,0) = 0 then NULL else (quantity/RM_Net_avg_Wk_Demand) end),NULL) as Weeks_to_Exhaust
		,NULLIF((Case when ISNULL(RM_Net_Avg_Wk_Demand,0) = 0 then '2100-01-01' else dateadd(d,(quantity/RM_Net_avg_Wk_Demand)*7,AsofDate) end),NULL) as Exhaust_Date
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,finihedParts1 as active_where_used
		,finihedParts2 as inactive_where_used
		,NULL
		,NULL
		,NULL
		
		
	
from
		(	select * from @FinInvSummary ris
 				left join @demanddata dd on ris.part = dd.RM_Part
				left join @rawonorder roo on ris.Part = roo.RMpart1	
				left join @flatfinishedpartactive ffpa on ris.Part = ffpa.rawpart2
				left join @FlatFinishedpartinactive ffpi on ris.Part = ffpi.rawpart3
		) aaa


				


order by 3 desc, 1	



--create index ix_audit_trail_toloc_type_fromloc on dbo.audit_trail (to_loc, type, from_loc)
--create index ix_audit_trail_serial_type_date_stamp on dbo.audit_trail (serial, type, date_stamp)






GO
