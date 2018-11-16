
/*
Create Schema.FxPLM.Portal.sql
*/

use FxPLM
go

-- Create the database schema
if	schema_id('Portal') is null begin
	exec sys.sp_executesql N'create schema Portal authorization dbo'
end
go

