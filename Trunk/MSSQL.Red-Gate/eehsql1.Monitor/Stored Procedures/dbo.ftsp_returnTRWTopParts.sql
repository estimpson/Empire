SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[ftsp_returnTRWTopParts] (@RawPart varchar(25))
as
Begin
-- dbo.ftsp_returnTRWTopParts '33756028'

Select distinct left(x.TopPart,7)
from 
		Ft.xrt x inner join part p on p.part=x.childpart
where 
		x.toppart like 'TRW%'
			and p.type='R'
			and p.commodity not like '%wire%'
			and p.commodity not like '%compound%'
			and p.part = @RawPart
order by 1
end


GO
