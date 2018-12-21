SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [HN].[MAT_RPT_Packing_Slip] (
	@Shipper integer )
	AS

/*

exec	HN.MAT_RPT_Packing_Slip
		@Shipper = 107860
*/



declare	@Serials varchar(max),
		@serial int, @Part varchar(25), 
		@CurrentPart varchar(25),
		@country varchar(3)

declare	@SerialsInShippment table
	(	part varchar(25),
		Serials varchar(max) )

declare @hf_tarrif varchar (50),
		@hf_tarrif1 varchar (50),
		@hf_tarrif2 varchar (50),
		@hf_tarrif3 varchar (50)

declare SerialsInShipment cursor local for
select	Part, Serial
from	(
		select	distinct serial, part
		from	monitor.dbo.audit_Trail
		where	type = 'S'
				and shipper = @Shipper
		union all
		select	serial, part
		from	monitor.dbo.object
		where	shipper = @Shipper ) x
order by part, serial

open SerialsInShipment

fetch next from SerialsInShipment
into @Part, @Serial

set	@CurrentPart = @Part
set	@Serials = ''
set @Country = 'USD'

while @@fetch_status = 0 begin

	if @CurrentPart = @Part begin
		set @Serials = @Serials + ' ' +  convert(varchar, @Serial )
	end
	else begin
		insert into @SerialsInShippment( Part, Serials )
			select @CurrentPart, @Serials

		set	@CurrentPart = @Part
		set	@Serials = ' ' + convert(varchar, @Serial )

	end
	fetch next from SerialsInShipment
	into @Part, @Serial

end


insert into @SerialsInShippment( Part, Serials )
select @CurrentPart, @Serials



	select	ShipperID = shipper.ID, DateShipped = shipper.date_shipped, aetc =  aetc_number, freight_type, bill_of_lading_number,
			shipper.customer,  invoice_number, TotalGrossWeight = shipper.gross_weight, TotalNetWeight = shipper.net_weight, 
			pro_number, shipper.Notes, truck_number, shipperdetail.part, QtyPackage = PFADetails.qtyPcs, shipperdetail.order_no, shipper.staged_objs as Boxes_staged ,
			part.drawing_number as ECN,
			FOB= Shipper.location,
			shipper.staged_pallets as Pallet_staged  , customer_po, 
			price = CASE WHEN round(isnull(shipperdetail.price, alternate_price ),2) = 0 THEN '0.10'  ELSE PRICE
			END, 
			shipperdetail.gross_weight, shipperdetail.net_weight, boxes_staged, customer_part, part_name,
			ShippingAddress1 = destination.Address_1, ShippingAddress2 = destination.Address_2, ShippingAddress3 = destination.Address_3, 
			ShippingState =  destination.State,
			ShippingCountry = destination.Country, Unitweight = shipperdetail.alternative_unit, 
			@country as CountryCode,
			CustomerName = destination.name, CustomerAddress1 = destination.Address_1,
			CustomerAddress2 = destination.Address_2, CustomerAddress3 = destination.Address_3, CustomerPhone = Customer.Phone,
			Serials = SerialsInShippment.Serials, shipper.terms, shipper.ship_via, FreightName_ShipViaName = carrier.name,
			(Select SUM(qty_packed) from shipper_detail where shipper=@Shipper and part=shipperdetail.part group by part) as QTY_Shipped,
			(Select SUM(accum_shipped) from shipper_detail where shipper=@Shipper and part=shipperdetail.part group by part) as CUM_Shipped,
			
			pfa.contact ,
			pfa.Account,pfa.AccountType, pfa.TrackingNumber, pfa.methodshipping, pfadetails.RAM, pfa.Contact,pfadetails.descripction, part.product_line, ShipTo=pfa.ShipTo + pfa.StreetNo + pfa.State,ItsUSA=isnull(pfa.ItsUSA,1),
			CountryPFA=case when isnull(pfa.ItsUSA,1)=1 then 'USA' ELSE PFA.CountryPFA END,
			Show_Cafta=	CASE when isnull(pfa.ItsUSA,1)=1 THEN 1 else 0 END,
			Show_DFI=	CASE when isnull(pfa.ItsUSA,1)=1 and part.product_line like '%PCB%' THEN 1 else 0 END, 
			Show_POA=	CASE when isnull(pfa.ItsUSA,1)=0 and part.product_line not like '%PCB%' and pfa.AccountType <> 'Customer' and pfa.MethodShipping = 'UPS'  THEN 1 
							 when isnull(pfa.ItsUSA,1)=0 and part.product_line like '%PCB%' and pfa.AccountType<>'Customer' and pfa.MethodShipping = 'UPS' THEN 1
							 when isnull(pfa.ItsUSA,1)=1 and part.product_line like '%PCB%' and pfa.AccountType<>'Customer' and pfa.MethodShipping = 'UPS' THEN 1
							 when isnull(pfa.ItsUSA,1)=1 and part.product_line not like '%PCB%' and pfa.AccountType<>'Customer' and pfa.MethodShipping = 'UPS' THEN 1
							 else 0 END,
			show_Comp=  CASE when isnull(pfa.ItsUSA,1) = 0 and pfa.AccountType = 'Customer' then 1
							 when isnull(pfa.ItsUSA,1)=1 and part.product_line not like '%PCB%' and pfa.AccountType = 'Customer' and pfa.MethodShipping = 'UPS' THEN 1
							 when isnull(pfa.ItsUSA,1)=1 and part.product_line like '%PCB%' and pfa.AccountType = 'Customer' and pfa.MethodShipping = 'UPS' THEN 1
							 else 0 END, 
			DatePrint = getdate()
	from	monitor.dbo.shipper shipper
			join monitor.dbo.shipper_detail shipperdetail on shipperdetail.Shipper = shipper.ID
			left join monitor.dbo.destination destination on destination.destination = shipper.Destination
			--left join dbo.HTS_Codes HTS_Codes on HTS_Codes.freight = shipper.ship_via
			left join monitor.dbo.carrier carrier on shipper.ship_via = carrier.scac 
			join monitor.dbo.part part on part.part = shipperdetail.part
			left join monitor.dbo.part parteeh on parteeh.part = shipperdetail.part
			left join monitor.dbo.customer customer on customer.customer = shipper.customer
			left join eehsql1.sistema.dbo.cp_pfaheader pfa on pfa.Shipper=convert(varchar(10),shipper.id)
			left join eehsql1.sistema.dbo.CP_PFADetails pfadetails on pfa.idPFA = pfadetails.idPFA and shipperdetail.part = pfadetails.Parte 
			left join @SerialsInShippment SerialsInShippment on SerialsInShippment.part = shipperdetail.part
		
	where	shipper.ID = @Shipper 

	order by part.product_line desc





GO
