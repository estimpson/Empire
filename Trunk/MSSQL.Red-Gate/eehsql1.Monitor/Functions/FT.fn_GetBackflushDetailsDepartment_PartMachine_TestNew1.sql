SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FT].[fn_GetBackflushDetailsDepartment_PartMachine_TestNew1]
(	@BFID int)
returns numeric (20,6)
as
begin
	declare @Return numeric (20,6)

	select	@Return = sum ((QtyIssue + QtyOverage) * part_standard.material_cum)
	from	FT.fn_GetBackflushDetailsDepartment_PartMachine_TestNew (@BFID) BFD
		left join part_standard on BFD.Part = part_standard.part
	
	return	@Return
end
GO
