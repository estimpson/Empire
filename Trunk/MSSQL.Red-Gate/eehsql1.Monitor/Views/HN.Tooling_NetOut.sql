SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [HN].[Tooling_NetOut] as 
	select	*
	from	eeh.hn.Tooling_NetOut with (readuncommitted)


GO
