SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [EDI_XML_NALPLEX_ASN].[udf_OrderSerials]
(	@ShipperID int
,	@CustomerPart varchar(30)
,	@PackQuantity numeric(20,6)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml = ''
	,	@segREF xml = EDI_XML_V4010.SEG_REF('LS', '[CustomerSerial]')

	declare serials cursor local for
	select
		ao.CustomerSerial
	from
		EDI_XML_NALPLEX_ASN.ASNObjects ao
	where
		ao.ShipperID = @ShipperID
		and ao.CustomerPart = @CustomerPart
		and ao.quantity = @PackQuantity

	open serials

	while
		1 = 1 begin

		declare
			@customerSerial varchar(15)

		fetch
			serials
		into
			@customerSerial

		if	@@FETCH_STATUS != 0 begin
			break
		end

		set	@xmlOutput = convert(varchar(max), @xmlOutput) + replace(convert(varchar(max), @segREF), '[CustomerSerial]', @customerSerial)
	end
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
