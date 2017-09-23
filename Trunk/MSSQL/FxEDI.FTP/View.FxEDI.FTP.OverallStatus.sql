
/*
Create View.FxEDI.FTP.OverallStatus.sql
*/

use FxEDI
go

--drop table FTP.OverallStatus
if	objectproperty(object_id('FTP.OverallStatus'), 'IsView') = 1 begin
	drop view FTP.OverallStatus
end
go

create view FTP.OverallStatus
as
select
	CurrentDatetime = getdate()
,	FilesMissing = convert(int, 0)
,	CorruptFiles = convert(int, 0)
,	RowID = 1
go

select
	*
from
	FTP.OverallStatus os
go

