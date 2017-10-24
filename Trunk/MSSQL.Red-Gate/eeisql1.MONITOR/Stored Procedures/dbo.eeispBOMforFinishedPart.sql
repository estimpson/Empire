SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure
[dbo].[eeispBOMforFinishedPart](@Regen char(1)= 'N',@finishedgood varchar(25))
/*	Example:*/
as /*	execute	FT.accum_labor 'Y'*/
if @Regen='Y'
  begin
    begin transaction
    execute FT.ftsp_IncUpdXRt
    if @@error<>0
      begin
        rollback transaction UpdXRt
        return-1
      end
    else
      commit transaction
  end
select	FinishedPart=XRt.TopPart,
	RawPart=XRt.ChildPart
from	part as p1
	join FT.XRt XRt on p1.part = XRt.TopPart
	join part as p2 on XRt.ChildPart = p2.part
where	p1.type='F' and
	p2.type='R' and
	p1.part = @finishedgood
order by
	1 asc
GO
