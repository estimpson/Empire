SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Defect_Moldeo] as
select	* from EEH.dbo.Defect_Moldeo with (readuncommitted)
GO
