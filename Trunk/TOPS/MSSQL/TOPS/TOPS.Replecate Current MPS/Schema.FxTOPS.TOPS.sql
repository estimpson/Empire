
/*
Create Schema.FxTOPS.TOPS.sql
*/

use FxTOPS
go

-- Create the database schema
if	schema_id('TOPS') is null begin
	exec sys.sp_executesql N'create schema TOPS authorization dbo'
end
go

