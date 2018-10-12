SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[eeisp_rpt_materials_audit_part] (@part varchar(25))

as
--eeisp_rpt_materials_audit_part 'TRW0300-HB00'

Begin		
		Select	J.serial as CreatedSerial,
		j.part as CreatedPart,
		J.date_stamp CreatedDate,
		J.Quantity CreatedQty
		
		into  #JobCompletes	
		
From	audit_trail J
where	J.part = @part and
		J.type = 'J'


Select	s.serial as ShippedSerial,
		s.date_stamp as ShippedDateStamp,
		s.shipper as ShipperID,
		s.quantity as ShippedQty
		
into	 #shipments
from	[EEISQL1].[Monitor].[dbo].audit_trail S
where	s.part = @part and
		s.type = 'S'


Select	CreatedPart,
		CreatedSerial,
		CreatedDate,
		CreatedQty,
		ShippedSerial,
		ShippedDateStamp,
		ShipperID,
		ShippedQty,
		location as CurrentLocation,
		object.serial
from	#JobCompletes J
left join	#shipments S on J.Createdserial = S.Shippedserial
left join	object on j.Createdserial = object.serial

end
GO
