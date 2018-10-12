SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [ACCT].[SubsidiaryPartStandard]
as
select
	sps.Subsidiary
,	sps.Part
,	sps.EffectiveDate
,	sps.Status
,	sps.Type
,	sps.Material
,	sps.MaterialAccum
,	sps.Labor
,	sps.LaborAccum
,	sps.Burden
,	sps.BurdenAccum
,	sps.SalesPrice
,	sps.SalesPriceAccum
,	sps.RowID
,	sps.RowCreateDT
,	sps.RowCreateUser
,	sps.RowModifiedDT
,	sps.RowModifiedUser
from
	EEH.ACCT.SubsidiaryPartStandard sps with (readuncommitted)
GO
