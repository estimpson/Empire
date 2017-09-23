SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [EEIUser].[acctg_ar_pending_rmas] @date_stamp datetime
as

select * from shipper s join shipper_detail sd on s.id = sd.shipper where s.type in ('R') and s.date_stamp >= @date_stamp and status = 'O'






GO
