SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [HN].[MoldingReport]( @Desde datetime, @Hasta Datetime)
AS
SELECT	Part,
		JC_Extend_Qty = Sum( JC_Extend_Qty ),
		Scrap_Extend_Qty = sum( Scrap_Extend_Qty ),
		MA_Extend_Qty = sum( MA_Extend_Qty - Scrap_Extend_Qty ),
		MI_Extend_Qty  = sum( MI_Extend_Qty ),
		Cost = Max( Cost ),
		Cost_Extend	= Sum( (MI_Extend_Qty - JC_Extend_Qty - Scrap_Extend_Qty - MA_Extend_Qty) * Cost)
FROM	(select	Part = WIPWashTransactions.part,
		JC_Extend_Qty = 0,
		Scrap_Extend_Qty = sum (case when WIPWashTransactions.type = 'Q' and WIPWashTransactions.to_loc = 'S' then std_quantity else 0 end),
		MA_Extend_Qty = Sum (case when WIPWashTransactions.type = 'A' then WIPWashTransactions.std_quantity else 0 end),
		MI_Extend_Qty = Sum (case when WIPWashTransactions.type = 'M' then WIPWashTransactions.std_quantity else 0 end),
		Cost = Max(Costs.material_cum)
	from    audit_trail WIPWashTransactions with (index=idx_audit_trail_date_type_part_std_quantity, ReadUncommitted )
		join part_standard Costs with (readuncommitted) on WIPWashTransactions.part = Costs.part
	where	WIPWashTransactions.type in ('M','A','Q') and
		WIPWashTransactions.date_stamp Between @Desde and @Hasta and
		WIPWashTransactions.part in
		(	select	ChildPart
			from	FT.XRt
			where	TopPart != ChildPart and
				BOMLevel = 1 and
				TopPart in
				(	select	part
					from	part_machine
					where	sequence = 1 and
						machine = 'MOLDEO') and
				ChildPart in
				(	select part from part where commodity = 'COMPOUND' and type = 'R'))
	group by
		WIPWashTransactions.part

	union all

	select  Part = XRt.ChildPart,
		JC_Extend_Qty = Sum (JC_Qty * XRt.XQty),
		Scrap_Extend_Qty = Sum (DE_Qty * XRt.XQty),
		MA_Extend_Qty = 0,
		MI_Extend_Qty = 0,
		Cost = Max(Costs.material_cum)
	from    (	select	part,
				JC_Qty = sum (case when type = 'J' then std_quantity when type = 'D' then std_quantity * -1 else 0 end),
				DE_Qty = sum (case when type = 'Q' and to_loc = 'S' then std_quantity else 0 end)
			from	audit_trail with (index=idx_audit_trail_date_type_part_std_quantity, ReadUncommitted )
			where	type in ('J','Q', 'D') and
				date_stamp between @Desde and @Hasta and
				part in
				(	select	part
					from	part_machine
					where	sequence = 1 and
						machine = 'MOLDEO')
			group by
				part) WIPWashTransactions 
		join FT.XRt XRt on WIPWashTransactions.part = XRt.TopPart and
			XRt.ChildPart in
			(	select part from part where commodity = 'COMPOUND' and type = 'R')
		join part_standard Costs with (readuncommitted) on XRt.ChildPart = Costs.part
	group by
	       XRt.ChildPart) X       
Group by Part
GO
