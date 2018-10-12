SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure
[dbo].[eeisp_rpt_HighestAuthPerPO] (@PONumber integer)
as

exec	eeh.dbo.eeisp_rpt_HighestAuthPerPO
			@PoNumber = @PONumber 
GO
