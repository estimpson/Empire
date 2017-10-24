SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vw_eei_TabularPrice_lastShippedPrice_diff]
as

Select BasePart0,JAN_08, LastShipper1,price, ABS(isNULL(price-JAN_08,0)) absolute_difference,  (isNULL(price,0)-JAN_08) Price_diff from 
(SELECT 
      [BASE_PART] BasePart0
      ,[JAN_08]
      
  FROM [MONITOR].[EEIUser].[acctg_csm_selling_prices_tabular]) TabularPrice 
left join
		(	select	substring(part.part, 1,(PATINDEX( '%[-]%',part.part))-1) as  BasePart1,
					LastShipper1=max (shipper_detail.shipper)
					
			from		part
					join shipper_detail on part.part = shipper_detail.part_original
			where	part.class in(  'P')and
					part.type = 'F' and 
					part.part like '%[-]%'  and 
					part.part not like '%PT%' and
					part.part not like  '%[-]SP%' and
					part.part not like  '%[-]RW%' and
					part.part not like '%[-]FIXT%'
			group by
					substring(part.part, 1,(PATINDEX( '%[-]%',part.part))-1)) LastShipped on TabularPrice.BasePart0= LastShipped.BasePart1
left join
	(	select	isNULL(max(alternate_price),0)as price,
				substring(part.part, 1,(PATINDEX( '%[-]%',part.part))-1) as  BasePart2,
					LastShipper2=max (shipper_detail.shipper)
					
			from		part
					join shipper_detail on part.part = shipper_detail.part_original
			where	part.class in(  'P')and
					part.type = 'F' and 
					part.part like '%[-]%'  and 
					part.part not like '%PT%' and
					part.part not like  '%[-]SP%' and
					part.part not like  '%[-]RW%' and
					part.part not like '%[-]FIXT%'
			group by
					substring(part.part, 1,(PATINDEX( '%[-]%',part.part))-1)) PriceFromLastShipped on LastShipped.BasePart1 = PriceFromLastShipped.BasePart2 and LastShipped.LastShipper1 = PriceFromLastShipped.LastShipper2
where JAN_08 > 0 and JAN_08<>isNULL(price,0)
GO
