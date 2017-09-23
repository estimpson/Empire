SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[eeisp_rpt_RMA_RTV_compare] (@fromDate datetime, @throughDate datetime)
as
begin
Select	* 
From	(Select sum(quantity) Qty,
				part,
				datediff(ww, '1999-01-01', date_stamp) relativeWeek,
				'RMA' as typeofTran,
				shipper
		from		[EEHSQL1].[eeh].[dbo].[audit_trail] 
		where	 type = 'U' and
				date_stamp>= @fromDate and
				date_stamp<dateadd(dd,31,@throughdate)
		group by	part,
				datediff(ww, '1999-01-01', date_stamp), shipper
		UNION
		Select sum(quantity) Qty,
				part,
				datediff(ww, '1999-01-01', date_stamp) relativeWeek,
				'RTV' typeofTran,
				shipper
		from		[dbo].[audit_trail] 
		where	 type = 'V' and
				date_stamp>= @fromDate and
				date_stamp<dateadd(dd,1,@throughdate)
		group by	part,
				datediff(ww, '1999-01-01', date_stamp), shipper	
		) EEIRTVEEHRMA where part like 'TRW0267%' or part like 'TRW0263%'
order by 3,2,4
end
GO
