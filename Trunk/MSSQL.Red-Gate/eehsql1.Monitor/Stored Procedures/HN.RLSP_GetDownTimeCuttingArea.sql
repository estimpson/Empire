SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create proc [HN].[RLSP_GetDownTimeCuttingArea](
	@BeginDate datetime,
	@EndDate datetime,
	@IntervalDownTime int,
	@Shift char(3),
	@Machine varchar(8))
	as
	begin
EXEC EEH.HN.RLSP_GetDownTimeCuttingArea @BeginDate,@EndDate,@IntervalDownTime,@Shift,@Machine
end
GO
