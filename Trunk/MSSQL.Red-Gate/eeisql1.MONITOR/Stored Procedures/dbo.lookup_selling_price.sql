SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[lookup_selling_price] (@part varchar(25))
as
--declare @part varchar(25) = 'DOR0001'

declare @part_number varchar(25) = @part+'%'
select order_no, shipper,date_shipped, part, qty_packed, price  from shipper_detail where part like @part_number order by date_shipped desc

GO
