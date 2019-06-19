
/*
Create Schema.FxEDI.RAWEDIDATA_FS.sql
*/

use FxEDI
go

-- Create the database schema
if	schema_id('RAWEDIDATA_FS') is null begin
	exec sys.sp_executesql N'create schema RAWEDIDATA_FS authorization dbo'
end
go

