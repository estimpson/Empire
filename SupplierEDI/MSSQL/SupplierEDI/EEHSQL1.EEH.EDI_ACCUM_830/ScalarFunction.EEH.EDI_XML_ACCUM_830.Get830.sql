
/*
Create ScalarFunction.EEH.EDI_XML_ACCUM_830.Get830.sql
*/

use EEH
go

if	objectproperty(object_id('EDI_XML_ACCUM_830.Get830'), 'IsScalarFunction') = 1 begin
	drop function EDI_XML_ACCUM_830.Get830
end
go

create function EDI_XML_ACCUM_830.Get830
(	@TradingPartnerCode varchar(12)
,	@purcharOrderList varchar(max) = null
,	@purpose char(2)
,	@partialComplete int
)
returns xml
with encryption
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
		EDI_XML.PurchaseOrderInfo poi
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
		and getdate() < '2019/06/26'

	set
		@xmlOutput =
			(	select
					(	select
							FxEDI.EDI_XML.TRN_INFO(@dictionaryVersion, '830', tpi.TradingPartnerCode, '@iConnectID', tpi.TradingPartnerCode, @partialComplete)
						,	FxEDI.EDI_XML.SEG_BFR(@dictionaryVersion, @purpose, default, tpi.ReleaseNumber, 'DL', 'A', tpi.HorizonStartDT, tpi.HorizonEndDT, tpi.GenerationDT, default, default, default, default, default)
						,	(	select
						 			FxEDI.EDI_XML.LOOP_INFO('N1')
								,	FxEDI.EDI_XML.SEG_N1(@dictionaryVersion, 'MI', default, tpi.MaterialIssuerType, tpi.MaterialIssuer)
						 		for xml raw ('LOOP-N1'), type
						 	)
						,	(	select
						 			FxEDI.EDI_XML.LOOP_INFO('N1')
								,	FxEDI.EDI_XML.SEG_N1(@dictionaryVersion, 'SU', default, tpi.EDIVendorCodeType, tpi.EDIVendorCode)
						 		for xml raw ('LOOP-N1'), type
						 	)
						--,	(	select
						-- 			FxEDI.EDI_XML.LOOP_INFO('N1')
						--		,	FxEDI.EDI_XML.SEG_N1(@dictionaryVersion, 'ST', default, '', 'EEH')
						-- 		for xml raw ('LOOP-N1'), type
						-- 	)
						,	(	select
						 			FxEDI.EDI_XML.LOOP_INFO('LIN')
								,	FxEDI.EDI_XML.SEG_LIN(@dictionaryVersion, 'BP', poi.EmpireBlanketPart, /* 'PD', poi.PartDescription, */ '', '', 'PO', poi.PurchaseOrderNumber, 'VP', poi.VendorPart, default, default)
								,	FxEDI.EDI_XML.SEG_PID(@dictionaryVersion, 'F', poi.PartDescription)
								,	FxEDI.EDI_XML.SEG_ATH(@dictionaryVersion, 'MT', poi.RawEndDT, poi.RawAccum, default, poi.AccumStartDT)
								,	FxEDI.EDI_XML.SEG_ATH(@dictionaryVersion, 'FI', poi.FabEndDT, poi.FabAccum, default, poi.AccumStartDT)
								,	FxEDI.EDI_XML.SEG_ATH(@dictionaryVersion, 'PQ', poi.AccumEndDT, poi.AccumReceived, default, poi.AccumStartDT)
								,	(	select
											FxEDI.EDI_XML.LOOP_INFO('SDP')
										,	FxEDI.EDI_XML.SEG_SDP(@dictionaryVersion, 'Y', 'A')
										,	EDI_XML_ACCUM_830.GetReleases(@dictionaryVersion, poi.PurchaseOrderNumber)
								 		for xml raw ('LOOP-SDP'), type
								 	)
								,	case
										when poi.LastShipperID > '' then
											(	select
													FxEDI.EDI_XML.LOOP_INFO('SHP')
								 				,	FxEDI.EDI_XML.SEG_SHP(@dictionaryVersion, '01', poi.LastReceivedQty, '050', poi.LastReceivedDT, default, default, default)
												,	FxEDI.EDI_XML.SEG_REF(@dictionaryVersion, 'SI', poi.LastShipperID, default, default)
												for xml raw ('LOOP-SHP'), type
								 			)
										else
											(	select
													FxEDI.EDI_XML.LOOP_INFO('SHP')
								 				,	FxEDI.EDI_XML.SEG_SHP(@dictionaryVersion, '01', 0, '050', poi.AccumEndDT, default, default, default)
												for xml raw ('LOOP-SHP'), type
								 			)
									end
								,	case
										when poi.LastShipperID > '' then
											(	select
													FxEDI.EDI_XML.LOOP_INFO('SHP')
								 				,	FxEDI.EDI_XML.SEG_SHP(@dictionaryVersion, '02', poi.AccumReceived, '051', poi.AccumStartDT, null, poi.LastReceivedDT, default)
												for xml raw ('LOOP-SHP'), type
								 			)
										else
											(	select
													FxEDI.EDI_XML.LOOP_INFO('SHP')
								 				,	FxEDI.EDI_XML.SEG_SHP(@dictionaryVersion, '02', poi.AccumReceived, '051', poi.AccumStartDT, null, poi.AccumEndDT, default)
												for xml raw ('LOOP-SHP'), type
								 			)
									end
						 		from
						 			@purchaseOrders poi
								for xml raw ('LOOP-LIN'), type
						 	)
						,	FxEDI.EDI_XML.SEG_CTT(@dictionaryVersion, ht.LineItems, ht.HashTotal)
						from
							EDI_XML.TradingPartnerInfo tpi
							cross apply
								(	select
										LineItems = count(distinct pod.PurchaseOrderNumber)
									,	HashTotal = sum(pod.Quantity)
									from
										EDI_XML.PurchaseOrderDetails pod
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
	EDI_XML_ACCUM_830.Get830('PSG', '52721,48236', '05', 1)