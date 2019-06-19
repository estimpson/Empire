
/*
Create Schema.EEH.EDI_XML_ACCUM_830.sql
*/

use EEH
go

-- Create the database schema
if	schema_id('EDI_XML_ACCUM_830') is null begin
	exec sys.sp_executesql N'create schema EDI_XML_ACCUM_830 authorization dbo'
end
go

