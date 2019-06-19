
/*
Create ScalarFunction.FxEDI.RAWEDIDATA_FS.udf_GetFilePathLocator.sql
*/

use FxEDI
go

if	objectproperty(object_id('RAWEDIDATA_FS.udf_GetFilePathLocator'), 'IsScalarFunction') = 1 begin
	drop function RAWEDIDATA_FS.udf_GetFilePathLocator
end
go

create function RAWEDIDATA_FS.udf_GetFilePathLocator
(	@folderPath nvarchar(max)
)
returns hierarchyid
as
begin
--- <Body>
	declare
		@outputPath hierarchyid

	select
		@outputPath = FS.udf_GetNewChildHierarchyID(red.path_locator)
	from
		dbo.RawEDIData red
	where
		red.is_directory = 1
		and red.file_stream.GetFileNamespacePath() = @folderPath
--- </Body>

---	<Return>
	return
		@outputPath
end
go

