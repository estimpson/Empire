SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vweMinOnHand]
(	Part,
	Description )
as
--	Description:
--	Exceptions exist when only demand for part is Min On Hand.
select	Part = vwProcessResults.Part,
	Description = 'Only demand for part ' + vwProcessResults.part + ' on PO ' + convert ( varchar, vwProcessResults.PONumber ) + ' is Min On Hand.  ' +
	'(' + Convert ( varchar, vwProcessResults.MinOnHand ) + ')'
from	FT.vwProcessResults vwProcessResults
where	vwProcessResults.eMinOnHand = 1
GO
