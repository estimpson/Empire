SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*
Select 
	shipments.id,
	shipments.date_shipped,
	shipments.order_no,
	shipments.part_original,
	shipments.alternative_qty as QtyShipped,
	Shipments.accum_shipped as AccumShipped,
	shipments.customer_part as CustomerPart,
	shipments.destination as Destination,
	LastShipperID ,
	sd.order_no,
	sd.part_original,
	isNull(sd.accum_shipped,0) as PriorAccum

	From (select 
	id, 
	s.date_shipped,
	order_no, 
	part_original, 
	qty_packed, 
	alternative_qty,
	accum_shipped,
	customer_part,
	s.destination,
	(Select max(s3.id) 
		from shipper s3
	
	where	s3.date_shipped = (Select max(s2.date_shipped) 
		from shipper_detail sd2
	join
		shipper s2 on s2.id = sd2.shipper
	where	sd2.customer_part = sd.customer_part and
			s2.destination = s.destination and
			s2.date_Shipped < s.date_shipped  ))  LastShipperID
from 
	shipper s 
join 
	shipper_detail sd on s.id = sd.shipper 
where
	s.date_shipped >= @dateShipped 
and s.type is Null and s.status not in ('E')

) shipments
 left join shipper_detail sd on sd.shipper = LastShipperID and sd.customer_part = shipments.customer_part 
 where 
 isNull(sd.accum_shipped,0) + isnull(shipments.alternative_qty,0) != shipments.accum_shipped

 order by date_shipped

 Select * From shipper_detail where order_no in ( 15462 )

 Select dbdate, 
		shipper,* From audit_trail where shipper in ('57526', '57597') and type = 'S'*/


CREATE procedure [dbo].[ftsp_AuditAccumsPerShipper] @Shipper int
as
Begin 

--[DBO].[ftsp_AuditAccumsPerShipper] 58332

