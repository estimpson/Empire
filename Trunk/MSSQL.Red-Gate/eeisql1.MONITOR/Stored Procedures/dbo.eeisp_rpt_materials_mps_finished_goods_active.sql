SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  procedure [dbo].[eeisp_rpt_materials_mps_finished_goods_active] 
       as
begin

declare	@ThisMondayDT datetime; set @ThisMondayDT = FT.fn_TruncDate ('wk', getdate ())+1

declare @MPS table
(	part varchar (25) not null, 
	DateStamp datetime not null, 
	Inventory int not null, 
	POBalance int not null, 
	CustomerDemand int not null, 
	EEIDemand int not null, 
	netchange as (Inventory + POBalance) - CustomerDemand, 
	runningtotal int null,
	CSMDemand int null,
	Scheduler varchar(25) null,
	CustomerPart varchar(25) null,
	Price	numeric (20,6) Null,
	SOP datetime null,
	EOP datetime null,
	CurrentRevLevel  varchar(2) null, primary key (part, datestamp))


insert  @MPS (	part,			
			DateStamp,
			POBalance,
			EEIDemand,
			CustomerDemand,
			Inventory,
			Scheduler,
			CustomerPart,
			Price,
			SOP,
			EOP,
			CurrentRevLevel	
			) 
select	Part,
		BeginDT, 

POBalance = coalesce ((select sum (balance) 
					from po_detail 
					where part_number = Part and 
					date_due >= BeginDT and 
					date_due < EndDT), 0),


EEIDemand = coalesce ((select sum (EEIQty) 
					from order_detail 
					where part_number = Part and 
					due_date >= BeginDT and 
					due_date < EndDT), 0),

CustomerDemand = coalesce ((select sum (Quantity) 
							from order_detail 
						where part_number = Part and 
							due_date >= BeginDT and 
							due_date < EndDT), 0),

Inventory = coalesce ((select sum(Quantity) 
					from		object 
					left join	location on object.location = location.code 
					where	part = PartList.Part and 
							BeginDT = @ThisMondayDT and
							( isNULL(secured_location, 'N') != 'Y' and location not like '%LOST%'  ) ), 0),

Scheduler = PartSetups.Scheduler,
CustomerPart = PartSetups.CustomerPart,
Price = PartSetups.Price,
SOP = PartSetups.SOP,
EOP = PartSetups.EOP,
CurrentRevLevel = PartSetups.CurrentRevLevel


from	(	select	Part = part
	from	part
	where	part in (select part_number from po_detail where balance > 0 and date_due > getdate () - 30 union all select part_number from order_detail where due_date > getdate () union all select part from object where (location not like '%LOST%' or  last_date > getdate () - 120)) and
			part.class in ('P', 'M') and part.type = 'F'
	group by
		part) PartList
	left join
	(	Select	max(UPPER(scheduler)) scheduler,
			max(customer_part) CustomerPart,
			max(price) as Price,
			max(prod_start) as SOP,
			max(prod_end) as EOP,
			part_standard.part as PSPart,
			max(CurrentRevLevel) as CurrentRevLevel
		from	part_standard
	join		part_eecustom on part_standard.part = part_eecustom.part
	left join	part_customer on part_standard.part = part_customer.part
	left join	customer on part_customer.customer = customer.customer
	join		destination on customer.customer = destination.customer 
	group by	part_standard.part) PartSetups on PartList.Part = PartSetups.PSPart
	cross join
(	select	BeginDT = EntryDT,
				EndDT = EntryDT + 7
		from		[FT].[fn_Calendar] (@ThisMondayDT, null, 'wk', 1, 25)
		UNION
		Select	BeginDT = DateAdd(dd, -365, EntryDT),
				EndDT = EntryDT
		from		[FT].[fn_Calendar] (@ThisMondayDT, null, 'wk', 1, 1))

	Buckets


update	@MPS
set	runningtotal = (select sum (netchange) from @MPS t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp)
from	@MPS t1


Select	isNULL(Scheduler, '_N/A') as Scheduler,
		substring( part,1,3) as	CustomerCode,
		substring(part,1,7) as	BasePart,
		Part,
		DateStamp,
		isNULL(CSMDemand,0) as CSMDemand,
		EEIDemand,
		CustomerDemand,
		POBalance,
		Inventory,
		RunningTotal,
		CustomerPart,
		Price,
		convert( varchar (20),SOP, 111),
		convert( varchar (20),EOP, 111),
		CurrentRevLevel,
		(Select program from FlatCSM where 	basePart = substring(part,1,7)) as CSMProgram,
		(Select vehicle from FlatCSM where 	basePart = substring(part,1,7)) as CSMVehicle,
		(Select oem from FlatCSM where 	basePart = substring(part,1,7)) as CSMOEM	
from		@MPS
where	part in ( select part
		   from	@mps
		group by part
		having sum(CustomerDemand+ABS(POBalance))>10 
)

end
GO
