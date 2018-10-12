SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [FT].[WkNMPS] as
select	* from EEH.FT.WkNMPS with (readuncommitted)
GO
