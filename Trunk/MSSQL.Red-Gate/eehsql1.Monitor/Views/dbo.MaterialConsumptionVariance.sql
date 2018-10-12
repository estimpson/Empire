SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[MaterialConsumptionVariance] as
select *
from	EEH..MaterialConsumptionVariance with (readuncommitted)
GO
