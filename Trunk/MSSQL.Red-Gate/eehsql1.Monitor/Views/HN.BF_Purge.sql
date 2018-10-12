SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create	view [HN].[BF_Purge] as
select	* from EEH.HN.BF_Purge with (readuncommitted) 
GO
