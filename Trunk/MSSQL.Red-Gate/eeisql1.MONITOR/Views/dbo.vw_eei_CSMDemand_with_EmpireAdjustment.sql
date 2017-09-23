SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
Create	view [dbo].[vw_eei_CSMDemand_with_EmpireAdjustment]
as

SELECT	BP.Base_Part,
		BPProgram.Program,
		BP.Total_2009 BP2009,
		BP.Total_2010 BP2010,
		BP.Total_2011 BP2011,
		BPProgram.Total_2009 BPProgram2009,
		BPProgram.Total_2010 BPProgram2010,
		BPProgram.Total_2011 BPProgram2011,
		BPEA.Total_2009 BPAdj2009,
		BPEA.Total_2010 BPAdjust2010,
		(BPProgram.Total_2009/nullif(BP.Total_2009,0))*BPEA.Total_2009 as ProgramAdjust2009,
		(BPProgram.Total_2010/nullif(BP.Total_2010,0))*BPEA.Total_2010 as ProgramAdjust2010,
		BPProgram.Total_2009+((BPProgram.Total_2009/nullif(BP.Total_2009,0))*BPEA.Total_2009) as NetProgram2009,
		BPProgram.Total_2010+((BPProgram.Total_2010/nullif(BP.Total_2010,0))*BPEA.Total_2010) as NetProgram2010
FROM	[EEIUser].[acctg_csm_vw_select_total_demand_grouped_by_BP]  BP
JOIN		[EEIUser].[acctg_csm_vw_select_total_demand_grouped_by_BP_program] BPProgram on BP.base_part =  BPProgram.base_part
left join	[EEIUser].[acctg_csm_vw_select_total_demand_grouped_by_BP_EmpireAdjust] BPEA on BP.base_part =  BPEA.base_part
GO
