SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML].[SEG_LIN]
(	@dictionaryVersion varchar(25)
,	@productIDQualifier1 char(2)
,	@productID1 varchar(48)
,	@productIDQualifier2 char(2)
,	@productID2 varchar(48)
,	@productIDQualifier3 char(2)
,	@productID3 varchar(48)
,	@productIDQualifier4 char(2)
,	@productID4 varchar(48)
,	@productIDQualifier5 char(2)
,	@productID5 varchar(48)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO(@dictionaryVersion, 'LIN')
			,	EDI_XML.DE(@dictionaryVersion, '0235', @productIDQualifier1)
			,	EDI_XML.DE(@dictionaryVersion, '0234', @productID1)
			,	case when @productID2 is not null then EDI_XML.DE(@dictionaryVersion, '0235', @productIDQualifier2) end
			,	case when @productID2 is not null then EDI_XML.DE(@dictionaryVersion, '0234', @productID2) end
			,	case when @productID3 is not null then EDI_XML.DE(@dictionaryVersion, '0235', @productIDQualifier3) end
			,	case when @productID3 is not null then EDI_XML.DE(@dictionaryVersion, '0234', @productID3) end
			,	case when @productID4 is not null then EDI_XML.DE(@dictionaryVersion, '0235', @productIDQualifier4) end
			,	case when @productID4 is not null then EDI_XML.DE(@dictionaryVersion, '0234', @productID4) end
			,	case when @productID5 is not null then EDI_XML.DE(@dictionaryVersion, '0235', @productIDQualifier5) end
			,	case when @productID5 is not null then EDI_XML.DE(@dictionaryVersion, '0234', @productID5) end
			for xml raw ('SEG-LIN'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
