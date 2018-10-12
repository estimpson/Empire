SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*
Select	*
from	Monitor.dbo.Empower_3MonthAgoAnalisysConsume
where	item='MACM25X300-NIL-NIL-CH'
*/
CREATE view [dbo].[Empower_3MonthAgoAnalisysConsume]
as
Select	IssueTotal.item,
		LeadTimeMonthly = isnull(nullif(LeadTimeMonthly,0),-1),	
		TotalIssue = ceiling(sum(totalissue)),
		MAXIssue = ceiling(max(totalIssue)),
		AGVIssue = sum(totalIssue)/3.0
from (
	Select item,
        Month(gl_date) as Period,
        totalIssue= sum(quantity)
	from   EEH_Empower.dbo.vr_item_transactions_no_serials
	where  item_transaction_type='issue'
			and gl_date >= DATEADD(month,-3,getdate())
	group by item, month(gl_date) 
) IssueTotal
left join (
	--convert(numeric(20,2),(isnull(attribute_value,0)/30.0))
		select item,LeadTimeMonthly=  convert(numeric(20,2),attribute_value)/30.00
		from EEH_Empower.dbo.item_attributes 
		where attribute='INTEGER1' and attribute_template='ITEM' and IsNumeric(attribute_value + '.0e0') = 1 AND attribute_value IS NOT NULL --and attribute_value >0
		)LeadTime
--Select Item,
--				  LeadTimeMonthly = convert(numeric(18,2),(isnull(lead_time_days,0)/30.0))
--			from	EEH_Empower.dbo.items) LeadTime
	on LeadTime.item = IssueTotal.item
group by  issuetotal.item, LeadTimeMonthly

--Select item,
--        Month(gl_date),
--        totalIssue= sum(quantity)
--from   EEH_Empower.dbo.vr_item_transactions_no_serials
--where  item_transaction_type='issue'
--        and gl_date >= DATEADD(month,-3,getdate())
--group by item, month(gl_date) 
--	   --as IssueTotal


--select * from Monitor.dbo.item_attributes

--select * from EEH.dbo.item_attributes

--select * from EEH_Empower.dbo.vt_item_attributes

--select * from EEH_Empower.dbo.item_attributes where attribute='INTEGER1' and attribute_value>0 and item like 'nt15a%'

--select  lead_time_days,*  from EEH_Empower.dbo.items

--Select	IssueTotal.item,
--		LeadTimeMonthly = isnull(nullif(LeadTimeMonthly,0),-1),	
--		TotalIssue = ceiling(sum(totalissue)),
--		MAXIssue = ceiling(max(totalIssue)),
--		AGVIssue = sum(totalIssue)/3.0
--from (
--	Select item,
--        Month(gl_date) as Period,
--        totalIssue= sum(quantity)
--	from   EEH_Empower.dbo.vr_item_transactions_no_serials
--	where  item_transaction_type='issue'
--			and gl_date >= DATEADD(month,-3,getdate())
--	group by item, month(gl_date) 
--) IssueTotal
--left join (Select Item,
--				  LeadTimeMonthly = convert(numeric(18,2),(isnull(integer_1,0)/30.0))
--			from	Monitor.dbo.item_attributes) LeadTime
--	on LeadTime.item = IssueTotal.item
--group by  issuetotal.item, LeadTimeMonthly


GO
