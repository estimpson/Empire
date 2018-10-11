
/*
Create ScalarFunction.EEH.EDI_XML_NET_830.GetReleases_valid.sql
*/

use EEH
go

if	objectproperty(object_id('EDI_XML_NET_830.GetReleases_valid'), 'IsScalarFunction') = 1 begin
	drop function EDI_XML_NET_830.GetReleases_valid
end
go

create function EDI_XML_NET_830.GetReleases_valid
(	@dictionaryVersion varchar(25)
,	@purchaseOrderNumber int
)
returns xml
as
begin
--- <Body>
	declare
		@varcharOutput varchar(max) = ''
	,	@xmlOutput xml

	select
		--@varcharOutput = @varcharOutput + convert(varchar(max), EDI_XML.SEG_FST(@dictionaryVersion, pod.Quantity, pod.SchedType, 'W', pod.DueDT, default, default, default, default, default, default))
		@varcharOutput = @varcharOutput + '
<SEG-FST>
  <SEG-INFO code="FST" name="FORECAST SCHEDULE" />
  <DE code="0380" name="QUANTITY" type="R">' + convert(varchar(12), pod.Quantity) + '</DE>
  <DE code="0680" name="FORECAST QUALIFIER" type="ID" desc="' + case when pod.SchedType = 'C' then 'Firm' when pod.SchedType = 'D' then 'Planning' else 'UNK' end + '">' + pod.SchedType + '</DE>
  <DE code="0681" name="FORECAST TIMING QUALIFIER" type="ID" desc="Discrete">D</DE>
  <DE code="0373" name="DATE" type="DT">' + EDI_XML.FormatDate(@dictionaryVersion, pod.DueDT) + '</DE>
</SEG-FST>'
	from
		EDI_XML_NET_830.PurchaseOrderDetails pod
	where
		pod.PurchaseOrderNumber = @purchaseOrderNumber
	order by
		pod.WeekNo

	set	@xmlOutput = convert(xml, @varcharOutput)

	--declare
	--	releases cursor local for
	--select
	--	EDI_XML.SEG_FST(@dictionaryVersion, pod.Quantity, pod.SchedType, 'W', pod.DueDT, default, default, default, default, default, default)
	--from
	--	EDI_XML_NET_830.PurchaseOrderDetails pod
	--where
	--	pod.PurchaseOrderNumber = @purchaseOrderNumber
	--order by
	--	pod.WeekNo

	--open releases

	--while
	--	1 = 1 begin

	--	declare
	--		@segFST xml

	--	fetch
	--		releases
	--	into
	--		@segFST

	--	if	@@fetch_status != 0 begin
	--		break
	--	end

	--	set @xmlOutput = convert(varchar(max), @xmlOutput) + convert(varchar(max), @segFST)
	--end
--- </Body>

---	<Return>
	return
		@xmlOutput
end
go

select
	EDI_XML_NET_830.GetReleases_valid('004010', 35531)
