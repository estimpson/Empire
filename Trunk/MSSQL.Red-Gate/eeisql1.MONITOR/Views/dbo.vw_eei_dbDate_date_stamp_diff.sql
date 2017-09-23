SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_dbDate_date_stamp_diff]
as
Select sum(quantity) quantity, type, datePart(dd,date_stamp) typed_date, date_stamp, datePart(dd,dbdate) actual_date, dbDate, part from audit_trail where part = 'ALC0016-HE04' and date_stamp>= '2008-04-01' and datePart(dd,date_stamp)<> datePart(dd,dbdate)
group by
type, datePart(dd,date_stamp), datePart(dd,dbdate), part, date_stamp, dBDate
GO
