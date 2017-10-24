SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[msp_calc_costs_FT] (@part varchar(25)=null, @cost_bucket char(1)='S') as
--------------------------------------------------------------------------------------------------------------------------
--
--	Procedure 	msp_calc_costs
--	Arguments	part varchar(25)
--			cost bucket char(1) ie S/P/Q/F
--	Purpose		To rollup the cost from it's components for the specified part
--
--	Logic		
--		Declare variables
--		Create Temp tables
--		Initialize
--		Process data in temp table #bom_parts starting from the top part
--			process all component parts
--		processing the costing rollup from the deepest level 
--		process all the rows in the temp table in the reverse order (cost rolls up from inner most to top part)
--			calculate labor & burden
--			update part_standard table with the new values for the current part
--
--	Development	GPH
--------------------------------------------------------------------------------------------------------------------------
Begin


--EXECUTE	[FT].[ftsp_RebuildXRt] 

--commit
			


if @Part > '' begin
	select	*
	into	#XRt
	from	FT.XRt
	where	TopPart in
		(	select	ChildPart
			from	FT.XRt
			where	TopPart = @Part )

	update	part_standard
	set	labor = vwPartStandardAccum.Labor,
		burden = vwPartStandardAccum.Burden,
		cost = vwPartStandardAccum.Cost,
		material_cum = vwPartStandardAccum.MaterialAccum,
		labor_cum = vwPartStandardAccum.LaborAccum,
		burden_cum = vwPartStandardAccum.BurdenAccum,
		cost_cum = vwPartStandardAccum.CostAccum
	from	part_standard
		join
		(	select	vwPartStandard.Part,
				Cost = vwPartStandard.Material + vwPartStandard.Labor + vwPartStandard.Burden,
				vwPartStandard.Material,
				vwPartStandard.Labor,
				vwPartStandard.Burden,
				CostAccum = sum ( XRt.XQty * ( Child.Material + Child.Labor + Child.Burden ) ),
				MaterialAccum = sum ( XRt.XQty * Child.Material ),
				LaborAccum = sum ( XRt.XQty * Child.Labor ),
				BurdenAccum = sum ( XRt.XQty * Child.Burden )
			from	vwPartStandard
				join #XRt XRt on vwPartStandard.Part = XRt.TopPart
				join vwPartStandard Child on XRt.ChildPart = Child.Part
			group by
				vwPartStandard.Part,
				vwPartStandard.Material,
				vwPartStandard.Burden,
				vwPartStandard.Labor ) vwPartStandardAccum on part_standard.part = vwPartStandardAccum.Part
end
else begin
	update	part_standard
	set	labor = vwPartStandardAccum.Labor,
		burden = vwPartStandardAccum.Burden,
		cost = vwPartStandardAccum.Cost,
		material_cum = vwPartStandardAccum.MaterialAccum,
		labor_cum = vwPartStandardAccum.LaborAccum,
		burden_cum = vwPartStandardAccum.BurdenAccum,
		cost_cum = vwPartStandardAccum.CostAccum
	from	part_standard
		join vwPartStandardAccum on part_standard.part = vwPartStandardAccum.Part
end
end
GO
