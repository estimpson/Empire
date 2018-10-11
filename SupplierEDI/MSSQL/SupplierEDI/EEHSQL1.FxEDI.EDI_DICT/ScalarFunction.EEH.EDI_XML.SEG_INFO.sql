
/*
Create ScalarFunction.EEH.EDI_XML.SEG_INFO.sql
*/

use EEH
go

if	objectproperty(object_id('EDI_XML.SEG_INFO'), 'IsScalarFunction') = 1 begin
	drop function EDI_XML.SEG_INFO
end
go

create function EDI_XML.SEG_INFO
(	@dictionaryVersion varchar(25)
,	@segmentCode varchar(25)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
	/*	CE */
		(	select
				code = dsc.Code
			,	name = dsc.Description
			from
				FxEDI_EDI_DICT.DictionarySegmentCodes dsc
			where
				dsc.DictionaryVersion = coalesce
					(	(	select
						 		dscR.DictionaryVersion
						 	from
						 		FxEDI_EDI_DICT.DictionarySegmentCodes dscR
							where
								dscR.DictionaryVersion = @dictionaryVersion
								and dscR.Code = @segmentCode
						)
					,	(	select
						 		max(dscP.DictionaryVersion)
						 	from
						 		FxEDI_EDI_DICT.DictionarySegmentCodes dscP
							where
								dscP.DictionaryVersion < @dictionaryVersion
								and dscP.Code = @segmentCode
						)
					,	(	select
						 		min(dscP.DictionaryVersion)
						 	from
						 		FxEDI_EDI_DICT.DictionarySegmentCodes dscP
							where
								dscP.DictionaryVersion > @dictionaryVersion
								and dscP.Code = @segmentCode
						)
					)
				and dsc.Code = @segmentCode
			for xml raw ('SEG-INFO'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
go

select
	EDI_XML.SEG_INFO('004010', 'CTT')