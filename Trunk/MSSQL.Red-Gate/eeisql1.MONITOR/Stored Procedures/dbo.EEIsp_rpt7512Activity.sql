SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[EEIsp_rpt7512Activity] (	@seventyfivetwelve varchar (25), @fromdate datetime, @throughdate datetime )
as
Begin
	
	Create table #7512s_out
	(serial 				integer,
	part					varchar(25),
	quantity			numeric (20,6),
	dateshipped	datetime,
	twofourteen		varchar(50),
	ITNo					varchar(50)
	)
	
	
	
	Insert	#7512s_out
	Select	serial,
				part,
				std_quantity,
				date_stamp,
				custom4,
				custom3
	from		audit_trail
	Where	type = 'S' and
				custom2 = @seventyfivetwelve and
				date_stamp>= @fromdate and
				date_Stamp< dateadd(dd,1, @throughdate)
				
				Select * from #7512s_out
	
End
GO
