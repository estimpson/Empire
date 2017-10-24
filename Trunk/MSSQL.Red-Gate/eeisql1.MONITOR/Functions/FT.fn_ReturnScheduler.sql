SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO












CREATE FUNCTION [FT].[fn_ReturnScheduler]
(	@Destination varchaR(20)
)
RETURNS VARCHAR(20)
AS
BEGIN
--- <Body>
/*	Return Schedulers e-mail adress by initials. If no match occurs, send to email groups */
	DECLARE @Scheduler VARCHAR(MAX)

	SELECT @Scheduler
		=	(
				Select Top 1 Coalesce(nullif(d.Scheduler,''), 'Scheduler not assigned')
				From 
					destination d
				outer apply
					( Select top 1 count(1) as DestCount, scheduler, destination from destination d2 where d2.destination = d.destination group by scheduler, destination order by 1 desc ) as Destinations
				where
					d.destination = @Destination
			)

		RETURN @scheduler


END













GO
