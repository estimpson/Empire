SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE view [dbo].[vw_eei_sept2007_ftzinv_excludingelpaso_serial] as
select	object_historical.serial,
		object_historical.part,
		location,
		quantity,
		(quantity *part_standard_historical.material_cum) as Cost,
		(quantity * part_standard_historical.price) as Sales,
		isNULL(nullif(custom4, ''),'X') as two14Number,
		(select date_stamp from audit_trail where serial = object_historical.serial and audit_trail.type = 'R') as receiptDate
from		object_historical
join		part_standard_historical on object_historical.part = part_standard_historical.part 
where	part_standard_historical.period = 9 and 
		part_standard_historical.fiscal_year = 2007 and 
		object_historical.period = 9 and 
		object_historical.fiscal_year = 2007 and 
		object_historical.reason = 'MONTH END' and 
		location <> 'ELPASO' 
GO
