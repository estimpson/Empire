
/*
Create ScalarFunction.MONITOR.EDI_XML_Autosystems_ASN.SEG_PRF.sql
*/

use MONITOR
go

if	objectproperty(object_id('EDI_XML_Autosystems_ASN.SEG_PRF'), 'IsScalarFunction') = 1 begin
	drop function EDI_XML_Autosystems_ASN.SEG_PRF
end
go

create function EDI_XML_Autosystems_ASN.SEG_PRF
(	@poNumber varchar(22)
,	@date char(8)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('004010', 'PRF')
			,	EDI_XML.DE('004010', '0324', @poNumber)
			,	EDI_XML.DE('004010', '0373', @date)
			for xml raw ('SEG-PRF'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
go

select
	EDI_XML_Autosystems_ASN.SEG_PRF('CE800236', '20000100')
go

