SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vweLeadDemand]
(	Part,
	Description )
as
--	Description:
--	Exceptions are po line items in frozen horizon that exceed total demand
--	in lead time for vendor.
select	Part = vwProcessResults.Part,
	Description = 'Frozen demand exceeds lead demand for part ' + vwProcessResults.part + ' on PO ' + convert ( varchar, vwProcessResults.PONumber ) + '.  ' +
	'(' + Convert ( varchar, convert ( integer, vwProcessResults.FrozenBalance ) ) + ',' + Convert ( varchar, convert ( integer, vwProcessResults.LeadDemand ) ) + ',' + Convert ( varchar, convert ( integer, vwProcessResults.Lead ) ) + ')'
from	FT.vwProcessResults vwProcessResults
where	vwProcessResults.eLeadDemand = 1
GO
