SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [FT].[fn_GetBackflushActivityDetail]
(	@BeginDT datetime,
	@EndDT datetime)
returns	@BackflushActivity table
(	BFID int,
	SerialProduced int,
	PartProduced varchar (25),
	JCDT datetime,
	QtyProduced numeric (20,6),
	CostProduced numeric (20,6),
	PartConsumed varchar (25),
	QtyRequired numeric (20,6),
	QtyIssued numeric (20,6),
	CostIssued numeric (20,6),
	QtyOverage numeric (20,6),
	CostOverage numeric (20,6))
as
/*
declare	@BeginDT datetime,
	@EndDT datetime

set	@BeginDT = '2008-02-26'
set	@EndDT = '2009-01-01'

select	*
from	FT.fn_GetBackflushActivityDetail (@BeginDT, @EndDT)
where	PartProduced in
	(	select	part
		from	part_machine
		where	machine in
			(	select	code
				from	location
				where	group_no in ('ENSAMBLE','POTTING')))
order by
	PartConsumed,
	BFID
*/
begin
	insert	@BackflushActivity
	select	BFID = BackFlushHeaders.ID,
		SerialProduced = BackflushHeaders.SerialProduced,
		PartProduced = BackFlushHeaders.PartProduced,
		JCDT = JC.JCDT,
		QtyProduced = BackFlushHeaders.QtyProduced,
		CostProduced = BackFlushHeaders.QtyProduced * part_standard.material_cum,
		PartConsumed = BackflushCosts.PartConsumed,
		QtyRequired = BackflushCosts.QtyIssued + BackflushCosts.QtyOverage,
		QtyIssued = BackflushCosts.QtyIssued,
		CostIssued = BackflushCosts.CostIssued,
		QtyOverage = BackflushCosts.QtyOverage,
		CostOverage = BackflushCosts.CostOverage
	from	BackFlushHeaders
		join
		(	select	BFID,
				PartConsumed,
				QtyIssued = coalesce (sum (QtyIssue), 0),
				CostIssued = coalesce (sum (QtyIssue * material_cum), 0),
				QtyOverage = coalesce (sum (QtyOverage), 0),
				CostOverage = coalesce (sum (QtyOverage * material_cum), 0)
			from	BackFlushDetails
				join part_standard on BackFlushDetails.PartConsumed = part_standard.part
			group by
				BackFlushDetails.BFID,
				PartConsumed) BackflushCosts on BackFlushHeaders.ID = BackflushCosts.BFID
		join part_standard on BackFlushHeaders.PartProduced = part_standard.part
		join (	select	SerialProduced = serial,
				JCDT = date_stamp
			from	audit_trail AssyPotJC
			where	type = 'J' and date_stamp between @BeginDT and @EndDT) JC on BackFlushHeaders.SerialProduced = JC.SerialProduced
	return
end
GO
