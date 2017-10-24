SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [FT].[ftsp_EMailAlert_OverShipment]

--Returns over shipment shipper_detail data in an EMail alert sent to EEI Schedulers
		 @shipper int
		,@TranDT datetime out
		,@Result integer out
as
set nocount on
set ansi_warnings off
set	@Result = 999999
set	ansi_warnings ON

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname  = N'#OverShipment',
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. <schema_name, sysname, dbo>.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>

-- Get ShipperDetail and Current Inventory for Short Shipment
	

	Declare @SchedulerEmailAddress varchar(max)
								,@SchedulerInitials varchar(max)
		
	Select 
		 s.destination as Destination
		,sd.part_original as PartNumber
		,sd.order_no as SalesOrderNumber
		,sd.qty_original as ScheduledQty
		,sd.qty_required as ReducedQty
		,(sd.qty_original - sd.qty_required) as ShortShipmentQty
		,(Select sum(quantity) 
				from object o
			 where o.part  = sd.part_original 
				and o.status = 'A' 
				and o.location not like '%FIS%'
				and o.location not like '%LOST%' 
				and	o.plant like '%EEI%'
				and coalesce(o.shipper,0) = 0
			  ) as ApprInvNotOnShipper
		,d.scheduler as Scheduler
into
		#OverShipment
From 
		shipper_detail sd
Join
		shipper s on s.id =  sd.shipper
Join
		destination d on d.destination = s.destination
		where 
								sd.shipper = @shipper
				and sd.qty_packed > sd.qty_original
		
	
		-- Create HTML and E-Mail
If exists ( Select 1 from #OverShipment )	

Select @SchedulerInitials
		= min(Scheduler)
	From
		#OverShipment

		Select @SchedulerEmailAddress
		= [FT].[fn_ReturnSchedulerEMailAddress] ( @SchedulerInitials)

Begin	
		declare
			@html nvarchar(max),
			@EmailTableName sysname  = N'#OverShipment'


			exec [FT].[usp_TableToHTML]
			@tableName = @Emailtablename
		, @OrderBy = '[PartNumber], [Scheduler]'
		,	@html = @html out
		
		declare
			@EmailBody nvarchar(max)
		,	@EmailHeader nvarchar(max) = 'Over Shipment Alert (Sent Based on Update Trigger on Shipper) ' 

		select
			@EmailBody =
				N'<H1>' + @EmailHeader + N'</H1>' +
				@html

	--print @emailBody

	exec msdb.dbo.sp_send_dbmail
				@profile_name = 'DBMail'-- sysname
	,		@recipients = @SchedulerEmailAddress -- varchar(max)
--	,			@recipients = 'aboulanger@fore-thought.com' -- varchar(max)
	,			@copy_recipients = 'dwest@empireelect.com;aboulanger@fore-thought.com' -- varchar(max)
	, 		@subject = @EmailHeader
	,  		@body = @EmailBody
	,  		@body_format = 'HTML'
	,			@importance = 'High'  -- varchar(6)	

		
		
End					

--- </Body>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>

/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go


begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
		@ProcReturn = ft.ftsp_EMailAlert_OverShipment
		@shipper  = 74751
	,	@TranDT = @TranDT out
	,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

if	@@trancount > 0 begin
	commit
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/









GO
