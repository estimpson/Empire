SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [FT].[ftsp_InventoryGenesis] (@FromDate datetime, @ToDate datetime)
as

declare	@RawInv table
(	ObjectSerial int primary key,
	ParentSerial varchar(25),
	ObjectReceiveDT datetime,
	FindRoot tinyint,
	Part varchar(25),
	unique (ObjectReceiveDT, ObjectSerial))

insert
	@RawInv
select
	ObjectSerial = serial
,	ParentSerial = convert (int, null)
,	ObjectReceiveDT = convert (datetime, null)
,	FindRoot = 1
,	Part = o.part
from
	dbo.object o
where	
	o.quantity>0 and
	part in
	(	select
			part
		from
			dbo.part p
		where
			type = 'R')

while
	@@rowcount > 0 begin
	update
		@RawInv
	set
		FindRoot = 0
	where
		FindRoot = 2
	
	update
		@RawInv
	set
		FindRoot = 2
	where
		FindRoot = 1
	
	update
		@RawInv
	set
		ParentSerial =
			case when isnumeric(breaks.from_loc) = 1 then breaks.from_loc end
	,	FindRoot = 1
	from
		@RawInv r
		join dbo.audit_trail breaks on
			breaks.type = 'B' and
			breaks.serial = coalesce(r.ParentSerial, r.ObjectSerial) and
			isnumeric(breaks.from_loc) = 1 and
			breaks.from_loc != breaks.to_loc and
			breaks.from_loc not like '%d%' and
			breaks.from_loc not like '%e%'
	where
		r.FindRoot = 2
end	

update
	@RawInv
set
	ObjectReceiveDT = isnull((select min(date_stamp) from audit_trail where serial = coalesce(ParentSerial, ObjectSerial) and type in ('R', 'A', 'E')),'2005-01-01')

declare	@RawInvSummary table
(	Part varchar(25),
	Quantity numeric (20,6),
	ExtendedCost numeric(20,6),
	StdPack numeric(20,6),
	MinOrderQty numeric(20,6)
	unique (Part))
Insert @RawInvSummary
select
	Object.part,
	SUM(std_quantity) as Quantity,
	SUM(std_quantity*cost_cum) as ExtendedCost,
	MAX(standard_pack) AS StdPack,
	(SELECT MIN(min_on_order) FROM part_vendor pv WHERE pv.part = part_online.part AND pv.vendor = part_online.default_vendor) AS MinOrderQtyPrimaryVendor
	
from
	@RawInv RawInv
Join	object on RawInv.ObjectSerial = Object.Serial
Join	part_standard on object.part = part_standard.part
JOIN	part_inventory ON part_standard.part = dbo.part_inventory.part
JOIN	part_online On part_inventory.part = dbo.part_online.part
LEFT join	location on object.location = location.code
Where	ObjectReceiveDT>= @FromDate and ObjectReceiveDT < @ToDate 
	and isnull(location.secured_location,'N') != 'Y'
Group by object.part,
			part_online.part,
			default_vendor
	

	
declare	@FlatRawBOM table
(	BasePart varchar(25),
	ChildPart varchar(25),
	BomQty numeric(20,6))

Insert @FlatRawBOM

select
	LEFT(TopPart,7) as BasePart,
	ChildPart,
	XQty as BomQty
from
	FT.XRt xr
where
	TopPart in
	(	select
			part
		from
			[EEISQL1].monitor.dbo.part_eecustom
		where
			CurrentRevLevel = 'Y') 
and
	ChildPart in
	(	select
			Part
		from
			@RawInv)
			


declare	@FlatRawBOMSummary table
(	BasePart varchar(25),
	ChildPart varchar(25),
	BomQty numeric(20,6))

Insert @FlatRawBOMSummary

Select	BasePart,
	ChildPart,
	SUM(BomQty)
	
From	@FlatRawBOM
Group by BasePart,
	ChildPart

--Select	*
--From	@FlatRawBOMSummary

DECLARE @BasePart TABLE (
							BasePart varchar(25),
							EmpireSOP	datetime,
							EmpireEOP	datetime, PRIMARY KEY (BasePart))

INSERT	@BasePart
      
    
SELECT [BASE_PART]
      ,MAX([EMPIRE_SOP])EmpireSOP
      ,MAX([EMPIRE_EOP])EmpireEOP
  FROM [EEISQL1].[Monitor].[EEIUser].[acctg_csm_base_part_mnemonic]
  
  GROUP BY [BASE_PART]
      
--SELECT	*
--FROM	@BasePart

DECLARE @BasePartDemand TABLE (
							BasePart varchar(25),
							FG_20_Wk_Demand	numeric(20,6),
							FG_Avg_Wk_Demand	numeric(20,6), 
							FG_On_Hand	numeric(20,6),
							FG_Net_20_Wk_Demand	numeric(20,6),
							FG_Net_Avg_Wk_Demand numeric(20,6) PRIMARY KEY (BasePart))

INSERT	@BasePartDemand
      
    
SELECT LEFT(part_number,7)
      ,sum(quantity)as FG_20_Wk_Demand
      ,(SUM(quantity)/20)as FG_Avg_Wk_Demand
      ,IsNull(max(OnHandQty),0) as FG_On_Hand
      ,(CASE WHEN (sum(quantity)- IsNull(max(OnHandQty),0))<0 THEN 0 ELSE (sum(quantity)- IsNull(max(OnHandQty),0)) END )as FG_Net_20_Wk_Demand
      ,(CASE WHEN (sum(quantity)- IsNull(max(OnHandQty),0))<0 THEN 0 ELSE (sum(quantity)- IsNull(max(OnHandQty),0)) END )/20 as FG_Net_Avg_Wk_Demand
      
  FROM order_detail as order_detail
  Left JOIN ( Select	left(part,7) as Basepart,
			sum(quantity) as OnHandQty 
		from	object object
		LEFT Join	location location on object.location = location.code
		where	isNull(nullif(secured_location,''),'N') != 'Y'
		Group by left(part,7)) Inventory on left(order_detail.part_number,7) = Inventory.BasePart
  WHERE	due_date >= DATEADD(dd,-14,getdate()) and
	due_date <= DATEADD(wk,20,getdate())
    GROUP BY LEFT(part_number,7)
    
