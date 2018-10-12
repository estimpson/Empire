SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [FT].[fn_GetCurrentRequirements]
()
returns @Requirements table
(	Department varchar (25),
	Machine varchar (10),
	TopPart varchar (25),
	ChildPart varchar (25),
	Sequence smallint,
	Balance numeric (20,6))
as
begin
	insert	@Requirements
	(	Department,
		Machine,
		TopPart,
		ChildPart,
		Sequence,
		Balance)
	select	Department = Schedule.Department,
		Machine = Schedule.Machine,
		TopPart = XRt.TopPart,
		ChildPart = XRt.ChildPart,
		Sequence = XRt.Sequence,
		Balance = Schedule.Balance * XRt.XQty
	from	FT.XRt XRt
		join (	select	Part,
				Balance = max (WODetails.QtyRequired - WODetails.QtyCompleted),
				Machine = max (WOHeaders.Machine),
				Department = max (location.group_no)
			from	WODetails
				join WOHeaders on WODetails.WOID = WOHeaders.ID
				join location on WOHeaders.Machine = location.code
			where	WOHeaders.Status = 0 and (
				WODetails.Part like '[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9]%' or
				WODetails.Part like 'POT-[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9]%' or
				WODetails.Part like 'PRE-[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9]%')
			group by
				Part) Schedule on XRt.TopPart = Schedule.Part
		left join part_machine PM on XRt.ChildPart = PM.part and
			PM.sequence = 1
		left join location PML on PM.machine = PML.code
	where	XRt.BOMLevel >= 1 and
		coalesce (PML.group_no, 'N/A') != Schedule.Department and
		not exists
		(	select	1
			from	FT.XRt XRt2
				join FT.XRt XRt3 on XRt2.TopPart = XRt3.ChildPart and
					XRt3.TopPart = XRt.TopPart
				join part_machine PM on XRt3.ChildPart = PM.part and
					PM.sequence = 1
				join location PML on PM.machine = PML.code
			where	XRt2.Sequence > 0 and
				XRt3.Sequence > 0 and
				XRt.Sequence = XRt2.Sequence + XRt3.Sequence and
				coalesce (PML.group_no, '') != Schedule.Department)
	
	return
end
GO
