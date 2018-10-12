SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [FT].[fn_GetBackflushActivitySummary]
(	@BeginDT datetime,
	@EndDT datetime)
returns	@BackflushActivity table
(	BFID int,
	SerialProduced int,
	JCDate datetime,
	PartProduced varchar (25),
	QtyProduced numeric (20,6),
	CostProduced numeric (20,6),
	CostIssued numeric (20,6))
as
begin
	insert	@BackflushActivity
	select	BackFlushHeaders.ID,
		BackflushHeaders.SerialProduced,
--		JCDate = dateadd (day, datediff (day, '2008-01-01', JC.JCDT), '2008-01-01'),
		JCDate = JC.JCDT,
		BackFlushHeaders.PartProduced,
		BackFlushHeaders.QtyProduced,
		CostProduced = BackFlushHeaders.QtyProduced * part_standard.material_cum,
		BackflushCosts.CostIssued
	from	BackFlushHeaders
		join
		(	select	BFID,
				CostIssued = sum (QtyIssue * material_cum)
			from	BackFlushDetails
				join part_standard on BackFlushDetails.PartConsumed = part_standard.part
			group by
				BackFlushDetails.BFID) BackflushCosts on BackFlushHeaders.ID = BackflushCosts.BFID
		join part_standard on BackFlushHeaders.PartProduced = part_standard.part
		join (	select	SerialProduced = serial,
				JCDT = date_stamp
			from	audit_trail AssyPotJC
			where	type = 'J' and date_stamp between @BeginDT and @EndDT and part in
				(	select part from part_machine where machine in
					(	select code from location where group_no in ('REWORK', 'ENSAMBLE', 'POTTING')))) JC on BackFlushHeaders.SerialProduced = JC.SerialProduced
	order by
		BackFlushHeaders.PartProduced,
		BackFlushHeaders.ID

	return
end
GO
