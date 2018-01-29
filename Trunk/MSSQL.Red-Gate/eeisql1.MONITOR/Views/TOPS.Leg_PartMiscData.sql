SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [TOPS].[Leg_PartMiscData]
as
select
	Part = p.part
,	Description = p.name
,	CrossRef = p.cross_ref
,	Type = p.type
,	UserDefined1 = p.user_defined_1
,	StandardPack = pInv.standard_pack
,	Price = pcpm.price
,	LongestLT = pInv.longest_lt
,	MinProdRun = pInv.min_prod_run
,	ProdEnd = pe.prod_end
,	EAU = pe.eau
,	ProdStart = po.prod_start
,	ProdEnd2 = po.prod_end
from
	dbo.part p
	cross apply
		(	select top 1
				pcpm.price
			from
				dbo.part_customer_price_matrix pcpm
			where
				pcpm.part = p.part
			order by
				pcpm.part
			,	pcpm.qty_break
		) pcpm
	join dbo.part_eecustom pe
		on pe.part = p.part
	join dbo.part_inventory pInv
		on pinv.part = p.part
	join dbo.part_online po
		on po.part = p.part
where
	p.type = 'F'
GO
