SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create view [FT].[vw_RptDestinationScheduler]
as

Select  Customer,
		Destination,
		Name,
		Scheduler 
From	Destination
Where	nullif(Customer, '') is Not Null
GO
