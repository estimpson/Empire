SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[PrintQueue] as 
select	* from EEH.dbo.PrintQueue with (readuncommitted)
GO
