
/*
Create Schema.FxEDI.EDI_DICT.sql
*/

use FxEDI
go

-- Create the database schema
if	schema_id('EDI_DICT') is null begin
	exec sys.sp_executesql N'create schema EDI_DICT authorization dbo'
end
go

