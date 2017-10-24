SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [dbo].[ftsp_DistributeReleasePlan_NAL862]
as 
begin

/********
Declare variables and set variables for calendar function
*********/

set ansi_warnings off


    declare
        @EndDT datetime
    ,   @DatePart nvarchar(25)
    ,   @Increment int
    ,   @Entries int
		
    select
        @EndDT = dateadd(dd, 30, getdate())
    select
        @DatePart = 'dd'
    select
        @Increment = 1
    select
        @Entries = 1


    truncate table m_in_release_plan
   
   insert  m_in_release_plan
            select
                rtrim(lin03)
            ,   coalesce((
                          select
                            max(order_header.destination)
                          from
                            order_header
                            join edi_setups
                                on order_header.destination = edi_setups.destination
                          where
                            order_header.customer_part = rtrim(rr.lin03)
                            and edi_setups.parent_destination = rtrim(rr.n104_1)
                         ), rtrim(rr.n104_1))
            ,   rtrim(lin05)
            ,   ''
            ,   coalesce(rtrim(nullif(udf8, '')), rtrim(nullif(bfr_rel, '')))
            ,   'N'
            ,   convert(decimal(20, 6), fst01)
            ,   'F'
            ,   dateadd(dd, -1 * isnull((
                                         select
                                            max(edi_setups.id_code_type)
                                         from
                                            order_header
                                            join edi_setups
                                                on order_header.destination = edi_setups.destination
                                         where
                                            order_header.customer_part = rtrim(rr.lin03)
                                            and edi_setups.parent_destination = rtrim(rr.n104_1)
                                        ), 0), convert(datetime, fst04))
            from
                "raw_830_release" rr 
               
               
               
      ---e-mail exceptions 1) Release Qty where not evenly dvisible by std pack and 2) Where Po released != PO portion of RAN
     
     Declare @EDIOrdersAlert table (
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[DateInserted] datetime default getdate(),
	[ReleaseNo] [varchar](100) NULL,
	[CustomerPart] [varchar](100) NULL,
	[CustomerPO] [varchar](100) NULL,
	[ShipToCode] [varchar](100) NULL,
	[Type] [varchar](100) NULL,
	[Notes] [varchar](5000) NULL
	)
		
		if exists (select 1 
						from 
							dbo.m_in_release_plan
						where 
							customer_po != left(release_no, len(customer_po))
						union
						select 1 
						from 
							m_in_release_plan
						where	exists (select 1 from order_header oh where status ='A' and oh.customer_part = customer_part and oh.destination = shipto_id and (quantity%nullif(standard_pack,0) is null or quantity%nullif(standard_pack,0)>0))
					)
		Begin
		insert	@EDIOrdersAlert
		        ( ReleaseNo ,
		          CustomerPart ,
		          CustomerPO ,
		          ShipToCode ,
		          Type ,
		          Notes 
		        )
			select		
				distinct
				Coalesce(mrp.release_no,'')
			,	Coalesce(mrp.customer_part,'')
			,	Coalesce(mrp.customer_po,'')
			,	Coalesce(mrp.shipto_id,'')
			,	'PO Number RAN Number Mismatch Exception'
			,	'Please contact NAL and report Exception'
		         
	from 
			dbo.m_in_release_plan mrp
		where 
			customer_po != left(release_no, len(customer_po))
		union
			select		
				distinct
				Coalesce(mrp.release_no,'')
			,	Coalesce(mrp.customer_part,'')
			,	Coalesce(mrp.customer_po,'')
			,	Coalesce(mrp.shipto_id,'')
			,	'NAL Release Qty / Empire Standard Pack discrepancy'
			,	'Sales Order StandardPack is... ' + convert(varchar(10), isNull(mrp.quantity%nullif(oh2.standard_pack,0), -1)) + '  / NAL Release Qty is... ' + convert(varchar(10), convert(int,mrp.quantity))
		         
		from 
			dbo.m_in_release_plan mrp
		left join
			order_header oh2 on mrp.customer_part = oh2.customer_part and mrp.shipto_id = oh2.destination
			
		where	exists (select 1 from order_header oh where status ='A' and oh.customer_part = mrp.customer_part and oh.destination = mrp.shipto_id and (mrp.quantity%nullif(oh.standard_pack,0) is null or mrp.quantity%nullif(oh.standard_pack,0)>0))
					
	
		
		
	order by
		2,3,4,5
		
		insert EDI.NALOrdersAlert
		        ( ReleaseNo ,
		          DocumentType ,
		          CustomerPart ,
		          CustomerPO ,
		          ShipToCode ,
		          Type ,
		          Notes
		        )
		select 
		        ReleaseNo ,
		       '862', 
		        CustomerPart ,
		        CustomerPO ,
		        ShipToCode ,
		        Type ,
		        Notes 
		  from @EDIOrdersAlert
		
DECLARE @tableHTML  NVARCHAR(MAX) ;

