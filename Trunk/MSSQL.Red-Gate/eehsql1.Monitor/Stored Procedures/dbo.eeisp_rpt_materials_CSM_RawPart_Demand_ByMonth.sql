SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[eeisp_rpt_materials_CSM_RawPart_Demand_ByMonth]
AS
set nocount on
set ansi_warnings on
--Get part List to obtain best possible BOM Structure
--print 'insert #Active Part'

declare
	@ActiveParts table
(	BasePart char(7) primary key
,	ActiveOrderPart varchar(25)
,	CurrentRevLevel varchar(25)
,	LastShippedPart varchar(25)
,	LastHN varchar(25)
,	LastPT varchar(25)
,	ActiveOrderPart1 varchar(25)
,	CurrentRevLevel1 varchar(25)
,	LastShippedPart1 varchar(25)
)

insert
	@ActiveParts
(	BasePart
,	ActiveOrderPart
,	CurrentRevLevel
,	LastShippedPart
,	LastHN
,	LastPT
,	ActiveOrderPart1
,	CurrentRevLevel1
,	LastShippedPart1
)
select 
	* 
FROM
	 [FT].[fn_CSM_ActiveFinishedPart]()

declare
	@BOM table
(	BasePart varchar(25)
,	TopPart varchar(25)
,	RawPart varchar(25)
,	QtyPer numeric(20, 6) primary key (BasePart, RawPart)
)

insert
	@BOM
(	BasePart
,	TopPart
,	RawPart
,	QtyPer
)
select
	ap.BasePart
,	BOM.TopPart
,	BOM.ChildPart
,	BOM.Quantity
from
	dbo.vw_RawQtyPerFinPart BOM
	join @ActiveParts ap
		on BOM.TopPart = coalesce(ap.ActiveOrderPart, ap.CurrentRevLevel, ap.LastShippedPart, ap.LastHN, ap.LastPT)

--SELECT* FROM #BOM
--WHERE	BasePart = 'AUT0119'

select
	base_part
,	part.name
,
			--FlatCSM.Program FlatProgram,
	CSMDemand.program
,	manufacturer
,
			--FlatCSM.oem,
	badge
,
			--FlatCSM.vehicle,
	status
