SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [EDI_XML_VD07A].[SEG_PAC]
(	@packageCount varchar(10) --7224
,	@PackLevel varchar(3) --7075
,	@TypeOfPackage varchar(3) --7233
,	@packageID varchar(20) --7065
,	@CodeListID varchar(17) --1131
,	@CodeListRespAgency varchar(3) -- 3055
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D07A', 'PAC')
			,	EDI_XML_VD07A.DE('7224', @packageCount)
			,	EDI_XML_VD07A.CE('C531', Convert( varchar(max), EDI_XML_VD07A.DE('7075', @PackLevel)) +  Convert( varchar(max), EDI_XML_VD07A.DE('7233', @TypeOfPackage)) )
			,	EDI_XML_VD07A.CE('C202', Convert( varchar(max), EDI_XML_VD07A.DE('7065', @packageID)) +  Convert( varchar(max), EDI_XML_VD07A.DE('1131', @CodeListID)) + Convert( varchar(max), EDI_XML_VD07A.DE('3055', @CodeListRespAgency)) )
			for xml raw ('SEG-PAC'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end

GO
