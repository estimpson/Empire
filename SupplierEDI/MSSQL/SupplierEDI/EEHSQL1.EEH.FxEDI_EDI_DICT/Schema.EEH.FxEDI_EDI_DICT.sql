
/*
Create Schema.EEH.FxEDI_EDI_DICT.sql
*/

use EEH
go

-- Create the database schema
if	schema_id('FxEDI_EDI_DICT') is null begin
	exec sys.sp_executesql N'create schema FxEDI_EDI_DICT authorization dbo'
end
go

