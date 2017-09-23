SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[ftsp_targetinventory_inventory] @part varchar(25)
as

-- dbo.ftsp_targetinventory_Inventory 'NAL0040'

SELECT  Part = o.part ,
                    Qty = SUM(std_quantity),
                    Cost = SUM(std_quantity*material_cum)
            FROM    object O
					JOIN dbo.part_standard ps ON O.part = ps.part
                    LEFT JOIN location l ON o.location = l.code
            WHERE   ISNULL(secured_location, 'N') != 'Y'
                    AND O.part IN ( SELECT  part
                                    FROM    part
                                    WHERE   type = 'F' ) and
                    not exists (select 1 from order_header oh  join customer c on oh.customer = c.customer where c.region_code = 'INTERNAL' and blanket_part = O.part) and left(O.part,7) =@part
            GROUP BY o.part
            order by 1

GO
