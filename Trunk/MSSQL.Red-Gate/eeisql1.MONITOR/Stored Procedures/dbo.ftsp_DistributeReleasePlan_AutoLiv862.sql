SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [dbo].[ftsp_DistributeReleasePlan_AutoLiv862]
as 
begin

/********
Declare variables and set variables for calendar function
*********/

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
                            order_header.customer_part = rtrim(raw_830_release.lin03)
                            AND order_header.customer_po = rtrim(raw_830_release.lin05)
                            and edi_setups.parent_destination = rtrim(raw_830_release.n104_1)
                         ), rtrim(raw_830_release.n104_1))
            ,   rtrim(lin05)
            ,   ''
            ,   coalesce(rtrim(nullif(udf8, '')), rtrim(nullif(bfr_rel, '')))+'*862'
            ,   'N'
            ,   convert(decimal(20, 6), fst01)
            ,   'S'
            ,   dateadd(dd, -1 * isnull((
                                         select
                                            max(edi_setups.id_code_type)
                                         from
                                            order_header
                                            join edi_setups
                                                on order_header.destination = edi_setups.destination
                                         where
                                            order_header.customer_part = rtrim(raw_830_release.lin03)
                                            AND order_header.customer_po = rtrim(raw_830_release.lin05)
                                            and edi_setups.parent_destination = rtrim(raw_830_release.n104_1)
                                        ), 0), convert(datetime, fst04))
            from
                "raw_830_release" 
                WHERE NOT EXISTS (SELECT 1 FROM dbo.AutoLivRanNumbersShipped WHERE RanNumber = coalesce(rtrim(nullif(udf8, '')), rtrim(nullif(bfr_rel, ''))))
	 
    insert  m_in_release_plan
            select
                order_detail.customer_part
            ,   order_detail.destination
            ,   order_header.customer_po
            ,   ''
            ,   order_detail.release_no
            ,   'N'
            ,   order_detail.the_cum
                - (case when order_header.our_cum + CustomerPartDestination.FirmAccum > order_detail.our_cum
                        then order_header.our_cum + CustomerPartDestination.FirmAccum
                        else order_detail.our_cum
                   end)
            ,   'S'
            ,   (CASE WHEN order_detail.due_date <= LastDate THEN DATEADD(dd,1,LastDate) ELSE order_detail.due_date END)
            from
                order_detail
                join order_header
                    on order_detail.order_no = order_header.order_no
                join (
                      select
                        max(release_dt) as LastDate
                      , customer_part as CP
                      , customer_po AS CPO
                      , shipto_id as ST
                      , sum(quantity) as FirmAccum
                      from
                        m_in_release_plan
                      group by
                        customer_part
                      , shipto_id
                      ,customer_po
                     ) CustomerPartDestination
                    on order_detail.customer_part = CP
                       and order_detail.destination = ST
                       AND	order_header.customer_po = CPO
            where
               order_detail.the_cum > order_header.our_cum + CustomerPartDestination.FirmAccum AND order_detail.release_no LIKE '%*830'
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
