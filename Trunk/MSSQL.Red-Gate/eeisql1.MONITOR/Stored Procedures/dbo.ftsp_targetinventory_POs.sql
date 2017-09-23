SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [dbo].[ftsp_targetinventory_POs] @part varchar(25)

as

--dbo.ftsp_targetinventory_POs 'ALC0030'

      SELECT  WeekNo = DATEDIFF(week, ft.fn_TruncDate('wk',GETDATE()), ft.fn_TruncDate('wk',date_due)) ,
					WeekDate =  ft.fn_TruncDate('wk',date_due),
                    Part = part_number ,
                    Qty = SUM(balance),
                    Cost = SUM(balance*material_cum)
            FROM    dbo.po_detail
            JOIN	dbo.part_standard ON po_detail.part_number = part
            WHERE   
					vendor_code = 'EEH'
                    AND balance > 0 and
                    not exists (select 1 from order_header oh  join customer c on oh.customer = c.customer where c.region_code = 'INTERNAL' and blanket_part = po_detail.part_number) and
                    left(part_number,7) = @part
            GROUP BY 
					DATEDIFF(week, ft.fn_TruncDate('wk',GETDATE()), ft.fn_TruncDate('wk',date_due)) ,
					ft.fn_TruncDate('wk',date_due),
                    part_number


GO
