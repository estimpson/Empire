SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [HN].[HCSP_GetBFActivitySummary]( @FromDT Datetime, @UntilDT datetime) as
select  *
from    FT.fn_GetBackflushActivitySummary (@FromDT, @UntilDT)
GO
