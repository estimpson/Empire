SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



	                                   
CREATE function [EDI_XML_NORPLAS_ASN].[Fn_ASNLinePackQtySerials] (@ShipperID int, @Customerpart varchar(50), @PackType varchar(25), @PackQty int )
--select * from [EDI_XML_NORPLAS_ASN].[Fn_ASNLinePackQtySerials](101868, '365946', 'CNT90', 25 )
returns @Serials table
(	SerialNumber varchar(25)
)

as

Begin

Declare	@ATSerials table
	
	(	SerialNumber int,
		part varchar(25),
		pack_type varchar(35),
		packQty int,
		shipperID int
		)


Insert	@ATSerials
Select Serial,
		part,
		coalesce(at.package_type, 'CNT90'),
		quantity,
		shipper
From
	audit_trail at
where
	at.shipper = convert(varchar(25), @ShipperID ) 
and
	type ='S'
				




Insert @Serials
select
	Convert(varchar(25), at.SerialNumber)
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id and
		s.id = @ShipperID and
		sd.customer_part =  @Customerpart
	join @atSerials at
		on at.part = sd.part
where
	coalesce(s.type, 'N') in ('N', 'M')
and	at.pack_type = @PackType
and at.packQty = @PackQty
and at.shipperID = @ShipperID


return

End

GO
