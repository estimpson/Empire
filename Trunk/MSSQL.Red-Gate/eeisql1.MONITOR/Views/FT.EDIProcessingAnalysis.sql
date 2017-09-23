SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [FT].[EDIProcessingAnalysis]
as
select left(part_number,3) CustID , 
			trading_partner_code, 
			notes, 
			case when notes is null then 'Manual Entry' when notes = 'Planning distributed order.' then 'XML Processed' else 'Executor Processed' end as TypeOfProcessing, 
			count(1) TotalReleaseCount, 
			count(distinct part_number) as PartCount
from		order_detail
join		edi_setups on dbo.order_detail.destination = dbo.edi_setups.destination
where quantity > 1
group by left(part_number,3), trading_partner_code, notes
having isNull(notes,'X') not like 'EEA to%'
GO