SET @tableHTML =
    N'<H1>NAL 862 EDI Exceptions</H1>' +
    N'<table border="1">' +
    N'<tr><th>ReleaseNo</th>' +
    N'<th>CustomerPart</th><th>CustomerPO</th><th>ShipToCode</th>' +
    N'<th>Notes</th></tr>' +
    CAST ( ( SELECT td = eo.ReleaseNo, '',
                    td = eo.CustomerPart, '',
                    td = eo.CustomerPO, '',
                    td = eo.ShipToCode, '',
                    td = eo.notes
              FROM @EDIOrdersAlert  eo
              order by 1,2,3  
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' ;
 -- print @tableHTML  
exec msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
    --@recipients = 'mminth@empireelect.com', -- varchar(max)
    @copy_recipients = 'aboulanger@fore-thought.com', -- varchar(max)
    --@blind_copy_recipients = 'aboulanger@fore-thought.com;estimpson@fore-thought.com', -- varchar(max)
    @subject = N'EDI Data Exception when processing NAL 862 EDI Document(s)', -- nvarchar(255)
    @body = @TableHTML, -- nvarchar(max)
    @body_format = 'HTML', -- varchar(20)
    @importance = 'High' -- varchar(6)
    
		end 
     
     --end e-mail exception 
   
  	declare	@OrderRANS table(
			RANNumber	varchar(50) primary key,
			OrderNo	int,
			RanQty	numeric(20,6), 
			CustomerPart varchar(25),
			Destination		varchar(15)
			)  
   
       insert	@OrderRANS
                    ( RANNumber ,
                      OrderNo ,
                      RanQty,
                      CustomerPart ,
                      Destination
                    )
          select	
			RANNumber,
			max(OrderNo),
			sum(qty) ,
			sd.customer_part,
			s.destination
          from		
			dbo.NALRanNumbersShipped RANsShipped 
		join
			shipper_detail sd on RANsShipped.Shipper = sd.shipper and
			RANsShipped.OrderNo = sd.order_no
		join
			shipper s on sd.shipper = s.id
		where
			ShipDate>= dateadd(wk, -4, getdate()) 
			and	exists (select 1 from	dbo.m_in_release_plan mrp where mrp.customer_part =sd.customer_part and mrp.shipto_id = s.destination)
		group by
			RANNumber,
			sd.customer_part,
			s.destination
						   
    
   
     --Update Release Quantities by reducing by RAN Qty already shipped          
               update	m_in_release_plan
               set		quantity = quantity-isNULL(ORANs.RanQty,0)
               from		m_in_release_plan 
				left join
					@OrderRANS ORANs on  m_in_release_plan.customer_part = ORANs.CustomerPart and
						m_in_release_plan.shipto_id = ORANs.Destination and
						m_in_release_plan.release_no = ORANs.RanNumber
				delete
					dbo.m_in_release_plan
				where
					quantity<=0
               
     insert  m_in_release_plan
            select
                order_detail.customer_part
            ,   order_detail.destination
            ,   ''
            ,   ''
            ,   isNULL(order_detail.release_no,'NullRel.')
            ,   'N'
            ,	order_detail.quantity
            ,   order_detail.type
            ,   order_detail.due_date
            from
                order_detail
                join order_header
                    on order_detail.order_no = order_header.order_no
             where
                order_detail.release_no not in ( select release_no from m_in_release_plan) and 
                exists (select 1 from m_in_release_plan where m_in_release_plan.customer_part = order_detail.customer_part and shipto_id = order_detail.destination and order_detail.part_number like 'NAL%' and order_detail.notes not like '%EEA to EEH orders%' ) and 
                not exists ( select 1 from m_in_release_plan where order_detail.customer_part =m_in_Release_plan.customer_part  and order_detail.destination = m_in_release_plan.shipto_id and order_detail.due_date<=release_dt) and
               order_detail.type != 'F' 
            order by
                2
            ,   1
            ,   9
            
     

    select	distinct
        customer_part
    ,   shipto_id
    ,   EntryDT
    into
        #CustomerPartShipToDates
    from
        m_in_release_plan
        cross	join (
                        select
                            *
                        from
                            [MONITOR].[dbo].[fn_Calendar_StartCurrentSunday](@EndDT, @DatePart, @Increment, @Entries)
                       ) Calendar
    order by
        2
    ,   1
    ,   3 

    select
        CPCalendar.Customer_part
    ,   CPCalendar.ShipTo_ID
    ,   EntryDT
    ,   Order_detail.due_date as CurrentOrderDueDate
    ,   isnull(order_detail.quantity, 0) CurrentOrderQty
    ,   order_detail.release_no as CurrentOrderReleaseno
    ,   crp.release_DT as NewDate
    ,   isnull(crp.quantity, 0) as NewQty
    ,   crp.release_no as NewReleaseNo
    ,   order_detail.part_number
    ,   (
         select
            sum(quantity)
         from
            object
         where
            part = order_detail.part_number
        ) as Inventory
    from
        #CustomerPartShipToDates CPCalendar
        left join order_detail
            on CPCalendar.Customer_part = order_detail.customer_part
               and CPCalendar.shipto_id = order_detail.destination
               and EntryDT = due_date
        left join m_in_release_plan crp
            on CPCalendar.Customer_part = crp.customer_part
               and CPCalendar.shipto_id = crp.shipto_id
               and EntryDT = release_dt
    where
        isnull(order_detail.quantity, 0) != isnull(crp.quantity, 0)

end









GO
