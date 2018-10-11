
print 'Test Generate 830 XML'
print '	NET 830 Tests'
use EEH
go
declare
	@XMLResult xml

set @XMLResult =
	(	select
			EDI_XML_NET_830.Get830('PSG', '52721,48236', '05', 1)
	)

print '		1. Ensure data created is valid xml.'
if	len(convert (varchar(max), @XMLResult))> 0
print '			Passed.'
else
print '			Failed.'

print '		2. Ensure data is correct.'
declare
	@expectedXMLResultText varchar(max) = convert(varchar(max), EDI_XML_NET_830.Get830_valid('PSG', '52721,48236', '05', 1))
,	@actualXMLResultText varchar(max) = convert(varchar(max), @XMLResult)
if	@expectedXMLResultText = @actualXMLResultText
print '			Passed.'
else
print '			Failed.'

go

