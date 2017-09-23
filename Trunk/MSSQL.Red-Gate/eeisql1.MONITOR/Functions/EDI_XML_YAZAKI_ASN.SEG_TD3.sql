SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_YAZAKI_ASN].[SEG_TD3]
(	@equipmentCode varchar(3)
,	@equipmentInitial varchar(12)
,	@equipmentNumber varchar(12)
,	@weightQual varchar (5)
,	@weightMEA varchar(10)
,	@UOM varchar(5)
,	@ownershipCode varchar(1)
,	@sealCode varchar(5)
,	@sealNumber varchar(15)
,	@equipmentType varchar(5)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML_V4010.SEG_INFO('TD3')
			,	EDI_XML_V4010.DE('0040', @equipmentCode)
			,	EDI_XML_V4010.DE('0206', @equipmentInitial)
			,	EDI_XML_V4010.DE('0207', @equipmentNumber)
			,	EDI_XML_V4010.DE('0187', @weightQual)
			,	EDI_XML_V4010.DE('0081', @weightMEA)
			,	EDI_XML_V4010.DE('0355', @UOM)
			,	EDI_XML_V4010.DE('0102', @ownershipCode)
			,	EDI_XML_V4010.DE('0407', @sealCode)
			,	EDI_XML_V4010.DE('0225', @sealNumber)
			,	EDI_XML_V4010.DE('0024', @equipmentType)
			for xml raw ('SEG-TD3'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
