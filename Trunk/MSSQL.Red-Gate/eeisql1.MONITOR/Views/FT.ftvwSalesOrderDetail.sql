SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view
  [FT].[ftvwSalesOrderDetail](OrderNo,
  LineID,
  ShipDT,
  PartCode,
  StdQty,
  CustomerCode,
  ShipToCode)
  /*      Description:*/
  /*      Get open sales order details.*/
  as select OrderNO=od.order_no,
    LineID=od.sequence,
    ShipDT=od.due_date,
    PartCode=od.part_number,
    StdQty=od.std_qty,
    CustomerCode=oh.customer,
    ShipToCode=oh.destination
    from dbo.order_detail as od join
    dbo.order_header as oh on od.order_no=oh.order_no
    where od.std_qty>0
GO
