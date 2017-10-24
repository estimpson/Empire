SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[eeisp_EDI_process_GMBFT_DELJIT]

as
BEGIN
BEGIN TRANSACTION
DELETE Log
COMMIT TRANSACTION

BEGIN TRANSACTION
Delete m_in_ship_schedule
COMMIT TRANSACTION

declare	@LastSchedule	varchar(25)

Select	@LastSchedule = rtrim(max(BGM02))
from		[MONITOR].[dbo].[GM_BFT_DELJIT_RFF]

Create	table #orderstoupdate(
						OrderNo	integer,
						customerPart		varchar(25),
						destination		varchar(25))

Insert	#orderstoupdate (	
						OrderNo,
						customerPart,
						destination	)

Select	max(order_header.order_no),
		rtrim(LIN0301),
		rtrim(NAD0201)
from		order_header
join		edi_setups	on	order_header.destination = edi_setups.destination
join		GM_BFT_DELJIT_PARTLIST on edi_setups.parent_destination = rtrim(NAD0201) and order_header.customer_part = rtrim(LIN0301) and rtrim(BGM02) =@LastSchedule and RTRIM(NAD01) = 'ST'
group	by	rtrim(LIN0301),
		rtrim(NAD0201)

update	order_header
set		line11= RTRIM(PCI0201)
FROM	order_header
JOIN	#orderstoupdate on order_header.order_no = #orderstoupdate.orderNo
JOIN	GM_BFT_DELJIT_PCI_GIN on	#orderstoupdate.customerPart = RTRIM(GM_BFT_DELJIT_PCI_GIN.LIN0301) and RTRIM(PCI0401) = '11Z'
WHERE	rtrim(BGM02) =@LastSchedule

update	order_header
set		line12= RTRIM(PCI0201)
FROM	order_header
JOIN	#orderstoupdate on order_header.order_no = #orderstoupdate.orderNo
JOIN	GM_BFT_DELJIT_PCI_GIN on	#orderstoupdate.customerPart = RTRIM(GM_BFT_DELJIT_PCI_GIN.LIN0301) and RTRIM(PCI0401) = '12Z'
WHERE	rtrim(BGM02) =@LastSchedule

update	order_header
set		line13= RTRIM(PCI0201)
FROM	order_header
JOIN	#orderstoupdate on order_header.order_no = #orderstoupdate.orderNo
JOIN	GM_BFT_DELJIT_PCI_GIN on	#orderstoupdate.customerPart = RTRIM(GM_BFT_DELJIT_PCI_GIN.LIN0301) and RTRIM(PCI0401) = '13Z'
WHERE	rtrim(BGM02) =@LastSchedule


update	order_header
set		line14= RTRIM(PCI0201)
FROM	order_header
JOIN	#orderstoupdate on order_header.order_no = #orderstoupdate.orderNo
JOIN	GM_BFT_DELJIT_PCI_GIN on	#orderstoupdate.customerPart = RTRIM(GM_BFT_DELJIT_PCI_GIN.LIN0301) and RTRIM(PCI0401) = '14Z'
WHERE	rtrim(BGM02) =@LastSchedule

update	order_header
set		line15= RTRIM(PCI0201)
FROM	order_header
JOIN	#orderstoupdate on order_header.order_no = #orderstoupdate.orderNo
JOIN	GM_BFT_DELJIT_PCI_GIN on	#orderstoupdate.customerPart = RTRIM(GM_BFT_DELJIT_PCI_GIN.LIN0301) and RTRIM(PCI0401) = '15Z'
WHERE	rtrim(BGM02) =@LastSchedule

update	order_header
set		line16= RTRIM(PCI0201)
FROM	order_header
JOIN	#orderstoupdate on order_header.order_no = #orderstoupdate.orderNo
JOIN	GM_BFT_DELJIT_PCI_GIN on	#orderstoupdate.customerPart = RTRIM(GM_BFT_DELJIT_PCI_GIN.LIN0301) and RTRIM(PCI0401) = '16Z'
WHERE	rtrim(BGM02) =@LastSchedule


update	order_header
set		line17= RTRIM(PCI0201)
FROM	order_header
JOIN	#orderstoupdate on order_header.order_no = #orderstoupdate.orderNo
JOIN	GM_BFT_DELJIT_PCI_GIN on	#orderstoupdate.customerPart = RTRIM(GM_BFT_DELJIT_PCI_GIN.LIN0301) and RTRIM(PCI0401) = '17Z'
WHERE	rtrim(BGM02) =@LastSchedule

update	order_header
set		dock_code = RTRIM(LOC0201_1),
		zone_code = RTRIM(LOC0201_3),
		line_feed_code = RTRIM(LOC0201_2)
