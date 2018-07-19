
/*
Create Schema.EEH.SupplierEDI_NET.sql
*/

use EEH
go

-- Create the database schema
if	schema_id('SupplierEDI_NET') is null begin
	exec sys.sp_executesql N'create schema SupplierEDI_NET authorization dbo'
end
go

