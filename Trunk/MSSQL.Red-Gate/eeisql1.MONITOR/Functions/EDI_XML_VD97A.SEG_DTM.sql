SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [EDI_XML_VD97A].[SEG_DTM]
(	@dateID varchar(5)
,	@shipDate datetime
,   @dateFormat varchar(5)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	declare
		@xmlDTFormat varchar(25)

	select
		@xmlDTFormat = devc.Description
	from
		FxEDI.EDI_DICT.DictionaryElementValueCodes devc
	where
		devc.DictionaryVersion = coalesce
			(	(	select
						deR.DictionaryVersion
					from
						FxEDI.EDI_DICT.DictionaryElements deR
					where
						deR.DictionaryVersion = '00D97A'
						and deR.ElementCode = '2379'
				)
			,	(	select
						max(deP.DictionaryVersion)
					from
						FxEDI.EDI_DICT.DictionaryElements deP
					where
						deP.DictionaryVersion < '00D97A'
						and deP.ElementCode = '2379'
				)
			,	(	select
						min(deP.DictionaryVersion)
					from
						FxEDI.EDI_DICT.DictionaryElements deP
					where
						deP.DictionaryVersion > '00D97A'
						and deP.ElementCode = '2379'
				)
			)
		and  devc.ElementCode = '2379'
		and devc.ValueCode = @dateFormat

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D97A', 'DTM')
			,	EDI_XML_VD97A.CE('C507', convert(xml, convert(varchar(max), EDI_XML_VD97A.DE('2005', @DateID)) + convert(varchar(max), EDI_XML_VD97A.DE('2380', EDI_XML.FormatDateTime(@shipDate, @xmlDTFormat))) + convert(varchar(max), EDI_XML_VD97A.DE('2379', @dateFormat))))
			for xml raw ('SEG-DTM'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
