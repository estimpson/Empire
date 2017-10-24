SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[cdivw_podata_fxDelete]
  as select vendor_code,part_number,datepart(wk,date_due) as dweek,po_number,sum(quantity) as qnty,sum("received") as rcvd
    from dbo.po_detail join
    dbo.part_vendor as pv on pv.vendor=po_detail.vendor_code and pv.part=po_detail.part_number
    where po_number=any(select po_number from dbo.po_header where isnull(status,'A')<>'C')
    and date_due<getdate()
    group by vendor_code,part_number,datepart(wk,date_due),po_number
GO
