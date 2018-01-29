SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE View [EDI].[vwIgnoreShippersForASN] as

--2018-01-09 Andre S. Boulanger FT, LLC : View created to be used in procedure [EDI].[usp_CustomerEDI_SendShipNotices] so that ASNs are not sent under certain cases. This view returns shipper.id for shippers for whicjh and ASN should not be sent

-- Autosystems only wants ASNs for production POs
Select	
	ShipperID = s.id
From
	shipper s
Join
	edi_setups es on es.destination = s.destination 
	and es.asn_overlay_group = 'AO7' --Decoma destinations
	and exists 
		( Select 1 
			from 
				shipper_detail sd 
			where 
				sd.shipper = s.id and 
				sd.part not like '%CUM%' and
				right(isNULL(nullif(RTRIM(LTRIM(sd.customer_po)),''),'x'),1) like '%[a-Z]%' )

GO