FROM	order_header
JOIN	#orderstoupdate on order_header.order_no = #orderstoupdate.orderNo
JOIN	GM_BFT_DELJIT_LOC on #orderstoupdate.customerPart = RTRIM(GM_BFT_DELJIT_LOC.LIN0301)
WHERE	rtrim(BGM02) =@LastSchedule

Create table #ShipSchedue (
							lineid	integer identity,
							customerpart	varchar (35),
							destination		varchar (20),
							customerPO		varchar	(20),
							modelYear			varchar	(4),
							ReleaseNumber	varchar(30),
							QtyQual				char(1),
							Qty						numeric(20,6),
							DateType			char(1),
							ReleaseDate		DATETIME,
							CustomerAccum	numeric (20,6))
							
BEGIN TRANSACTION
insert #ShipSchedue( customerpart	,
							destination		,
							customerPO		,
							modelYear			,
							ReleaseNumber	,
							QtyQual				,
							Qty						,
							DateType			,
							ReleaseDate		,
							customerAccum		)
	select 	rtrim(GM_BFT_DELJIT_SHIP_SCHED.LIN0301) as custpart,
			edi_setups.destination,
			'',
			'',
			rtrim(GM_BFT_DELJIT_SHIP_SCHED.BGM02),
			'N',
			convert(decimal(20,6),QTY0102),
			'S',
			dateadd(dd, -1*isNULL (edi_setups.id_code_type,0),convert(DATETIME,substring(GM_BFT_DELJIT_SHIP_SCHED.DTM0102,1,8))) as reldate,
			isNULL(convert(decimal(20,6),QTY0102),0)
	 FROM	GM_BFT_DELJIT_SHIP_SCHED
	join		GM_BFT_DELJIT_PARTLIST on GM_BFT_DELJIT_SHIP_SCHED.BGM02 = GM_BFT_DELJIT_PARTLIST.BGM02   and GM_BFT_DELJIT_SHIP_SCHED.LIN0301 = GM_BFT_DELJIT_PARTLIST.LIN0301 and rtrim(GM_BFT_DELJIT_PARTLIST.BGM02) = @LastSchedule and RTRIM(NAD01) = 'ST'
	 LEFT OUTER JOIN edi_setups  ON  rtrim(GM_BFT_DELJIT_PARTLIST.NAD0201) = edi_setups.parent_destination 
	
           
COMMIT TRANSACTION 			

BEGIN TRANSACTION
insert m_in_ship_schedule (customer_part,
													shipto_id,
													customer_po,
													model_year,
													release_no,
													quantity_qualifier,
													quantity,
													release_dt_qualifier,
													release_dt)
	select 	customerpart,
			destination,
			customerPO,
			ModelYear,
			ReleaseNumber,
			QtyQual,
			/*(Select sum(Qty) from	#ShipSchedue RP2 
				where RP2.customerPart =	#ShipSchedue.customerPart and 
							RP2.destination =	#ShipSchedue.destination  and 
							RP2.lineid <=	#ShipSchedue.lineid)+CustomerAccum*/Qty,
			DateType,
			ReleaseDate
	 FROM	#ShipSchedue
	 order by destination, customerpart, ReleaseDate       
COMMIT TRANSACTION

Update	order_header
set			custom01 = rtrim(udf2)
FROM 		"raw_830_order"
	 	LEFT OUTER JOIN 	"edi_setups"  ON rtrim("raw_830_order"."n104_1") = "edi_setups"."parent_destination"
	  JOIN	"order_header"   ON edi_setups.destination = order_header.destination
	  WHERE rtrim(raw_830_order.udf1) = order_header.customer_part


execute msp_process_in_ship_sched

delete	gm_bft_deljit_cytd   
delete	gm_bft_deljit_loc   
delete	gm_bft_deljit_nad
delete	gm_bft_deljit_partlist 
delete	gm_bft_deljit_pci_gin 
delete	gm_bft_deljit_pia 
delete	gm_bft_deljit_rff
delete	gm_bft_deljit_ship_sched

Select ' Processed GM DELJIT' +' ' + convert(varchar(25), getdate())
UNION
Select 'a: Updated Orders'
UNION
Select distinct 'a:'+substring("message",1,patindex('%release date%',"message" )-3) from log where "message" like '%inserted%'
UNION
Select 'b: Exceptions'
UNION
Select distinct 'b:'+"message" from log where "message" like 'Blanket Order%'
UNION
Select distinct 'b:'+"message" from log where "message" like 'Inbound release plan does not exist%'
order by 1
END
GO
