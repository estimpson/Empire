
/*
Create schema Schema.MONITOR.EDI_XML_Autosystems_ASN.sql
*/

use MONITOR
go

-- Create the database schema
if	schema_id('EDI_XML_Autosystems_ASN') is null begin
	exec sys.sp_executesql N'create schema EDI_XML_Autosystems_ASN authorization dbo'
end
go

