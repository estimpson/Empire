SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[acctg_check_transfer_price]

as

select ps.part, oh.price, ps.material_cum from part_standard ps 
	join part p on ps.part = p.part 
	join (select part_number, sum(quantity) as quantity from eehsql1.eeh.dbo.order_detail pd group by part_number) pd on p.part = pd.part_number 
	join (select blanket_part as part_number, price from order_header oh) oh on p.part = oh.part_number	
	
where isnull(oh.price,0) > .01 and isnull(material_cum,0) < .02 and p.type = 'F' and isnulL(pd.quantity,0) > 0


GO
