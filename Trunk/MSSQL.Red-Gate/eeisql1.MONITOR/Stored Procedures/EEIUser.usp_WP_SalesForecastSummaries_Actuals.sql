SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_WP_SalesForecastSummaries_Actuals]
	@Filter varchar(50)
,	@FilterValue varchar(250) = null
as
set nocount on
set ansi_warnings on



--- <Body>
declare
	@FilterType int -- 0 = base part attributes, 1 = CSM (Program, Vehicle)

set	@Filter = 'Customer'
set	@FilterType = 0

if (@Filter = 'Program' or @Filter = 'Vehicle') begin
	set @FilterType = 1
end
	

-- Actual sales by base part
declare @shipped table
(
	BasePart varchar(25)
/*
,	Jan2016 decimal(20, 6) null
,	Feb2016 decimal(20, 6) null
,	Mar2016 decimal(20, 6) null
,	Apr2016 decimal(20, 6) null
,	May2016 decimal(20, 6) null
,	Jun2016 decimal(20, 6) null
,	Jul2016 decimal(20, 6) null
,	Aug2016 decimal(20, 6) null
,	Sep2016 decimal(20, 6) null
,	Oct2016 decimal(20, 6) null
,	Nov2016 decimal(20, 6) null
,	Dec2016 decimal(20, 6) null
,	Jan2017 decimal(20, 6) null
,	Feb2017 decimal(20, 6) null
,	Mar2017 decimal(20, 6) null
,	Apr2017 decimal(20, 6) null
,	May2017 decimal(20, 6) null
,	Jun2017 decimal(20, 6) null
,	Jul2017 decimal(20, 6) null
,	Aug2017 decimal(20, 6) null
,	Sep2017 decimal(20, 6) null
,	Oct2017 decimal(20, 6) null
,	Nov2017 decimal(20, 6) null
,	Dec2017 decimal(20, 6) null
*/
,	Year2016 decimal(20, 6) null
,	Year2017 decimal(20, 6) null
)

insert @shipped
(
	BasePart
/*
,	Jan2016
,	Feb2016
,	Mar2016
,	Apr2016
,	May2016
,	Jun2016
,	Jul2016
,	Aug2016
,	Sep2016
,	Oct2016
,	Nov2016
,	Dec2016
,	Jan2017
,	Feb2017
,	Mar2017
,	Apr2017
,	May2017
,	Jun2017
,	Jul2017
,	Aug2017
,	Sep2017
,	Oct2017
,	Nov2017
,	Dec2017
*/
,	Year2016
,	Year2017
)
select
	BasePart = left(sd.part_original, 7)
