
/*
Create Schema.MONITOR.TOPS.sql
*/

use MONITOR
go

-- Create the database schema
if	schema_id('TOPS') is null begin
	exec sys.sp_executesql N'create schema TOPS authorization dbo'
end
go

