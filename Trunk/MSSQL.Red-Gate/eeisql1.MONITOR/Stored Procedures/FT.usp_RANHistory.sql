SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [FT].[usp_RANHistory] (@HorizonDate datetime, @CustomerPart varchar(50), @ShipToID varchar(50))
as
Begin
--exec ft.usp_RANHistory '2013-03-18', '946 098-21', 'SALEM'
Declare @Rans1 Table
(	ID int identity (1,1),
	RAN varchar(50),
	QtyDue	int,
	RecvdDT datetime,
	AccumShippedQtyPost int,
	AccumShippedQtyPrior int
)



Insert @Rans1
Select 
	ReleaseNo, 
	ReleaseQty, 
	RowModifiedDT,
	[ft].[fn_RanShippedPriorDate] (RowModifiedDT, ReleaseNo ) ShippedPriorDate,
	[ft].[fn_RanShippedAfterDate] (RowModifiedDT, ReleaseNo ) ShippedAfterDate
	
From 
	EDI.NAL_862_Releases 

where 
	CustomerPart = @CustomerPart and 
	ShipToCode = @ShipToID  and
	RowModifiedDT >= @HorizonDate
order by 
RowModifiedDT desc


Select * From @Rans1
order by 2,5


End
GO
