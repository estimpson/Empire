SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [FT].[usp_SQLJob_CheckForShipments]
as

begin
--Get Prior Monday Date

Declare @VerifyDate datetime

Select @VerifyDate = dateadd(wk, -1,  ft.fn_TruncDate_monday('wk',getdate()))

--Set Shippers Ready for E-Mail

Declare @Shipments Table
	(	ShipperID int,
		ShipperDateShipped datetime,
		ActualDateShipped datetime,
		ATOperator varchar(50),
		CustomerCode varchar(15),
		CustomerName varchar(50)
	)

Insert @Shipments

Select 
	s.id,
	s.date_shipped,
	max(at.dbDate),
	max(e.name),
	s.customer,
	c.name
From
	shipper s
join
	customer c on c.customer = s.customer
join
	audit_trail at on at.shipper = convert(varchar(15), s.id )
left join
	employee e on at.operator = e.operator_code
where
	at.type ='S'
and
	s.type is Null
and
	isNull(c.auto_profile,'N') = 'Y'

group by
	s.id,
	s.date_shipped,
	s.customer,
	c.name
having
	max(at.dbDate) >= @VerifyDate

--Select * From @Shipments
--Delete from @Shipments
If Exists (Select 1 from @shipments)
Begin

DECLARE @tableHTMLA  NVARCHAR(MAX) ;

SET @tableHTMLA =
    N'<H1>Alert for Prior Week Shipments</H1>' +
    N'<table border="1">' +
    N'<tr><th>ShipperID</th>' +
    N'<th>ShipperDateShipped</th><th>ActualDateShipped</th><th>EmployeeName</th>' +
	N'<th>CustomerCode</th><th>CustomerName</th>' +
    N'<th>Notes</th></tr>' +
    CAST ( ( SELECT td = eo.ShipperID, '',
                    td = convert(varchar(15), eo.ShipperDateShipped, 110), '',
                    td = convert(varchar(15), eo.ActualDateShipped, 110), '',
					td = eo.ATOperator, '',
                    td = eo.CustomerCode, '',
					td = eo.CustomerName, '',
                    td = case when abs(datediff(mi, ActualDateShipped, ShipperDateShipped)) > 5 then 'Warning : Shipped Date Altered by User' else 'Good Shipment' end
              FROM @Shipments  eo
            order by 1,3 desc 
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' ;
    
exec msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
    @recipients = 'dwest@empireelect.com', -- varchar(max)
    @copy_recipients = 'aboulanger@fore-thought.com bmoore@empireelect.com echavarria@empireelect.com', -- varchar(max)
    --@blind_copy_recipients = 'aboulanger@fore-thought.com;estimpson@fore-thought.com', -- varchar(max)
    @subject = N'TRWBCS Shipment Notification', -- nvarchar(255)
    @body = @TableHTMLA, -- nvarchar(max)
    @body_format = 'HTML', -- varchar(20)
    @importance = 'Normal' -- varchar(6)

End

If Not Exists (select 1 from @shipments )
Begin

exec msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
    @recipients = 'dwest@empireelect.com', -- varchar(max)
    --@copy_recipients = 'aboulanger@fore-thought.com', -- varchar(max)
    --@blind_copy_recipients = 'aboulanger@fore-thought.com;estimpson@fore-thought.com', -- varchar(max)
    @subject = N'WARNING: NO SHIPMENTS HAVE BEEN CREATED FOR TRWBCS IN THE LAST WEEK.', -- nvarchar(255)
    @body = N'No Shipments for TRWBCS were processed in Monitor for the prior week.  Please execute the shipout now and notify Dan West upon completion.', -- nvarchar(max)
    @body_format = 'TEXT', -- varchar(20)
    @importance = 'High' -- varchar(6)

End



End
GO
