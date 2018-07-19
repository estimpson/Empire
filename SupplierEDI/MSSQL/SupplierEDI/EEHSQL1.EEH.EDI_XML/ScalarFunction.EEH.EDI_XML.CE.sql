
/*
Create ScalarFunction.EEH.EDI_XML.CE.sql
*/

use EEH
go

if	objectproperty(object_id('EDI_XML.CE'), 'IsScalarFunction') = 1 begin
	drop function EDI_XML.CE
end
go

create function EDI_XML.CE
(	@dictionaryVersion varchar(25)
,	@elementCode char(4)
,	@de xml
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@elementCode = right('0000' + ltrim(rtrim(@elementCode)), 4)

	set	@xmlOutput =
	/*	CE */
		(	select
				code = de.ElementCode
			,	name = de.ElementName
			/*	DE(s)*/
			,	@de
			from
				FxEDI_EDI_DICT.DictionaryElements de
			where
				de.DictionaryVersion = coalesce
					(	(	select
					 			deR.DictionaryVersion
					 		from
					 			FxEDI_EDI_DICT.DictionaryElements deR
							where
								deR.DictionaryVersion = @dictionaryVersion
								and deR.ElementCode = @elementCode
					 	)
					,	(	select
					 			max(deP.DictionaryVersion)
					 		from
					 			FxEDI_EDI_DICT.DictionaryElements deP
							where
								deP.DictionaryVersion < @dictionaryVersion
								and deP.ElementCode = @elementCode
					 	)
					,	(	select
					 			min(deP.DictionaryVersion)
					 		from
					 			FxEDI_EDI_DICT.DictionaryElements deP
							where
								deP.DictionaryVersion > @dictionaryVersion
								and deP.ElementCode = @elementCode
					 	)
					)
				and de.ElementCode = @elementCode
			for xml raw ('CE'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
go

select
	EDI_XML.CE('004010', 'C002', EDI_XML.DE('004010', '1001', '123'))