DECLARE @FlatCSM TABLE (
							BasePart varchar(25),
							MfgOEM	varchar(25),
							Program	varchar(255), 
							Vehicle	varchar(255) PRIMARY KEY (BasePart))

INSERT	@FlatCSM


SELECT	*
FROM	[EEISQL1].[MONITOR].[dbo].flatCSM

select	* 
from
		(	select part, avg(quantity) as quantity, avg(extendedcost) as extendedcost, avg(stdPack) as stdpack, avg(minorderqty) as minorderqty, avg(bomqty) as bomqty, min(EmpireSOP) as EmpireSOP, max(EmpireEOP) as EmpireEOP, sum(FG_On_Hand) as FG_On_Hand, sum(FG_Net_20_Wk_Demand) as FG_Net_20_Wk_Demand, sum(FG_Net_Avg_Wk_Demand) as FG_Net_Avg_Wk_Demand, sum(BOMQty*FG_Net_20_Wk_Demand) as RM_Net_20_Wk_Demand, sum(BomQty*FG_Net_Avg_Wk_Demand) as RM_Net_Avg_Wk_Demand
			from
				(	Select		part, Quantity, ExtendedCost, StdPack,MinOrderQty,BomQty,FlatBOM.BasePart, MfgOEM, Program, Vehicle, EmpireSOP, EmpireEOP, FG_On_Hand,  FG_Net_20_Wk_Demand, FG_Net_Avg_Wk_Demand, BomQty*FG_Net_20_Wk_Demand as RM_Net_20_Wk_Demand, BomQty*FG_Net_Avg_Wk_Demand as RM_Net_Avg_Wk_Demand
					From		@RawInvSummary	RawInv
					Left Join	@FlatRawBOMSummary FlatBOM on RawInv.Part = FlatBOM.ChildPart
					Left Join	@BasePart Basepart on FlatBOM.BasePart = Basepart.BasePart
					Left Join	@BasePartDemand BasepartDemand on FlatBOM.BasePart = BasepartDemand.BasePart
					LEFT JOIN	@FlatCSM FlatCSMBaseBart ON FlatBOM.BasePart = FlatCSMBaseBart.BasePart) aa
					group by	part
				) aaa

left join	(	SELECT	distinct mps.part,
						runfrom='Active MPS'
				FROM	master_prod_sched mps inner join part p on mps.part=p.part 
				WHERE	p.type='r' 
				UNION
				SELECT	distinct x.ChildPart,
						runfrom='Active service list'
				FROM	Monitor.ft.xrt x inner join part p on x.childpart=p.part
				WHERE	x.TopPart in ('TRW0012-HD01','TRW0088-HG02','TRW0096-HA01','TRW0275-HD01','VSL0107-HC01','MER0015-HB03','MER0026-HC02','FNG0042-HC00','RMP0019-HB01','DEN0003-HE00','ALC0001-HF13','ALC0016-HE10','ALC0023-HC00','ALC0024-HD01','ALC0086-HB07S','ALC0095-HB01S','ALC0117-HA09S','ALC0126-HB05S','ALC0166-HA03','GRD0013-HC01','NAL0025-HB04','NAL0027-HA06','NAL0028-HA07','RMP0020-HC00','AUT0009-HA04','AUT0024-HD02','AUT0035-HF05S','AUT0036-HF05S','AUT0037-HF05S','AUT0038-HF05S','AUT0043-HC12','AUT0048-HA02','AUT0063-HA04','AUT3254-DSA02','DAT0001-HF01','DAT0027-HD01','DAT0028-HC01','DEC0002-HB03','FRD0025-HA01S','FRD4200-HA00','GMC0018-HA00','GMC0024-HA00','GMC0043-HA03','GMC0044-HA01','GMC0068-HA00','GMC0078-HA00','GMC0079-HA01','GMC0080-HA01','GMC0084-HA03','GMC0089-HA00','GMS0001-HA02','INA0201-HD00','VAL0115-HB01','VAL0131-HB01','VAL0156-HA02','VAL0159-HC02','VAL0241-HA00S','VIS0085-HB00','VPP0119-HA04','VPP0167-HB02','VSL0124-HA03','VSL0170-HA03','WEB5400-HA00')
					and p.type='r'
					and x.ChildPart not in (	SELECT	distinct mps.part
												FROM	master_prod_sched mps inner join part p on mps.part=p.part 
												WHERE	p.type='r' 
											)
			) bb on aaa.part = bb.part

left join	(	select	a.part,
						maxdateMi=max(a.date_stamp)  
				from	audit_trail a inner join part p on a.part=p.part 
				where	p.type='r' 
					and a.type='m'
				group by a.part
			) cc on aaa.Part = cc.part
				
left join	(	Select	* 
				from	eeh.dbo.flatfinishedpart
			) dd on aaa.Part = dd.rawpart








order by 3 desc, 1	

			


--create index ix_audit_trail_toloc_type_fromloc on dbo.audit_trail (to_loc, type, from_loc)
--create index ix_audit_trail_serial_type_date_stamp on dbo.audit_trail (serial, type, date_stamp)







GO
