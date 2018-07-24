SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [FS].[udf_QT_Files_GetFilePathLocator]
(	@folderPath nvarchar(max)
)
returns hierarchyid
as
begin
--- <Body>
	declare
		@outputPath hierarchyid

	select
		@outputPath =
			case
				when qf.is_directory = 1 then FS.udf_GetNewChildHierarchyID(qf.path_locator)
				else qf.path_locator
			end
	from
		dbo.QT_Files qf
	where
		qf.file_stream.GetFileNamespacePath() = '\QT_Files\' + @folderPath
--- </Body>

---	<Return>
	return
		@outputPath
end

GO
