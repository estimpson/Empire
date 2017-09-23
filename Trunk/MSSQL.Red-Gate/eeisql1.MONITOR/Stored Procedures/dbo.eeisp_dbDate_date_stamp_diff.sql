SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[eeisp_dbDate_date_stamp_diff] (@part varchar(25), @date datetime)
as
Begin
Select sum(quantity) quantity, type, datePart(dd,date_stamp) typed_date, date_stamp, datePart(dd,dbdate) actual_date, dbDate, part from audit_trail where part = @part and date_stamp>= @date and datePart(dd,date_stamp)<> datePart(dd,dbdate)
group by
type, datePart(dd,date_stamp), datePart(dd,dbdate), part, date_stamp, dBDate
end
GO
