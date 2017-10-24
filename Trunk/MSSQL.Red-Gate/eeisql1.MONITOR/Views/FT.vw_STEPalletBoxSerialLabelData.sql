SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- =============================================
-- Author:		Elvis Alas
-- Create date: 2017-02-13
-- Description:	Returns rows for pallet and box labels for Nascote Labels 2D
-- =============================================
CREATE  view [FT].[vw_STEPalletBoxSerialLabelData]
AS

Select 
		sd.customer_part as CustomerPart,
		p.name as PartName,
		o.quantity as Quantity,
		sd.customer_po as CustomerPO,
		es.supplier_code as SupplierCode,
		o.serial as Serial,
		'S'+CONVERT(varchar(25), o.serial) as BarcodeSerial,
		coalesce(nullif(o.lot, ''), convert(varchar(25),o.serial) ) as LotNumber,
		s.id as ShipperID,
		'S' as TypeInd,
		barcode2d=null
		
	From
		shipper s
	Join
		shipper_detail sd on sd.shipper = s.id
	join
		edi_setups es on es.destination = s.destination
	join
		part p on p.part  = sd.part_original
	Join
		object  o on o.shipper = s.id and o.part = sd.part_original
	Where
		o.part!= 'Pallet'

	
	Union
			
		Select 
		sd.customer_part as CustomerPart,
		max(p.name) as PartName,
		sum(o.quantity) as Quantity,
		max(sd.customer_po) as CustomerPO,
		max(es.supplier_code) as SupplierCode,
		o.parent_serial as Serial,
		'M'+CONVERT(varchar(25), o.parent_serial) as BarcodeSerial,
		max(coalesce(nullif(o.lot, ''), convert(varchar(25),o.parent_serial) ) ) as LotNumber,
		max(s.id) as ShipperID,
		'M' as TypeInd,
		barcode2d='[)>*VEES083*P'+sd.customer_part+'*Q'+convert(varchar,convert(int,sum(o.quantity)))+'*K'+max(sd.customer_po)+'*M'+convert(varchar,o.parent_serial)+'*1T'+max(coalesce(nullif(o.lot, ''), convert(varchar(25),o.parent_serial) ) )+'*'
		
	From
		shipper s
	Join
		shipper_detail sd on sd.shipper = s.id
	join
		edi_setups es on es.destination = s.destination
	join
		part p on p.part  = sd.part_original
	Join
		object  o on o.shipper = s.id and o.part = sd.part_original
	Where
		o.part!= 'Pallet'  
		and		exists ( select 1 from object o2 where o2.serial = o.parent_serial and o2.shipper = o.shipper ) 
		and	exists ( select 1 from object o3  join shipper_detail sd2 on sd2.shipper = o3.shipper and sd2.part_original =  o3.part where o3.parent_serial = o.parent_serial group by o3.parent_serial having MIN(sd2.customer_part) =  MAX(sd2.customer_part) )
		Group by 
		sd.customer_part,
		o.parent_serial,
		CONVERT(varchar(25), o.parent_serial)

	



GO