/*
,	Jan2016 = sum((case when month(s.date_shipped) =  1 and year(s.date_shipped) = 2016 then sd.qty_packed * sd.alternate_price else 0 end))
,	Feb2016 = sum((case when month(s.date_shipped) =  2 and year(s.date_shipped) = 2016 then sd.qty_packed * sd.alternate_price else 0 end))
,	Mar2016 = sum((case when month(s.date_shipped) =  3 and year(s.date_shipped) = 2016 then sd.qty_packed * sd.alternate_price else 0 end))
,	Apr2016 = sum((case when month(s.date_shipped) =  4 and year(s.date_shipped) = 2016 then sd.qty_packed * sd.alternate_price else 0 end))
,	May2016 = sum((case when month(s.date_shipped) =  5 and year(s.date_shipped) = 2016 then sd.qty_packed * sd.alternate_price else 0 end))
,	Jun2016 = sum((case when month(s.date_shipped) =  6 and year(s.date_shipped) = 2016 then sd.qty_packed * sd.alternate_price else 0 end))
,	Jul2016 = sum((case when month(s.date_shipped) =  7 and year(s.date_shipped) = 2016 then sd.qty_packed * sd.alternate_price else 0 end))
,	Aug2016 = sum((case when month(s.date_shipped) =  8 and year(s.date_shipped) = 2016 then sd.qty_packed * sd.alternate_price else 0 end))
,	Sep2016 = sum((case when month(s.date_shipped) =  9 and year(s.date_shipped) = 2016 then sd.qty_packed * sd.alternate_price else 0 end))
,	Oct2016 = sum((case when month(s.date_shipped) = 10 and year(s.date_shipped) = 2016 then sd.qty_packed * sd.alternate_price else 0 end))
,	Nov2016 = sum((case when month(s.date_shipped) = 11 and year(s.date_shipped) = 2016 then sd.qty_packed * sd.alternate_price else 0 end))
,	Dec2016 = sum((case when month(s.date_shipped) = 12 and year(s.date_shipped) = 2016 then sd.qty_packed * sd.alternate_price else 0 end))
,	Jan2017 = sum((case when month(s.date_shipped) =  1 and year(s.date_shipped) = 2017 then sd.qty_packed * sd.alternate_price else 0 end))
,	Feb2017 = sum((case when month(s.date_shipped) =  2 and year(s.date_shipped) = 2017 then sd.qty_packed * sd.alternate_price else 0 end))
,	Mar2017 = sum((case when month(s.date_shipped) =  3 and year(s.date_shipped) = 2017 then sd.qty_packed * sd.alternate_price else 0 end))
,	Apr2017 = sum((case when month(s.date_shipped) =  4 and year(s.date_shipped) = 2017 then sd.qty_packed * sd.alternate_price else 0 end))
,	May2017 = sum((case when month(s.date_shipped) =  5 and year(s.date_shipped) = 2017 then sd.qty_packed * sd.alternate_price else 0 end))
,	Jun2017 = sum((case when month(s.date_shipped) =  6 and year(s.date_shipped) = 2017 then sd.qty_packed * sd.alternate_price else 0 end))
,	Jul2017 = sum((case when month(s.date_shipped) =  7 and year(s.date_shipped) = 2017 then sd.qty_packed * sd.alternate_price else 0 end))
,	Aug2017 = sum((case when month(s.date_shipped) =  8 and year(s.date_shipped) = 2017 then sd.qty_packed * sd.alternate_price else 0 end))
,	Sep2017 = sum((case when month(s.date_shipped) =  9 and year(s.date_shipped) = 2017 then sd.qty_packed * sd.alternate_price else 0 end))
,	Oct2017 = sum((case when month(s.date_shipped) = 10 and year(s.date_shipped) = 2017 then sd.qty_packed * sd.alternate_price else 0 end))
,	Nov2017 = sum((case when month(s.date_shipped) = 11 and year(s.date_shipped) = 2017 then sd.qty_packed * sd.alternate_price else 0 end))
,	Dec2017 = sum((case when month(s.date_shipped) = 12 and year(s.date_shipped) = 2017 then sd.qty_packed * sd.alternate_price else 0 end))
*/
,	Year2016 = sum((case when year(s.date_shipped) = 2016 then sd.qty_packed * sd.alternate_price else 0 end))
,	Year2017 = sum((case when year(s.date_shipped) = 2017 then sd.qty_packed * sd.alternate_price else 0 end))
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on s.id = sd.shipper
where
	year(isnull(s.date_shipped, 2015)) in (2016, 2017)
	and isnull(s.type, 'S') not in ('V', 'T')
	and sd.alternate_price is not null
group by
	left(sd.part_original, 7)




