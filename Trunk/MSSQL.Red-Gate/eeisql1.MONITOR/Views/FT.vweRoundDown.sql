SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vweRoundDown]
(	Part,
	Description )
as
--	Description:
--	Exceptions exist when rounding down has occurred.
select	Part = vwProcessResults.Part,
	Description = 'Rounding down occurred for part ' + vwProcessResults.part + ' on PO ' + convert ( varchar, vwProcessResults.PONumber ) + '.  ' +
	(	case	vwProcessResults.RoundingMethod
			when -1 then '(Round Down)'
			else '(Round Nearest)'
		end )
from	FT.vwProcessResults vwProcessResults
where	vwProcessResults.eRoundDown = 1
GO
