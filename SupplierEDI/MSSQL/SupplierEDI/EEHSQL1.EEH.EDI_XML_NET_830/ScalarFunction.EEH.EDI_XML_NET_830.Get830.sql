
/*
Create ScalarFunction.EEH.EDI_XML_NET_830.Get830.sql
*/

use EEH
go

if	objectproperty(object_id('EDI_XML_NET_830.Get830'), 'IsScalarFunction') = 1 begin
	drop function EDI_XML_NET_830.Get830
end
go

create function EDI_XML_NET_830.Get830
(	@TradingPartnerCode varchar(12)
,	@purcharOrderList varchar(max) = null
,	@purpose char(2)
,	@partialComplete int
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

--- </Body>
	declare
		@dictionaryVersion varchar(25) = '003060'

	declare
		@purchaseOrders table
	(	PurchaseOrderNumber int primary key
	,	EmpireBlanketPart varchar(25)
	,	VendorPart varchar(25)
	,	PartDescription varchar(80)
	,	Unit varchar(2)
	,	Price varchar(11)
	,	AccumReceived int
	,	AccumStartDT datetime
	,	AccumEndDT datetime
	,	RawAccum int
	,	RawEndDT datetime
	,	FabAccum int
	,	FabEndDT datetime
	,	LastReceivedQty int
	,	LastReceivedDT datetime
	,	LastShipperID varchar(20)
	)

	insert
		@purchaseOrders
	(	PurchaseOrderNumber
	,	EmpireBlanketPart
	,	VendorPart
	,	PartDescription
	,	Unit
	,	Price
	,	AccumReceived
	,	AccumStartDT
	,	AccumEndDT
	,	RawAccum
	,	RawEndDT
	,	FabAccum
	,	FabEndDT
	,	LastReceivedQty
	,	LastReceivedDT
	,	LastShipperID
	)
	select
		poi.PurchaseOrderNumber
	,	poi.EmpireBlanketPart
	,	poi.VendorPart
	,	poi.PartDescription
	,	poi.Unit
	,	poi.Price
	,	poi.AccumReceived
	,	poi.AccumStartDT
	,	poi.AccumEndDT
	,	poi.RawAccum
	,	poi.RawEndDT
	,	poi.FabAccum
	,	poi.FabEndDT
	,	poi.LastReceivedQty
	,	poi.LastReceivedDT
	,	poi.LastShipperID
	from
		EDI_XML_NET_830.PurchaseOrderInfo poi
	where
		poi.TradingPartnerCode = @TradingPartnerCode
		and
		(	@purcharOrderList is null
			or convert(varchar(12), poi.PurchaseOrderNumber) in
				(	select
						ltrim(rtrim(fsstr.Value))
					from
						dbo.fn_SplitStringToRows(@purcharOrderList, ',') fsstr
				)
		)

	set
		@xmlOutput =
			(	select
					(	select
							EDI_XML.TRN_INFO(@dictionaryVersion, '830', tpi.TradingPartnerCode, '@iConnectID', tpi.TradingPartnerCode, @partialComplete)
						,	EDI_XML.SEG_BFR(@dictionaryVersion, @purpose, default, tpi.ReleaseNumber, 'DL', 'A', tpi.HorizonStartDT, tpi.HorizonEndDT, tpi.GenerationDT, default, default, default, default, default)
						,	(	select
						 			EDI_XML.LOOP_INFO('N1')
								,	EDI_XML.SEG_N1(@dictionaryVersion, 'MI', default, tpi.MaterialIssuerType, tpi.MaterialIssuer)
						 		for xml raw ('LOOP-N1'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('N1')
								,	EDI_XML.SEG_N1(@dictionaryVersion, 'SU', default, tpi.EDIVendorCodeType, tpi.EDIVendorCode)
						 		for xml raw ('LOOP-N1'), type
						 	)
						--,	(	select
						-- 			EDI_XML.LOOP_INFO('N1')
						--		,	EDI_XML.SEG_N1(@dictionaryVersion, 'ST', default, '', 'EEH')
						-- 		for xml raw ('LOOP-N1'), type
						-- 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('LIN')
								,	EDI_XML.SEG_LIN(@dictionaryVersion, 'BP', poi.EmpireBlanketPart, /* 'PD', poi.PartDescription, */ '', '', 'PO', poi.PurchaseOrderNumber, 'VP', poi.VendorPart, default, default)
								,	EDI_XML.SEG_UIT(@dictionaryVersion, poi.Unit, poi.Price)
								,	EDI_XML.SEG_PID(@dictionaryVersion, 'F', poi.PartDescription)
								,	EDI_XML.SEG_ATH(@dictionaryVersion, 'MT', poi.RawEndDT, poi.RawAccum, default, poi.AccumStartDT)
								,	EDI_XML.SEG_ATH(@dictionaryVersion, 'FI', poi.FabEndDT, poi.FabAccum, default, poi.AccumStartDT)
								,	EDI_XML.SEG_ATH(@dictionaryVersion, 'PQ', poi.AccumEndDT, poi.AccumReceived, default, poi.AccumStartDT)
								,	(	select
											EDI_XML.LOOP_INFO('SDP')
										,	EDI_XML.SEG_SDP(@dictionaryVersion, 'Y', 'A')
										,	EDI_XML_NET_830.GetReleases(@dictionaryVersion, poi.PurchaseOrderNumber)
								 		for xml raw ('LOOP-SDP'), type
								 	)
								,	case
										when poi.LastShipperID > '' then
											(	select
													EDI_XML.LOOP_INFO('SHP')
								 				,	EDI_XML.SEG_SHP(@dictionaryVersion, '01', poi.LastReceivedQty, '050', poi.LastReceivedDT, default, default, default)
												,	EDI_XML.SEG_REF(@dictionaryVersion, 'SI', poi.LastShipperID, default, default)
												for xml raw ('LOOP-SHP'), type
								 			)
										else
											(	select
													EDI_XML.LOOP_INFO('SHP')
								 				,	EDI_XML.SEG_SHP(@dictionaryVersion, '01', 0, '050', poi.AccumEndDT, default, default, default)
												for xml raw ('LOOP-SHP'), type
								 			)
									end
								,	case
										when poi.LastShipperID > '' then
											(	select
													EDI_XML.LOOP_INFO('SHP')
								 				,	EDI_XML.SEG_SHP(@dictionaryVersion, '02', poi.AccumReceived, '051', poi.AccumStartDT, null, poi.LastReceivedDT, default)
												for xml raw ('LOOP-SHP'), type
								 			)
										else
											(	select
													EDI_XML.LOOP_INFO('SHP')
								 				,	EDI_XML.SEG_SHP(@dictionaryVersion, '02', poi.AccumReceived, '051', poi.AccumStartDT, null, poi.AccumEndDT, default)
												for xml raw ('LOOP-SHP'), type
								 			)
									end
						 		from
						 			@purchaseOrders poi
								for xml raw ('LOOP-LIN'), type
						 	)
						,	EDI_XML.SEG_CTT(@dictionaryVersion, ht.LineItems, ht.HashTotal)
						from
							EDI_XML_NET_830.TradingPartnerInfo tpi
							cross apply
								(	select
										LineItems = count(distinct pod.PurchaseOrderNumber)
									,	HashTotal = sum(pod.Quantity)
									from
										EDI_XML_NET_830.PurchaseOrderDetails pod
										join @purchaseOrders po
											on po.PurchaseOrderNumber = pod.PurchaseOrderNumber
								) ht
						where
							tpi.TradingPartnerCode = @TradingPartnerCode
						for xml raw ('TRN-830'), type
					)
				for xml raw ('TRN'), type
			)
---	<Return>
	return
		@xmlOutput
end
go

select
	EDI_XML_NET_830.Get830('PSG', '52721,48236', '05', 1)


select
	poi.PurchaseOrderNumber
from
	EDI_XML_NET_830.PurchaseOrderInfo poi
where
	poi.TradingPartnerCode = 'PSG'
	and
	(	null is null
		or convert(varchar(12), poi.PurchaseOrderNumber) in
			(	select
					fsstr.Value
				from
					dbo.fn_SplitStringToRows(null, ',') fsstr
			)
	)


--declare
--	@dictionaryVersion varchar(12) = '004010'

--select
--	EDI_XML.LOOP_INFO('LIN')
--,	EDI_XML.SEG_LIN(@dictionaryVersion, 'BP', poi.EmpireBlanketPart, 'PO', poi.PurchaseOrderNumber, 'VP', poi.VendorPart, 'PD', poi.PartDescription, default, default)
--,	EDI_XML.SEG_UNT(@dictionaryVersion, poi.Unit, poi.Price, default)
--,	EDI_XML.SEG_ATH(@dictionaryVersion, 'PQ', poi.AccumStartDT, poi.AccumReceived, default, poi.AccumEndDT)
--,	EDI_XML.SEG_ATH(@dictionaryVersion, 'FI', poi.AccumStartDT, poi.FabAccum, default, poi.FabEndDT)
--,	EDI_XML.SEG_ATH(@dictionaryVersion, 'MT', poi.AccumStartDT, poi.RawAccum, default, poi.RawEndDT)
----,	EDI_XML.SEG_FST(@dictionaryVersion, )
--from
--	EDI_XML_NET_830.PurchaseOrderInfo poi
--where
--	poi.PurchaseOrderNumber in
--		(	select
--				poi.PurchaseOrderNumber
--			from
--				EDI_XML_NET_830.PurchaseOrderInfo poi
--			where
--				poi.TradingPartnerCode = 'PSG'
--				and
--				(	'35531,41340' is null
--					or convert(varchar(12), poi.PurchaseOrderNumber) in
--						(	select
--								fsstr.Value
--							from
--								dbo.fn_SplitStringToRows('15449,15450,15451', ',') fsstr
--						)
--				)
--		)
--for xml raw ('LOOP-LIN'), type

/*
declare
	@result xml

select
	@result = EDI_XML_NET_830.Get830('PSG', default, '05', 1)
*/