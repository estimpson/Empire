SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create proc [HN].[SP_MAT_CheckLastIDLabelUsed] (
	@Part varchar(25),
	@BasePartIDLabel varchar(25))
AS
Begin

--Set @Part = 'TRW0466'
--set @BasePartIDLabel = '34110626A'

Select top 100	IDLabel , LastUpdateDT = max(LastUpdateDT), IDNumeric = replace(ltrim(rtrim(idlabel)),@BasePartIDLabel,'')
from	sistema.dbo.OPF_Piece_Status
where	part=@Part
	and IDLabel like '%'+@BasePartIDLabel  +'%'	
group by IDLabel 
order by 2 desc


END
GO
