select
	*
from
	dbo.CustomerEDI_GenerationLog cegl

select
	*
from
	dbo.CustomerEDI_GenerationLog_Responses ceglr

select
	*
from
	dbo.edi_setups es

select
	*
from
	FxEDI.EDI_DICT.DictionaryElements de
where
	de.ElementCode = '0146'