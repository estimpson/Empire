
/*
Create Schema.EEH.SupplierEDI.sql
*/

use EEH
go

-- Create the database schema
if	schema_id('SupplierEDI') is null begin
	exec sys.sp_executesql N'create schema SupplierEDI authorization dbo'
end
go

