SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [EDI_XML_VISTEON_LEGACY_ASN].[udf_OrderSerials]
(	@ShipperID int
,	@CustomerPart varchar(30)
,	@PackQty int
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml = ''

	declare serialREFs cursor local for
	select
		EDI_XML_V4010.SEG_REF('LS', ao.CustomerSerial)
	from
		[EDI_XML_VISTEON_LEGACY_ASN].[ASNObjects] ao
	where
		ao.ShipperID = @ShipperID
		and ao.CustomerPart = @CustomerPart
		and ao.PackQty = @PackQty

	open serialREFs

	while
		1 = 1 begin

		declare @segREF xml

		fetch
			serialREFs
		into
			@segREF

		if	@@FETCH_STATUS != 0 begin
			break
		end

		set	@xmlOutput = convert(varchar(max), @xmlOutput) + convert(varchar(max), @segREF)
	end
--- </Body>

---	<Return>
	return
		@xmlOutput
end

GO