,	CSM_eop_display
,	Jan_14_TOTALdemand as Jan2014TotalDemand
,	Feb_14_TOTALdemand as Feb2014TotalDemand
,	Mar_14_TOTALdemand as Mar2014TotalDemand
,	Apr_14_TOTALdemand as Apr2014TotalDemand
,	May_14_TOTALdemand as May2014TotalDemand
,	Jun_14_TOTALdemand as Jun2014TotalDemand
,	Jul_14_TOTALdemand as Jul2014TotalDemand
,	Aug_14_TOTALdemand as Aug2014TotalDemand
,	Sep_14_TOTALdemand as Sep2014TotalDemand
,	Oct_14_TOTALdemand as Oct2014TotalDemand
,	Nov_14_TOTALdemand as Nov2014TotalDemand
,	Dec_14_TOTALdemand as Dec2014TotalDemand
,	Jan_15_TOTALdemand as Jan2015TotalDemand
,	Feb_15_TOTALdemand as Feb2015TotalDemand
,	Mar_15_TOTALdemand as Mar2015TotalDemand
,	Apr_15_TOTALdemand as Apr2015TotalDemand
,	May_15_TOTALdemand as May2015TotalDemand
,	Jun_15_TOTALdemand as Jun2015TotalDemand
,	Jul_15_TOTALdemand as Jul2015TotalDemand
,	Aug_15_TOTALdemand as Aug2015TotalDemand
,	Sep_15_TOTALdemand as Sep2015TotalDemand
,	Oct_15_TOTALdemand as Oct2015TotalDemand
,	Nov_15_TOTALdemand as Nov2015TotalDemand
,	Dec_15_TOTALdemand as Dec2015TotalDemand
,	RawPart
,	coalesce(p2.commodity, 'NoCommdityDefined') as Commodity
,	QtyPer
,	QtyPer * Jan_14_TOTALdemand as Jan2014RawPartTotalDemand
,	QtyPer * Feb_14_TOTALdemand as Feb2014RawPartTotalDemand
,	QtyPer * Mar_14_TOTALdemand as Mar2014RawPartTotalDemand
,	QtyPer * Apr_14_TOTALdemand as Apr2014RawPartTotalDemand
,	QtyPer * May_14_TOTALdemand as May2014RawPartTotalDemand
,	QtyPer * Jun_14_TOTALdemand as Jun2014RawPartTotalDemand
,	QtyPer * Jul_14_TOTALdemand as Jul2014RawPartTotalDemand
,	QtyPer * Aug_14_TOTALdemand as Aug2014RawPartTotalDemand
,	QtyPer * Sep_14_TOTALdemand as Sep2014RawPartTotalDemand
,	QtyPer * Oct_14_TOTALdemand as Oct2014RawPartTotalDemand
,	QtyPer * Nov_14_TOTALdemand as Nov2014RawPartTotalDemand
,	QtyPer * Dec_14_TOTALdemand as Dec2014RawPartTotalDemand
,	QtyPer * Jan_15_TOTALdemand as Jan2015RawPartTotalDemand
,	QtyPer * Feb_15_TOTALdemand as Feb2015RawPartTotalDemand
,	QtyPer * Mar_15_TOTALdemand as Mar2015RawPartTotalDemand
,	QtyPer * Apr_15_TOTALdemand as Apr2015RawPartTotalDemand
,	QtyPer * May_15_TOTALdemand as May2015RawPartTotalDemand
,	QtyPer * Jun_15_TOTALdemand as Jun2015RawPartTotalDemand
,	QtyPer * Jul_15_TOTALdemand as Jul2015RawPartTotalDemand
,	QtyPer * Aug_15_TOTALdemand as Aug2015RawPartTotalDemand
,	QtyPer * Sep_15_TOTALdemand as Sep2015RawPartTotalDemand
,	QtyPer * Oct_15_TOTALdemand as Oct2015RawPartTotalDemand
,	QtyPer * Nov_15_TOTALdemand as Nov2015RawPartTotalDemand
,	QtyPer * Dec_15_TOTALdemand as Dec2015RawPartTotalDemand
,	material_cum * QtyPer * Jan_14_TOTALdemand as Jan2014RawPartTotalSpend
,	material_cum * QtyPer * Feb_14_TOTALdemand as Feb2014RawPartTotalSpend
,	material_cum * QtyPer * Mar_14_TOTALdemand as Mar2014RawPartTotalSpend
,	material_cum * QtyPer * Apr_14_TOTALdemand as Apr2014RawPartTotalSpend
,	material_cum * QtyPer * May_14_TOTALdemand as May2014RawPartTotalSpend
,	material_cum * QtyPer * Jun_14_TOTALdemand as Jun2014RawPartTotalSpend
,	material_cum * QtyPer * Jul_14_TOTALdemand as Jul2014RawPartTotalSpend
,	material_cum * QtyPer * Aug_14_TOTALdemand as Aug2014RawPartTotalSpend
,	material_cum * QtyPer * Sep_14_TOTALdemand as Sep2014RawPartTotalSpend
,	material_cum * QtyPer * Oct_14_TOTALdemand as Oct2014RawPartTotalSpend
,	material_cum * QtyPer * Nov_14_TOTALdemand as Nov2014RawPartTotalSpend
,	material_cum * QtyPer * Dec_14_TOTALdemand as Dec2014RawPartTotalSpend
,	material_cum * QtyPer * Jan_15_TOTALdemand as Jan2015RawPartTotalSpend
,	material_cum * QtyPer * Feb_15_TOTALdemand as Feb2015RawPartTotalSpend
,	material_cum * QtyPer * Mar_15_TOTALdemand as Mar2015RawPartTotalSpend
,	material_cum * QtyPer * Apr_15_TOTALdemand as Apr2015RawPartTotalSpend
,	material_cum * QtyPer * May_15_TOTALdemand as May2015RawPartTotalSpend
,	material_cum * QtyPer * Jun_15_TOTALdemand as Jun2015RawPartTotalSpend
,	material_cum * QtyPer * Jul_15_TOTALdemand as Jul2015RawPartTotalSpend
,	material_cum * QtyPer * Aug_15_TOTALdemand as Aug2015RawPartTotalSpend
,	material_cum * QtyPer * Sep_15_TOTALdemand as Sep2015RawPartTotalSpend
,	material_cum * QtyPer * Oct_15_TOTALdemand as Oct2015RawPartTotalSpend
,	material_cum * QtyPer * Nov_15_TOTALdemand as Nov2015RawPartTotalSpend
,	material_cum * QtyPer * Dec_15_TOTALdemand as Dec2015RawPartTotalSpend
,	default_vendor
,	standard_pack
,	isnull((
			select
				FABAuthDays / 7
			from
				part_vendor
			where
				vendor = default_vendor
				and part = part.part
		   ), 0) as LeadTime
,	material_cum as StandardCost
,	(case when isnull((
					   select
						FABAuthDays / 7
					   from
						part_vendor
					   where
						vendor = default_vendor
						and part = part.part
					  ), 0) >= 8 then 'Excessive Lead Time'
		  else ''
	 end) as LeadTimeFlag
