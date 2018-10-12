SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
		
create view [HN].[WhereUseList] as
	select	* from EEH.hn.WhereUseList with (Readuncommitted)
GO
