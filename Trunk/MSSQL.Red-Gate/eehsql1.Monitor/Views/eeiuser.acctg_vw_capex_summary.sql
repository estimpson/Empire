SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [eeiuser].[acctg_vw_capex_summary]

as

select	fiscal_year, 
		left(capex_request,2) as category, 
		capex_request, 
		ca.cost_identifier, 
		document_type, 
		capex_request_type, 
		project_manager, 
		document_date, 
		product_launch, 
		customer, 
		cost_coa,  
		capex_request_description, 
		capex_inservice_date, 
		isnull(ca.ledger_amount,0) as approved_capex_budget_amount, 
		isnull(AA.ledger_amount,0) as POs_issued,
		isnull(AA.applied_ledger_amount,0) as POs_receipted_or_closed,
		isnull(AA.open_ledger_amount,0) as Open_POs,
		isnull(AA.invoiced_amount,0) as Invoiced_amount,
		isnull(AA.paid_amount,0) as Paid_amount,
		isnull(vcgct.transactions_amount,0) as allocated_transactions 

from	capex_requests ca

	left join	(	select		(case when charindex('_',poi.cost_account) = 0 then poi.cost_account else left(poi.cost_account,charindex('_',poi.cost_account)-1) end) as cost_identifier,	
								sum(poi.document_amount/po.document_exchange_rate) as ledger_amount, 
								sum(vpoi.applied_amount/po.document_exchange_rate) as applied_ledger_amount,
								sum((poi.document_amount/isnull(po.document_exchange_rate,1)) - (vpoi.applied_amount/isnull(po.document_exchange_rate,1))) as open_ledger_amount,
								sum(BB.invoiced_amount) as invoiced_amount,
								sum(BB.paid_amount) as paid_amount
				
					from		purchase_orders po 
	
						join	purchase_order_items poi 
							on	po.purchase_order = poi.purchase_order
							and po.purchase_order_release = poi.purchase_order_release
			
						join	vw_purchase_order_items vpoi
							on	po.purchase_order = vpoi.purchase_order
							and po.purchase_order_release = poi.purchase_order_release
							
						left join	(	select			adi.purchase_order,
														adi.purchase_order_release,
														adi.por_document_line,
														sum(adi.document_amount/isnull(ad.document_exchange_rate,1)) as invoiced_amount,
														sum((adi.document_amount/isnull(ad.document_exchange_rate,1))*ISNULL(bb.paid_percentage,0)) as paid_amount
										from			ap_documents ad
											join		ap_document_items adi 
												on		ad.buy_vendor = adi.buy_vendor 
													and	ad.ap_document = adi.ap_document 
													and ad.document_type = adi.document_type

											left join	(	select		purchase_order,
																		purchase_order_release,
																		sum(ledger_amount) as invoiced_amount, 
																		sum(applied_amount/document_exchange_rate) as paid_amount, 
																		sum(case when isnull(applied_amount,0) = 0 then 0 else round(ledger_amount/(applied_amount/document_exchange_rate),2) end) as paid_percentage
											
															from		vt_ap_documents 
															group by	purchase_order,
																		purchase_order_release
														) bb
												on		adi.purchase_order = bb.purchase_order
													and adi.purchase_order_release = bb.purchase_order_release
										
										group by		adi.purchase_order,
														adi.purchase_order_release,
														adi.por_document_line
									) BB 
							on	poi.purchase_order = BB.purchase_order
							and	poi.purchase_order_release = BB.purchase_order_release
							and	poi.document_line = BB.por_document_line
			
					where		isnull(poi.cost_account,'') <> ''
			
					group by (case when charindex('_',poi.cost_account) = 0 then poi.cost_account else left(poi.cost_account,charindex('_',poi.cost_account)-1) end)
				) AA
		on ca.cost_identifier = AA.cost_identifier
	
	left join	(	select		a.cost_identifier, 
								sum(ledger_amount) as transactions_amount 
					from		vw_cost_gl_cost_transactions a 
					where		document_type <> 'PORCV' 
					group by a.cost_identifier
				) vcgct
		on ca.cost_identifier = vcgct.cost_identifier

where		fiscal_year = '2018'
--		and ca.cost_identifier = 'AL2018-135'

	 
GO
