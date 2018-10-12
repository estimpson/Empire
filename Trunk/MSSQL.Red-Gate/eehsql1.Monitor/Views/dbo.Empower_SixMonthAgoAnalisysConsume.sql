SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*
Select	*
from	hn.Empower_SixMonthAgoAnalisysConsume
where	item='MACM25X300-NIL-NIL-CH'
*/
CREATE view [dbo].[Empower_SixMonthAgoAnalisysConsume]
as
Select	IssueTotal.item,
		LeadTimeMonthly = isnull(nullif(LeadTimeMonthly,0),-1),	
		TotalIssue = ceiling(sum(totalissue)),
		MAXIssue = ceiling(max(totalIssue)),
		AGVIssue = sum(totalIssue)/6.0
from (
		Select item,
        Month(gl_date) as Period,
        totalIssue= sum(quantity)
	from   EEH_Empower.dbo.vr_item_transactions_no_serials
	where  item_transaction_type='issue'
			and gl_date >= DATEADD(month,-6,getdate())
	group by item, month(gl_date) 
) IssueTotal
left join (select item,LeadTimeMonthly=  convert(numeric(20,2),attribute_value)/30.00
		from EEH_Empower.dbo.item_attributes 
		where attribute='INTEGER1' and attribute_template='ITEM' and IsNumeric(attribute_value + '.0e0') = 1 AND attribute_value IS NOT NULL --and attribute_value >0
		)LeadTime
	on LeadTime.item = IssueTotal.item
group by  issuetotal.item, LeadTimeMonthly








GO
