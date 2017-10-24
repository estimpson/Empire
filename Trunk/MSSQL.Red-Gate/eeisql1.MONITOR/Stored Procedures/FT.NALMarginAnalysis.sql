SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FT].[NALMarginAnalysis]  @BeginDate datetime, @EndDate datetime

as

Begin
--FT.NALMarginAnalysis '2011-10-01', '2011-10-31'
select	@BeginDate = FT.fn_TruncDate('dd', @BeginDate)
select	@EndDate = dateadd(dd,1,FT.fn_TruncDate('dd', @EndDate))

DECLARE @RC int,
@Debug int


begin Transaction
EXECUTE @RC = [MONITOR].[FT].[ftsp_IncUpdXRt] 
					@Debug
commit Transaction 

 
 --select @BeginDate
 --select @EndDate

create	table #ResultSet (
			TopPart varchar(25),
			ChildPart varchar(25),
			QtyShipped int,
			BulbedSellingPrice numeric(10,4),
			BulbedExtendedSales numeric(10,2),
			BulbedMaterialCum numeric(10,4),
			BulbedExtendedMaterialCost numeric(10,4),
			BulbedMargin as round((BulbedMaterialCum/nullif(BulbedSellingPrice,0)), 2) ,
			NonBulbedSellingPrice numeric(10,4),
			NonBulbedExtendedSellingPrice numeric(10,2),
			NonBulbedMaterialCost numeric(10,4),
			NonBulbedExtendedMaterialCost numeric(10,2),
			NonBulbedMargin as round((NonBulbedExtendedMaterialCost/nullif(NonBulbedExtendedSellingPrice,0)),2), 
			Increment as BulbedSellingPrice-NonBulbedSellingPrice ,
			ExtendedIncrement as convert(numeric(10,2),(BulbedSellingPrice-NonBulbedSellingPrice)*QtyShipped)
			)
			
	insert	#ResultSet (TopPart,
	ChildPart,
	QtyShipped,
	BulbedSellingPrice,
	BulbedExtendedSales,
	BulbedMaterialCum,
	BulbedExtendedMaterialCost,
	NonBulbedSellingPrice,
	NonBulbedExtendedSellingPrice,
	NonBulbedMaterialCost,
	NonBulbedExtendedMaterialCost) 

select	TopPart,
			ChildPart,
			QtyShipped,
			alternate_price,
			ExtendedSales,
			PSTopPart.material_cum as BulbedMaterialCost,
			QtyShipped*PSTopPart.material_cum as BulbedExtendedMaterialCost,
			(select max(blanket_price) from dbo.part_customer where part=ChildPart and (customer = 'EEA' or customer ='NALFLORA' or customer= 'ES3NAL')) as NonBulbedSellingPrice,
			(select max(blanket_price) from dbo.part_customer where part=ChildPart and (customer = 'EEA' or customer ='NALFLORA' or customer= 'ES3NAL'))*QtyShipped as NonBulbedExtendedSellingPrice,
			PSChildPart.material_cum as NonBulbedMaterialCost,
			QtyShipped*PSChildPart.material_cum as NonBulbedExtendedMaterialCost
			 from
( select	Toppart,
				Childpart
	from
	FT.XRt
	where	exists  ( select 1 from shipper_detail join shipper on dbo.shipper_detail.shipper = dbo.shipper.id where shipper.date_shipped >= @BeginDate and shipper.date_Shipped<@EndDate and part_original = TopPart and plant = 'EEA' )
	and exists (select 1 from po_detail join po_header on dbo.po_detail.po_number = dbo.po_header.po_number where po_header.vendor_code = 'EEH' and part_number = ChildPart)
) BOMs join
( select	part_original,
				alternate_price,
				sum(alternate_price*qty_packed) as ExtendedSales,
				sum(qty_packed) QtyShipped
	from		dbo.shipper_detail
	join		shipper on dbo.shipper_detail.shipper = dbo.shipper.id
	where	shipper.date_shipped >= @BeginDate and shipper.date_Shipped<@EndDate  and plant = 'EEA'
	group by part_original, alternate_price
) NALShipments on BOMs.TopPart = NALShipments.part_original
join	dbo.part_standard PSTopPart on BOMs.TopPart =  PSTopPart.part
join	dbo.part_standard PSChildPart on Boms.ChildPart = PSChildPart.part

	
	select	*
	from	#ResultSet
	order by 1,2
end
GO
