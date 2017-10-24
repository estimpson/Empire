SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [EDI_XML_FNG_ASN].[udf_OrderSerials]
(	@ShipperID int
,	@CustomerPart varchar(30)
,	@PackType varchar(25)
,	@PackQty numeric(20,6)
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
		EDI_XML_FNG_ASN.ASNObjects ao
	where
		ao.ShipperID = @ShipperID
		and ao.CustomerPart = @CustomerPart
		and ao.Quantity = @PackQty
		and ao.PackageType = @PackType
		--(	ao.ParentSerial = @ParentSerial
		--	or
		--	(	ao.ParentSerial is null
		--		and @ParentSerial is null
		--		and ao.Quantity = @PackQty
		--	)
		--)

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
