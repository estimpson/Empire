SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[ftsp_targetinventory_Demand] @part varchar(25)
as

-- dbo.ftsp_targetinventory_Demand 'ALC0030'


 SELECT  WeekNo = DATEDIFF(week, ft.fn_TruncDate('wk',GETDATE()), ft.fn_TruncDate('wk',dbo.order_detail.due_date)) ,
					WeekDate =  ft.fn_TruncDate('wk',dbo.order_detail.due_date), 
                    Part = part_number ,
                    Qty = SUM(eeiqty) ,
                    Cost = SUM(eeiqty * material_cum)
            FROM    dbo.order_detail
					join	dbo.order_header on dbo.order_detail.order_no = dbo.order_header.order_no
					join	customer on order_header.customer = customer.customer
                    JOIN dbo.part_standard ON part_number = part
            WHERE   DATEDIFF(week, GETDATE(), order_detail.due_date) <= 16 and
							eeiqty>1 
							and isNull(customer.region_code,'') != 'INTERNAL' and
							left(order_detail.part_number,7) = @part
            GROUP BY 
					DATEDIFF(week, ft.fn_TruncDate('wk',GETDATE()), ft.fn_TruncDate('wk',dbo.order_detail.due_date)) ,
					 ft.fn_TruncDate('wk',dbo.order_detail.due_date),
                    part_number

GO
