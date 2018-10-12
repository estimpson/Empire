SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create view [dbo].[SuperObject] as 
select	* from EEH.dbo.SuperObject with (readuncommitted)
GO
