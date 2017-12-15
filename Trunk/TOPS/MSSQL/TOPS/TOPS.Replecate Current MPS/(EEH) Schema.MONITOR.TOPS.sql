
/*
Create [EEH] Schema.MONITOR.TOPS.sql
*/

use Monitor
go

-- Create the database schema
if	schema_id('TOPS') is null begin
	exec sys.sp_executesql N'create schema TOPS authorization dbo'
end
go