into
	#results
from
	[EEISQL1].[MONITOR].[EEIUser].[acctg_csm_vw_select_sales_forecast] as CSMDemand
	left join @BOM BOM
		on CSMDemand.base_part = BOM.BasePart
	left join part p2
		on BOM.RawPart = p2.part
	join part_online
		on BOM.RawPart = part_online.part
	join part
		on part_online.part = part.part
	join part_inventory
		on part_online.part = part_inventory.part
	join part_standard
		on part_online.part = part_standard.part

truncate table 
		 FT.CSM_VendorSpend_perMonth
INSERT	FT.CSM_VendorSpend_perMonth
		(
		 base_part
		,name
		,program
		,Manufacturer
		,Badge
		,Status
		,CSM_eop_display
		,Jan2014TotalDemand
		,Feb2014TotalDemand
		,Mar2014TotalDemand
		,Apr2014TotalDemand
		,May2014TotalDemand
		,Jun2014TotalDemand
		,Jul2014TotalDemand
		,Aug2014TotalDemand
		,Sep2014TotalDemand
		,Oct2014TotalDemand
		,Nov2014TotalDemand
		,Dec2014TotalDemand
		,Jan2015TotalDemand
		,Feb2015TotalDemand
		,Mar2015TotalDemand
		,Apr2015TotalDemand
		,May2015TotalDemand
		,Jun2015TotalDemand
		,Jul2015TotalDemand
		,Aug2015TotalDemand
		,Sep2015TotalDemand
		,Oct2015TotalDemand
		,Nov2015TotalDemand
		,Dec2015TotalDemand
		,RawPart
		,Commodity
		,QtyPer
		,Jan2014RawPartTotalDemand
		,Feb2014RawPartTotalDemand
		,Mar2014RawPartTotalDemand
		,Apr2014RawPartTotalDemand
		,May2014RawPartTotalDemand
		,Jun2014RawPartTotalDemand
		,Jul2014RawPartTotalDemand
		,Aug2014RawPartTotalDemand
		,Sep2014RawPartTotalDemand
		,Oct2014RawPartTotalDemand
		,Nov2014RawPartTotalDemand
		,Dec2014RawPartTotalDemand
		,Jan2015RawPartTotalDemand
		,Feb2015RawPartTotalDemand
		,Mar2015RawPartTotalDemand
		,Apr2015RawPartTotalDemand
		,May2015RawPartTotalDemand
		,Jun2015RawPartTotalDemand
		,Jul2015RawPartTotalDemand
		,Aug2015RawPartTotalDemand
		,Sep2015RawPartTotalDemand
		,Oct2015RawPartTotalDemand
		,Nov2015RawPartTotalDemand
		,Dec2015RawPartTotalDemand
		,Jan2014RawPartTotalSpend
		,Feb2014RawPartTotalSpend
		,Mar2014RawPartTotalSpend
		,Apr2014RawPartTotalSpend
		,May2014RawPartTotalSpend
		,Jun2014RawPartTotalSpend
		,Jul2014RawPartTotalSpend
		,Aug2014RawPartTotalSpend
		,Sep2014RawPartTotalSpend
		,Oct2014RawPartTotalSpend
		,Nov2014RawPartTotalSpend
		,Dec2014RawPartTotalSpend
		,Jan2015RawPartTotalSpend
		,Feb2015RawPartTotalSpend
		,Mar2015RawPartTotalSpend
		,Apr2015RawPartTotalSpend
		,May2015RawPartTotalSpend
		,Jun2015RawPartTotalSpend
		,Jul2015RawPartTotalSpend
		,Aug2015RawPartTotalSpend
		,Sep2015RawPartTotalSpend
		,Oct2015RawPartTotalSpend
		,Nov2015RawPartTotalSpend
		,Dec2015RawPartTotalSpend
		,default_vendor
		,standard_pack
		,LeadTime
		,StandardCost
		,LeadTimeFlag
		,MaxCSMEOPforRawPart
		,AllRawPartInventory
		,VendorTerms
			
		)
SELECT
	*
,	(
	 SELECT
		MAX(CSM_eop_display)
	 FROM
		#results R2
	 WHERE
		R2.RawPart = Results.RawPart
	) AS MaxCSMEOPforRawPart
,	(
	 SELECT
		SUM(std_quantity)
	 FROM
		object
	 WHERE
		object.part = Results.RawPart
	) AS AllRawPartInventory
,	(
	 SELECT
		MAX(terms)
	 FROM
		vendor
	 WHERE
		code = Results.default_vendor
	) AS VendorTerms
FROM
	#results Results
ORDER BY
	1
,	2


GO
