SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [FT].[fn_GetBackflushActivityDetail_byPart]
(	@BeginDT datetime,
	@EndDT datetime,
	@PartProduced varchar (25))
returns	@BackflushActivity table
(	BFID int,
	SerialProduced int,
	JCDT datetime,
	QtyProduced numeric (20,6),
	CostProduced numeric (20,6),
	PartConsumed varchar (25),
	QtyRequired numeric (20,6),
	QtyIssued numeric (20,6),
	CostIssued numeric (20,6))
as
begin
	declare	@Machine varchar (10),
		@Department varchar (25)
	
	select	@Machine = part_machine.machine,
		@Department = location.group_no
	from	part_machine
		join location on part_machine.machine = location.code
	where	part_machine.part = @PartProduced and
		part_machine.sequence = 1
	
	declare	@XRt table
	(	ID int primary key,
		TopPart varchar (25),
		ChildPart varchar (25),
		Department varchar (25),
		BOMID int,
		Sequence tinyint,
		BOMLevel tinyint,
		XQty numeric (30,12),
		unique (TopPart, ChildPart, Sequence),
		unique (ChildPart, TopPart, Sequence))

	insert	@XRt
	select	ID, TopPart, ChildPart,
		Department = PMDpmt.Department,
		BOMID, Sequence, BOMLevel, XQty
	from	FT.XRt XRt
		left join
		(	select	Part = PrimaryMachine.part,
				Department = Dpt.group_no
			from	part_machine PrimaryMachine
				join location Dpt on PrimaryMachine.Machine = Dpt.code
			where	PrimaryMachine.sequence = 1) PMDpmt on XRt.ChildPart = PMDpmt.Part
	where	TopPart in
		(	select	ChildPart
			from	FT.XRt
			where	TopPart = @PartProduced)

	declare @Requirements table
	(	Part varchar (25) not null,
		XQty numeric (20,6) not null)

	insert	@Requirements
	(	Part,
		XQty)
	select	Part = ChildPart,
		XQty = sum (XRt.XQty)
	from	@XRt XRt
	where	TopPart = @PartProduced and
		BOMLevel >= 1 and
		not exists
		(	select	1
			from	@XRt XRt2
				join @XRt XRt3 on XRt2.TopPart = XRt3.ChildPart and
					XRt3.TopPart = XRt.TopPart
			where	XRt2.Sequence > 0 and
				XRt3.Sequence > 0 and
				XRt.Sequence = XRt2.Sequence + XRt3.Sequence and
				coalesce (XRt3.Department, '') != @Department)
	group by
		ChildPart

	insert	@BackflushActivity
	select	BackFlushHeaders.ID,
		BackflushHeaders.SerialProduced,
		JC.JCDT,
		BackFlushHeaders.QtyProduced,
		CostProduced = BackFlushHeaders.QtyProduced * part_standard.material_cum,
		PartConsumed = Requirements.Part,
		QtyRequired = BackFlushHeaders.QtyProduced * Requirements.XQty,
		QtyIssued = BackflushCosts.QtyIssued,
		BackflushCosts.CostIssued
	from	BackFlushHeaders
		cross join
		(	select	Part,
				XQty = sum (XQty)
			from	@Requirements
			group by
				Part) Requirements
		left join
		(	select	BFID,
				PartConsumed,
				QtyIssued = sum (QtyIssue),
				CostIssued = sum (QtyIssue * material_cum)
			from	BackFlushDetails
				join part_standard on BackFlushDetails.PartConsumed = part_standard.part
			group by
				BackFlushDetails.BFID,
				PartConsumed) BackflushCosts on BackFlushHeaders.ID = BackflushCosts.BFID and
			Requirements.Part = BackflushCosts.PartConsumed
		join part_standard on BackFlushHeaders.PartProduced = part_standard.part
		join (	select	SerialProduced = serial,
				JCDT = date_stamp
			from	audit_trail AssyPotJC
			where	type = 'J' and date_stamp between @BeginDT and @EndDT and part = @PartProduced) JC on BackFlushHeaders.SerialProduced = JC.SerialProduced
	order by
		BackFlushHeaders.PartProduced,
		BackFlushHeaders.ID,
		Requirements.Part

	return
end
GO
