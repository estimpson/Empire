SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	procedure	[dbo].[eeisp_remove_duplicate_sales_forecast]
as
begin
set nocount on
Select	lastforecastperday.forecast_name,
		lastforecastperday.time_stamp,
	[program_manager]
      ,[customer]
      ,[base_part]
      ,[forecast_year]
      ,[forecast_period]
      ,[forecast_units]
      ,[selling_price]
      ,[forecast_sales] into  sales_1_temp from (Select max(time_stamp)time_stamp, forecast_name
from		eeiuser.sales_1
group by forecast_name) lastforecastperday join eeiuser.sales_1	 on lastforecastperday.time_stamp = eeiuser.sales_1.time_stamp and lastforecastperday.forecast_name = eeiuser.sales_1.forecast_name

if	@@error != 0 begin
	return -1
end
EXECUTE sp_changeobjectowner 'EEIUser.sales_1', 'dbo'
execute	sp_rename
	'sales_1',
	'sales_1_old'
if	@@error != 0 begin
	return -1
end

execute	sp_rename
	'sales_1_temp',
	'sales_1'
if	@@error != 0 begin
	return -1
end

drop table
	sales_1_old
if	@@error != 0 begin
	return -1
end
EXECUTE sp_changeobjectowner 'dbo.sales_1', 'EEIUser'
end
GO
