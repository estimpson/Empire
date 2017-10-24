SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [HN].[USP_RPT_WeeksOnHand]( 
				@OpenOrderDate datetime )
as
select	ReportDT = @OpenOrderDate, Orders.Part, Part.Product_Line, buyer, Cost_cum,
		standard_pack, Inventory, OrderPastDue, OpenOrders, RequireQtyUpToSpecificDT, 
		ShortQty = case when isnull(Inventory,0) < RequireQtyUpToSpecificDT then isnull(Inventory,0) - RequireQtyUpToSpecificDT else 0 end,
		EEHPOCurrentProductionWeek = ProductionRequested.balance
from      (
            SELECT  Part, 
                    OrderPastDue = sum( case when due_date < PastDueEnd then quantity else 0 end),
                    OpenOrders = ceiling(SUM( case when due_date >= PastDueEnd and due_date < EndDT then quantity else 0 end) / 4),
                    RequireQtyUpToSpecificDT = ceiling(SUM( case when due_date < ShortDate then quantity else 0 end)) 
            from      (
                        select  part = part_number, PastDueEnd, due_date = convert(date,dateadd(d, -datepart(weekday, due_date) + 2, due_date)),
								Quantity = sum(Quantity),  EndDT, ShortDate
                        FROM   MONITOR.dbo.order_detail order_detail
                                join (select        StartDT = convert(date,dateadd(d, -datepart(weekday, getdate()) + 2, getdate())),
                                                    PastDueEnd = dateadd(week, 2, convert(date,dateadd(d, -datepart(weekday, getdate()) + 2, getdate()))),
                                                    EndDT = Dateadd( week, 6, convert(date,dateadd(d, -datepart(weekday, getdate()) + 2, getdate()))),
                                                    ShortDate = Dateadd( week, 1, @OpenOrderDate ) ) RangeDT
                                                                        on order_detail.due_date < EndDT
                        WHERE part_number Not Like '%pt%'
                                                        and quantity > 0
                        group by part_number, PastDueEnd, convert(date,dateadd(d, -datepart(weekday, due_date) + 2, due_date)),
					ShortDate, EndDT ) Orders

            GROUP BY part ) orders
            left join MONITOR.dbo.part_inventory on part_inventory.part = orders.part
			join MONITOR.dbo.part part on part.part = orders.part
			join MONITOR.dbo.part_standard PS on PS.part = orders.part
				left join (	SELECT	
									po_detail.part_number, po_detail.balance, buyer
							FROM MONITOR.dbo.po_detail po_detail
									join MONITOR.dbo.po_header po_header on po_header.po_number = po_detail.po_number
							WHERE (po_detail.vendor_code='eeh') AND (isNULL(truck_number,'XXX')<>'ASB')
									and po_detail.date_due = convert(date,dateadd(d, 14 -datepart(weekday, getdate()) + 2, getdate())) 
							) ProductionRequested on ProductionRequested.part_number = orders.part
            left join (	SELECT                part, Inventory = sum(std_Quantity)
                        FROM   MONITOR.dbo.object Object 
                                                        left join MONITOR.dbo.location l on l.code=Object.location
                        where   part<>'pallet' and 
                                                        isnull(l.secured_location,'n') <>'y'
                        group by part ) PartInventories on PartInventories.part = orders.part

GO
