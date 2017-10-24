SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure
[dbo].[eeisp_rpt_RFReceiptAnalysis](@Fromdate datetime,@Throughdate datetime)
as
create table #PartVendorReceipts(
  part varchar(50) null,
  vendor varchar(15) null,
  wkreceived varchar(10) null,
  )
insert into #PartVendorReceipts
  select distinct part,
    vendor,
    convert(varchar(4),datepart(yy,date_stamp))+(case when datepart(wk,date_stamp)<10 then('0'+convert(varchar(2),datepart(wk,date_stamp))) else convert(char(2),datepart(wk,date_stamp))
    end)
    from audit_trail
    where type='R'
    and date_stamp>=@fromdate
    and date_stamp<dateadd(dd,1,@throughdate)
select part,vendor,
  rfreceiptsTotal=(select count(1)
    from audit_trail as at2
    where at2.date_stamp>=@Fromdate and at2.date_stamp<@throughdate and(field1='RFReceipt' or field1='') and at2.vendor=#partVendorReceipts.vendor and at2.part=#partVendorReceipts.part and at2.type='R' and(convert(varchar(4),datepart(yy,at2.date_stamp))+convert(varchar(2),datepart(wk,at2.date_stamp)))=wkreceived),
  TotalReceipts=(select count(1)
    from audit_trail as at2
    where at2.date_stamp>=@Fromdate and at2.date_stamp<@throughdate and at2.vendor=#partVendorReceipts.vendor and at2.part=#partVendorReceipts.part and at2.type='R' and(convert(varchar(4),datepart(yy,at2.date_stamp))+convert(varchar(2),datepart(wk,at2.date_stamp)))=wkreceived),
  Wkreceived
  from #partVendorReceipts order by
  1 asc,2 asc,5 asc
  
GO
