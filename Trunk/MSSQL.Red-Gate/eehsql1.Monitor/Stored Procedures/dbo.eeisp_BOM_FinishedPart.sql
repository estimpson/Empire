SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create procedure [dbo].[eeisp_BOM_FinishedPart] (@BasePart varchar(25))
as
Select * from [dbo].[vweeiBOM]
where finishedPart like @BasePart+'%'
order by 1, 2
GO
