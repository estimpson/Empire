SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FT].[GetCustomerDemandSnapShots] ( @GeneratedDT datetime, @CustomerPrefix varchar(25))
as

Begin
--exec ft.GetCustomerDemandSnapShots'2017-02-01', 'FNG'

Declare @PartPrefix varchar(3)

Select @PartPrefix = left(isNULL(@CustomerPrefix,' '),3)


Select * from CustomerReleasePlans crp
join
	CustomerReleasePlanRaw crpr on crpr.ReleasePlanID =  crp.ID
where
	GeneratedDT >= @GeneratedDT and
	left(basePart,3) = @PartPrefix
End
GO
