SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
create view [dbo].[vw_eei_sept2007_ftzinv_excludingelpaso] as
select	sum(quantity) as Qty,
		sum(quantity*material_cum) as Cost,
		sum(quantity*part_standard.price) as Sales,
		isNULL(nullif(custom4, ''),'X') as two14Number
from		object_historical
join		part_standard on object_historical.part = part_standard.part 
where	period = 9 and 
		fiscal_year = 2007 and 
		reason = 'MONTH END' and 
		location <> 'ELPASO' and 
		isNULL(nullif(custom4, ''),'X')<>'X'
group by isNULL(nullif(custom4, ''),'X')
GO
