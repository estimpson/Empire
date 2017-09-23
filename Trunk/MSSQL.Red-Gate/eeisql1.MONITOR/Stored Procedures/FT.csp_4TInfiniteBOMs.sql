SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [FT].[csp_4TInfiniteBOMs]
as
create table #BOMStack
(	TopPart varchar (25),
	ChildPart varchar (25),
	BOMLevel integer default (0) not null,
	BeginOffset integer default (0) not null,
	EndOffset integer default (2147483647) not null,
	Infinite integer default (0) not null )

--	Make looking for infinites faster.
create index idx_#BOMStack_1 on #BOMStack ( TopPart, ChildPart, BOMLevel )

--	Load finished goods into search.
insert	#BOMStack
(	TopPart,
	ChildPart )
select distinct
	parent_part,
	parent_part
from	dbo.bill_of_material
	join dbo.part on dbo.bill_of_material.parent_part = part.part and
		part.type = 'F'

while	@@RowCount > 0
begin
	--	Mark infinites.
	update	#BOMStack
	set	Infinite = 1
	where	exists
		(	select	1
			from	#BOMStack B1
			where	#BOMStack.TopPart = B1.TopPart and
				#BOMStack.BOMLevel > B1.BOMLevel and
				#BOMStack.BeginOffset between B1.BeginOffset and B1.EndOffset and
				#BOMStack.ChildPart = B1.ChildPart )

	--	Add next BOM Level.
	insert	#BOMStack
	(	TopPart,
		ChildPart,
		BOMLevel,
		BeginOffset,
		EndOffset )
	select	#BOMStack.TopPart,
		BOM1.part,
		BOMLevel + 1,
		BeginOffset + ( ( EndOffset - BeginOffset ) /
		(	select	count (1)
			from	dbo.bill_of_material BOM
			where	#BOMStack.ChildPart = BOM.parent_part ) ) *
		(	select	count (1)
			from	dbo.bill_of_material BOM2
			where	#BOMStack.ChildPart = BOM2.parent_part and
				BOM1.part > BOM2.part ) + 1,
		BeginOffset + ( ( EndOffset - BeginOffset ) /
		(	select	count (1)
			from	dbo.bill_of_material BOM
			where	#BOMStack.ChildPart = BOM.parent_part ) ) *
		(	select	count (1)
			from	dbo.bill_of_material BOM2
			where	#BOMStack.ChildPart = BOM2.parent_part and
				BOM1.part >= BOM2.part )
	from	#BOMStack
		join dbo.bill_of_material BOM1 on #BOMStack.ChildPart = BOM1.parent_part
	where	Infinite = 0 and
		BOMLevel =
		(	select	Max ( BOMLevel )
			from	#BOMStack )
end

--	Return results.
--		Make result set faster.
create index idx_#BOMStack_2 on #BOMStack ( TopPart, BeginOffset, ChildPart )

select	TopPart,
	ChildPart,
	BOMLevel,
	Infinite
from	#BOMStack
where	TopPart in
	(	select	TopPart
		from	#BOMStack
		where	Infinite = 1 )
order by
	TopPart,
	BeginOffset,
	ChildPart
GO