if (@FilterType = 0) begin

	-- Bring in base_part_attributes fields
	declare @shippedAttributes table
	(
		BasePart varchar(50)
	,	Customer varchar(50)
	,	ParentCustomer varchar(100)
	,	ProductLine varchar(50)
	,	Salesperson varchar(50)
	,	Segment varchar(50)
	,	Sales2016 decimal(20, 6)
	,	Sales2017 decimal(20, 6)
	)

	insert @shippedAttributes
	(
		BasePart
	,	Customer
	,	ParentCustomer
	,	ProductLine
	,	Salesperson
	,	Segment
	,	Sales2016
	,	Sales2017
	)
	select
		BasePart = s.BasePart
	,	Customer = coalesce(bpa.customer, 'XXX')
	,	ParentCustomer = bpa.parent_customer
	,	ProductLine = bpa.product_line
	,	Salesperson = bpa.Salesperson
	,	Segment = bpa.empire_market_segment
	,	Sales2016 = s.Year2016
	,	Sales2017 = s.Year2017
	from
		@shipped s
		left join eeiuser.acctg_csm_base_part_attributes bpa
			on bpa.base_part = s.BasePart
	where
		bpa.release_id = (select [dbo].[fn_ReturnLatestCSMRelease] ('CSM') )


	-- Apply filter
	if (@Filter = 'Customer') begin
		select
			sa.Customer
		,	sum(sa.Sales2016) as Sales2016
		,	sum(sa.Sales2017) as Sales2017
		from
			@shippedAttributes sa
		--where
		--	sa.Customer in 
		--	('ADC','ALC','ALI','ASI','ASPM','AUT','CEM','CON','DAK','DEL','DEN','DFN','ELC','FJK','FMO','FNG','GMC','GPK','GUI',
		--		'HEL','HUF','IIS','JCI','KAB','Kimball','KSI','LEO','LER','LTK','MAG','MER','NAL','NAS','NOR','SLA','SPC','SSC',
		--		'STE','STK','SUM','TOG','TRW','UTA','VAL','VAR','VNA','VPA','VPP','VSL','YAN','YAZ','YUR')
		group by
			sa.Customer
		order by
			sa.Customer

		select
			sum(sa.Sales2016) as Sales2016
		,	sum(sa.Sales2017) as Sales2017
		from
			@shippedAttributes sa
	end
	else if (@Filter = 'Parent Customer') begin
		select
			sa.ParentCustomer
		,	sum(sa.Sales2016) as Sales2016
		,	sum(sa.Sales2017) as Sales2017
		from
			@shippedAttributes sa
		group by
			sa.ParentCustomer
		order by
			sa.ParentCustomer
	end
	else if (@Filter = 'Product Line') begin
		select
			sa.ProductLine
		,	sum(sa.Sales2016) as Sales2016
		,	sum(sa.Sales2017) as Sales2017
		from
			@shippedAttributes sa
		group by
			sa.ProductLine
		order by
			sa.ProductLine
	end
	else if (@Filter = 'Salesperson') begin
		select
			sa.Salesperson
		,	sum(sa.Sales2016) as Sales2016
		,	sum(sa.Sales2017) as Sales2017
		from
			@shippedAttributes sa
		group by
			sa.Salesperson
		order by
			sa.Salesperson
	end
	else if (@Filter = 'Segment') begin
		select
			sa.Segment
		,	sum(sa.Sales2016) as Sales2016
		,	sum(sa.Sales2017) as Sales2017
		from
			@shippedAttributes sa
		group by
			sa.Segment
		order by
			sa.Segment
	end

end
else begin

	-- Bring in CSM fields
	declare @shippedCsm table
	(
		BasePart varchar(50)
	,	Program varchar(50)
	,	Vehicle varchar(50)
	,	Sales2016 decimal(20, 6)
	,	Sales2017 decimal(20, 6)
	)

	insert @shippedCsm
	(
		BasePart
	,	Program
	,	Vehicle
	,	Sales2016
	,	Sales2017
	)
	select distinct
		BasePart = s.BasePart
	,	Program = n.PROGRAM
	,	Vehicle = n.Badge + ' ' + n.Nameplate
	,	Sales2016 = s.Year2016
	,	Sales2017 = s.Year2017
	from	
		eeiuser.acctg_csm_NACSM n
		join eeiuser.acctg_csm_base_part_mnemonic pm
			on pm.MNEMONIC = n.MNEMONIC
			and pm.RELEASE_ID = n.RELEASE_ID
		join @shipped s
			on s.BasePart = pm.BASE_PART
	where	
		n.[version] = 'CSM' 
		and n.release_id = (select [dbo].[fn_ReturnLatestCSMRelease] ('CSM') )  


	-- Apply filter
	if (@Filter = 'Program') begin
		select
			sc.Program
		,	sum(sc.Sales2016) as Sales2016
		,	sum(sc.Sales2017) as Sales2017
		from
			@shippedCsm sc
		group by
			sc.Program
		order by
			sc.Program
	end
	else if (@Filter = 'Vehicle') begin
		select
			sc.Vehicle
		,	sum(sc.Sales2016) as Sales2016
		,	sum(sc.Sales2017) as Sales2017
		from
			@shippedCsm sc
		group by
			sc.Vehicle
		order by
			sc.Vehicle
	end

end








GO