set nocount on
set  ansi_warnings off


		declare @CurrentShipment table (
		ShipperID int,
		CustomerPart varchar(50),
		Destination varchar(25),
		Part varchar(25),
		QtyShipped int,
		AccumShipped int,
		Note varchar(50))

		declare @PriorShipments table (
		DateShipped datetime,
		Shipper int,
		CustomerPart varchar(50),
		Destination varchar(25),
		Part varchar(25),
		QtyShipped int,
		AccumShipped int,
		Note varchar(50))

		declare @LastShippers table (
		DateShipped datetime,
		CustomerPart varchar(50),
		Destination varchar(25))

		insert
			@CurrentShipment

			(	ShipperID,
				CustomerPart ,
				Destination ,
				Part,
				QtyShipped ,
				AccumShipped,
				Note
			)		
		
		Select	
				s.id,
				sd.customer_part,
				s.destination,
				LEFT(sd.part_original,7),
				sd.alternative_qty,
				sd.accum_shipped,
				'Current Shipment'
		from 
			shipper_detail sd
		join
			shipper s on s.id =sd.shipper
		where 
			sd.shipper = @Shipper


			
				
		
		insert
			@PriorShipments

			(	DateShipped,
				Shipper,
				CustomerPart ,
				Destination ,
				Part,
				QtyShipped ,
				AccumShipped,
				Note
			)	
			
			
		Select	max(dbDate),
				sd.shipper,
				sd.customer_part,
				s.destination,
				max(LEFT(at.part,7)),
				Sum(Quantity) as ATQtyShipped,
				max(sd.accum_shipped) as ShipperAccum,
				'Prior Shipment'
		from 
			audit_trail at
		join
			shipper_detail sd on sd.part_original = at.part and convert(varchar(25), sd.shipper )= at.shipper
		join
			shipper s on s.id =sd.shipper
		where at.type = 'S' and 
			at.part != 'pallet' and
			s.id <> @Shipper and
			dbdate >= dateadd(wk, -26, getdate()) and
			sd.date_shipped is not null
			
		group by
			s.destination,
			sd.customer_part,
			sd.shipper	

	union

		 Select	max(sd.date_shipped),
				sd.shipper,
				oh.customer_part,
				oh.destination,
				max(left(oh.blanket_part,7)),
				0,
				max(accum_shipped) as AccumAdjust,
				'AccumAdjustment'
		from
			shipper_detail sd 
		left join order_header oh on sd.order_no = oh.order_no
		join
			shipper s on s.id =sd.shipper
		where sd.part like '%CUM%' and 
			sd.date_shipped >= dateadd(wk, -26, getdate()) 

		group by
			oh.customer_part,
			oh.destination,
			sd.shipper
		order by 
		3, 2, 1


		Insert @LastShippers

			(	DateShipped,
				CustomerPart,
				Destination
			)

		Select	max(PS.DateShipped),
				LS.CustomerPart,
				LS.Destination
		From	
			@CurrentShipment LS
		join
			@PriorShipments PS on PS.CustomerPart = LS.CustomerPart and PS.Destination = ls.Destination
		Group by
			LS.CustomerPart,
			LS.Destination
			
		Declare @AccumSummary table(
			ShipperID int,
			Destination varchar(25),
			CustomerPart varchar(50),
			Part varchar(25),
			PriorAccumShipped int,
			QtyShipped int,
			CurrentAccumShipped int,
			AccumDiscrepancy int )

		Insert
			@AccumSummary

		Select
			CS.ShipperID,
			CS.Destination,
			CS.CustomerPart,
			CS.Part,
			PS.AccumShipped as PriorAccumShipped,
			CS.QtyShipped as QtyShipped,			
			CS.AccumShipped as CurrentAccumShipped,
			PS.AccumShipped+CS.QtyShipped-CS.AccumShipped as AccumDifference


		From
			@CurrentShipment CS
		Join
			@PriorShipments PS on PS.CustomerPart = CS.CustomerPart and PS.Destination = CS.Destination
		join
			@LastShippers LS on LS.CustomerPart = PS.CustomerPart and PS.Destination = CS.Destination and LS.DateShipped = PS.DateShipped

			--Select * From @AccumSummary
		
		--Check For Discrepancy. If so, send E-mail
		If exists (select 1 from @AccumSummary where AccumDiscrepancy != 0 )

		Begin

		DECLARE @tableHTMLZZ  NVARCHAR(MAX) ;

SET @tableHTMLZZ =
    N'<H1>Shipped Accum Alert</H1>' +
    N'<table border="1">' +
    N'<tr><th>ShipperID</th>' +
    N'<th>ShipToCode</th><th>CustomerPart</th><th>Part</th><th>PriorAccum</th>' +
	N'<th>QtyShipped</th><th>CurrentAccum</th><th>AccumDifference</th></tr>' +
    CAST ( ( SELECT td = eo.ShipperID, '',
                    td = eo.Destination, '',
                    td = eo.CustomerPart, '',
                    td = eo.Part, '',
                    td = eo.PriorAccumShipped, '', 
					td = eo.QtyShipped, '', 
					td = eo.CurrentAccumShipped, '',
					td = eo.AccumDiscrepancy, ''  
              FROM @AccumSummary  eo
             where	eo.AccumDiscrepancy  != 0
            order by 5,3,1 
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' ;

	exec msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
    @recipients = 'mminth@empireelect.com;Gcruz@empireelect.com;Gurbina@empireelect.com;IAragon@empireelect.hn', -- varchar(max)
    @copy_recipients = 'aboulanger@fore-thought.com;dwest@empireelect.com', -- varchar(max)
    --@blind_copy_recipients = 'aboulanger@fore-thought.com;estimpson@fore-thought.com', -- varchar(max)
    @subject = N'Shipment Accum Issue ', -- nvarchar(255)
    @body = @TableHTMLZZ, -- nvarchar(max)
    @body_format = 'HTML', -- varchar(20)
    @importance = 'High' -- varchar(6)  

		End
		
			

End

GO
