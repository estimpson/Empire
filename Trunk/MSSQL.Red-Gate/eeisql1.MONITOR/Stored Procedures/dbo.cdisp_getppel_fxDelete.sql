SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[cdisp_getppel_fxDelete] as
begin
  select part_eecustom.part,
    part_eecustom.prod_end,
    part_eecustom.prod_pre_end
    from part_eecustom
    where isnull(part_eecustom.prod_pre_end,0)>0
    and dateadd(wk,(isnull(prod_pre_end,0)*-1),prod_end)>=getdate()
    and getdate()<prod_end
end

GO
