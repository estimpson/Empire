SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  view [dbo].[vwft_DuplicateDueDate]
as
select	count(1) NumberOfOccurances,
			due_date,
			order_no,
			part_number,
			case when notes like '%Release%' then 'EDIRelease' else 'ManualRelease' end as OrderLineType,
			(select count(distinct part) from object  where left(part,7) = left(part_number,7) ) as PartsInventory,
			(select count(distinct part) from audit_trail  where left(part,7) = left(part_number,7) and date_stamp >= '2011-09-01') as ShippedInventory
from		dbo.order_detail
group by 
			due_date,
			order_no,
			part_number,
			case when notes like '%Release%' then 'EDIRelease' else 'ManualRelease' end 
having count(1) > 1
GO
