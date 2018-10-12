SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create	view [dbo].[BF_LogPartAutorized] as
select	*   from eeh.dbo.BF_LogPartAutorized with (readuncommitted)
GO
