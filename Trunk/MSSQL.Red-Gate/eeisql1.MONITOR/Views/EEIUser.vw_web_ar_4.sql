SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [EEIUser].[vw_web_ar_4]
as
select * from ar_4 where time_stamp = (select max(time_stamp) from ar_4)
GO
