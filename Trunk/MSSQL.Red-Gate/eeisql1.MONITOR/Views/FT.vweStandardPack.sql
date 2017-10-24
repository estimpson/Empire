SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vweStandardPack]
(	Part,
	Description )
as
--	Description:
--	Exceptions are po line items in frozen horizon that are not in
--	vendor standard pack.
select	Part = vwProcessResults.Part,
	Description = 'Standard pack violation for part ' + vwProcessResults.part + ' on PO ' + convert ( varchar, vwProcessResults.PONumber ) + '.  ' +
	'(' + Convert ( varchar, convert ( integer, vwProcessResults.FrozenBalance ) ) + ', ' + Convert ( varchar, convert ( integer, vwProcessResults.StandardPack ) ) + ')'
from	FT.vwProcessResults vwProcessResults
where	vwProcessResults.eStandardPack = 1
GO
