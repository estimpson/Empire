SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[woTracert] as 
select	* from eeh.dbo.woTracert with (readuncommitted)
GO
