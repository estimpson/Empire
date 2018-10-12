SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[PottingBF] as select * from EEH..PottingBF with (readuncommitted)
GO
