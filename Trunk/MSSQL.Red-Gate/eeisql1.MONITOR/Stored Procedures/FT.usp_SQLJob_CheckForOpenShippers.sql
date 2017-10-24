SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE Procedure [FT].[usp_SQLJob_CheckForOpenShippers]
as

begin


--Set Shippers Ready for E-Mail

Declare @OpenShippers Table
	(	ShipperPlant varchar(50),
		ShipperID int,		
		ShipperDateTimeDue datetime,
		ShipperCarrier varchar(50),
		Scheduler varchar(50),
		CustomerCode varchar(15),
		CustomerName varchar(50),
		DestinationCode varchar(50),
		DestinationName varchar(50),
		Part varchar(50),
		QtyOriginal int,
		QtyRequired int,
		QtyStaged int,
		OnHandInventory int,
		Status varchar(50),
		PackSlipStatus varchar(50)
	)

Insert @OpenShippers
(				ShipperPlant 
		,		ShipperID 	
		,		ShipperDateTimeDue 
		,		ShipperCarrier 
		,		Scheduler
		,		CustomerCode
		,		DestinationCode 
		,		Part
		,		QtyOriginal 
		,		QtyRequired 
		,		QtyStaged 
		,		OnHandInventory 
		,		Status 
		,		PackSlipStatus 
)

Select 
	s.plant,
	s.id,
	s.date_stamp,
	s.ship_via,
	d.scheduler,
	s.customer,
	d.destination,
	sd.part_original,
	sd.qty_original as QtyOriginal,
	sd.qty_required as QtyRequired,
	isNull(sd.qty_packed,0) as QtyStaged,
	OnHandQty as InventoryAvailable,
	case when dbo.fn_LesserOf(sd.qty_original, sd.qty_required) > isNull(sd.qty_packed,0) then 'In Process' else 'Staged' end,
	case printed when 'Y' then 'Yes' else 'No' end


From
	shipper s
join
		shipper_detail sd on sd.shipper = s.id
join
	customer c on c.customer = s.customer
join
	destination d on d.destination = s.destination
left join
		(select sum(quantity) as OnHandQty,
						part as Ipart,
						plant as IPlant
				from
						object 
					where status = 'A' and
					shipper is Null
					group by
					part ,
					plant)  Inventory on Ipart = sd.part_original and s.plant = Iplant

where
	s.status  in ('S', 'O')
and
	s.type is Null
and
	ft.fn_TruncDate('dd', date_stamp) <= ft.fn_TruncDate('dd', getdate())

Select		
				Scheduler
		,		ShipperPlant 
		,		ShipperID 	
		,		ShipperDateTimeDue 
		,		ShipperCarrier 
		,		CustomerCode
		,		DestinationCode 
		,		Part
		,		QtyOriginal 
		,		QtyRequired 
		,		QtyStaged 
		,		OnHandInventory 
		,		Status 
		,		PackSlipStatus 
into	#EDIAlerts
From	@OpenShippers
order by 1,3,4


If Exists (Select 1 From #EDIAlerts)

Begin
		
		declare
			@html nvarchar(max),
			@EmailTableName sysname  = N'#EDIAlerts'
		
		exec [FT].[usp_TableToHTML]
			@tableName = @Emailtablename
		, @OrderBy = '[Scheduler], [ShipperPlant], [DestinationCode], [ShipperDateTimeDue],[ShipperCarrier]'
		,	@html = @html out
		
		declare
			@EmailBody nvarchar(max)
		,	@EmailHeader nvarchar(max) = 'Open Shippers (SQLJob:EMailAlertOpenShippers)' 

		select
			@EmailBody =
				N'<H1>' + @EmailHeader + N'</H1>' +
				@html

	--print @emailBody

	exec msdb.dbo.sp_send_dbmail
		@profile_name = 'DBMail'-- sysname
	,	@recipients = 'EEISchedulers@empireelect.com;EEISchedulers@empire.hn' -- varchar(max)
	,	@copy_recipients = 'Dwest@empireelect.com;aboulanger@fore-thought.com' -- varchar(max)
	, 	@subject = @EmailHeader
	,  	@body = @EmailBody
	,  	@body_format = 'HTML'
	,	@importance = 'High'  -- varchar(6)	
					



End




End



GO
