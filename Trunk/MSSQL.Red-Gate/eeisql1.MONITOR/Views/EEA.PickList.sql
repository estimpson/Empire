SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EEA].[PickList]
as
select
	cs.ProgramCode
,	cs.Machine
,	cs.WODID
,	cs.Part
,	xr.ChildPart
,	QtyRequired = (cs.QtyLabelled - cs.QtyCompleted) * xr.XQty
,	QtyAvailable = alloc.QtyAvailable
,	QtyToPull = (cs.QtyLabelled - cs.QtyCompleted) * xr.XQty - coalesce(alloc.QtyAvailable, 0)
,	FIFOLocation = EEA.fn_GetFIFOLocation_forPart(xr.ChildPart, 'A', null, 'EEA Warehouse', 'N')
,	ProductLine = p.product_line
,	Commodity = p.commodity
,	PartName = p.name
from
	(	select
	 		cs.ProgramCode
		,	cs.Machine
		,	cs.WODID
		,	cs.Part
		,	cs.QtyLabelled
		,	cs.QtyCompleted
	 	from
	 		EEA.CurrentSchedules cs
	 	group by
	 		cs.ProgramCode
		,	cs.Machine
		,	cs.WODID
		,	cs.Part
		,	cs.QtyLabelled
		,	cs.QtyCompleted
	) cs
	join FT.XRt xr
	on
		xr.TopPart = cs.Part
		and
			xr.ChildPart != cs.Part
	join dbo.part p on
		p.part = xr.ChildPart
	left join
	(	select
	 		Part = o.part
	 	,	Machine = o.location
	 	,	QtyAvailable = sum(o.std_quantity)
	 	from
	 		dbo.object o
	 	where
	 		o.status = 'A'
	 	group by
	 		o.part
	 	,	o.location
	) alloc on
		alloc.Part = xr.ChildPart
		and
			alloc.Machine = cs.Machine
where
	cs.QtyLabelled > cs.QtyCompleted
GO
