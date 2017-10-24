SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vweTotalDemand]
(	Part,
	Description )
as
--	Description:
--	Exceptions are po line items in frozen horizon that exceed total demand
--	for vendor.
select	Part = vwProcessResults.Part,
	Description = 'Frozen demand exceeds total demand for part ' + vwProcessResults.part + ' on PO ' + convert ( varchar, vwProcessResults.PONumber ) + '.  ' +
	'(' + Convert ( varchar, vwProcessResults.FrozenBalance ) + ',' + Convert ( varchar, vwProcessResults.TotalDemand ) + ')'
from	FT.vwProcessResults vwProcessResults
where	vwProcessResults.eTotalDemand = 1
GO
