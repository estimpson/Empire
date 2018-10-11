
/*
Create Schema.FxEDI.EDI_XML.sql
*/

use FxEDI
go

-- Create the database schema
if	schema_id('EDI_XML') is null begin
	exec sys.sp_executesql N'create schema EDI_XML authorization dbo'
end
go

