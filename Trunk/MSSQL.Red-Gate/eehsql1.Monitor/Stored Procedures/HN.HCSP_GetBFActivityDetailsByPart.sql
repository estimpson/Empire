SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [HN].[HCSP_GetBFActivityDetailsByPart]( @FromDT Datetime, @UntilDT Datetime, @Part varchar(25)) as
select  *
from    FT.fn_GetBackflushActivityDetail_byPart (@FromDT , @UntilDT , @Part)
GO
