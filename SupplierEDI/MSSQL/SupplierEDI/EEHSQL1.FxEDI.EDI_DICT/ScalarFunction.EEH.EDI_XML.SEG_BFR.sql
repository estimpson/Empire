
/*
Create ScalarFunction.EEH.EDI_XML.SEG_BFR.sql
*/

use EEH
go

if	objectproperty(object_id('EDI_XML.SEG_BFR'), 'IsScalarFunction') = 1 begin
	drop function EDI_XML.SEG_BFR
end
go

create function EDI_XML.SEG_BFR
(	@dictionaryVersion varchar(25)
,	@transactionSetPurposeCode char(2)
,	@referenceIdentification varchar(30) = null
,	@releaseNumber varchar(30) = null
,	@scheduleTypeQualifier char(2)
,	@scheduleQuantityQualifier char(1)
,	@date1 datetime
,	@date2 datetime = null
,	@date3 datetime
,	@date4 datetime = null
,	@contractNumber varchar(30) = null
,	@purchaseOrderNumber varchar(22) = null
,	@planningScheduleTypeCode char(2) = null
,	@actionCode varchar(2) = null
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO(@dictionaryVersion, 'BFR')
			,	EDI_XML.DE(@dictionaryVersion, '0353', @transactionSetPurposeCode)
			,	case when @referenceIdentification is not null then EDI_XML.DE(@dictionaryVersion, '0127', @referenceIdentification) end
			,	case when @releaseNumber is not null then EDI_XML.DE(@dictionaryVersion, '0328', @releaseNumber) end
			,	EDI_XML.DE(@dictionaryVersion, '0675', @scheduleTypeQualifier)
			,	EDI_XML.DE(@dictionaryVersion, '0676', @scheduleQuantityQualifier)
			,	EDI_XML.DE(@dictionaryVersion, '0373', EDI_XML.FormatDate(@dictionaryVersion, @date1))
			,	EDI_XML.DE(@dictionaryVersion, '0373', EDI_XML.FormatDate(@dictionaryVersion, @date2))
			,	EDI_XML.DE(@dictionaryVersion, '0373', EDI_XML.FormatDate(@dictionaryVersion, @date3))
			,	EDI_XML.DE(@dictionaryVersion, '0373', EDI_XML.FormatDate(@dictionaryVersion, @date4))
			,	case when @contractNumber is not null then EDI_XML.DE(@dictionaryVersion, '0367', @contractNumber) end
			,	case when @purchaseOrderNumber is not null then EDI_XML.DE(@dictionaryVersion, '0324', @purchaseOrderNumber) end
			,	case when @planningScheduleTypeCode is not null then EDI_XML.DE(@dictionaryVersion, '0783', @planningScheduleTypeCode) end
			,	case when @actionCode is not null then EDI_XML.DE(@dictionaryVersion, '0306', @actionCode) end
			for xml raw ('SEG-BFR'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
go

select
	EDI_XML.SEG_BFR('004010', '05', default, '050078924', 'SH', 'A', '2015-012-02', '2016-09-01', '2015-12-02', default, default, default, default, default)
