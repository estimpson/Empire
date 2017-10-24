
/*
Create ScalarFunction.FxEDI.FS.udf_GetNextRawEDIData_OutboundXML_FileName.sql
*/

use FxEDI
go

if	objectproperty(object_id('FS.udf_GetNextRawEDIData_OutboundXML_FileName'), 'IsScalarFunction') = 1 begin
	drop function FS.udf_GetNextRawEDIData_OutboundXML_FileName
end
go

create function FS.udf_GetNextRawEDIData_OutboundXML_FileName
(	@outboundPath sysname
)
returns nvarchar(max)
as
begin
--- <Body>
	declare
		@newOutboundFileName nvarchar(max)
	,	@outboundFileNumber int

	select
		@outboundFileNumber = max(coalesce
		(	convert(int, substring(redOutboundFiles.name, 9, 5)) + 1
		,	1
		))
	from
		dbo.RawEDIData redOutboundFolder
		left join dbo.RawEDIData redOutboundFiles
			on redOutboundFiles.parent_path_locator = redOutboundFolder.path_locator
			and redOutboundFiles.is_directory = 0
			and redOutboundFiles.name like 'outbound[0-9][0-9][0-9][0-9][0-9].xml'
	where
		redOutboundFolder.file_stream.GetFileNamespacePath() = @outboundPath
		and redOutboundFolder.is_directory = 1

	select
		@newOutboundFileName = N'outbound' + right(N'0000' + convert(varchar, @outboundFileNumber), 5) + N'.xml'
--- </Body>

---	<Return>
	return
		@newOutboundFileName
end
go

