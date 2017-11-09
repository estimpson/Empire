SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[USP_Rpt_Empower_ProofReport_CRVersion_Dynamic]( 
		@ProofReportID	varchar(25),
		@Type			int )
as
/*

exec Monitor.dbo.USP_Rpt_Empower_ProofReport_CRVersion_Dynamic '054980',0

*/

SELECT  
	ap_check_selection_items.group_number, 
	ap_check_selection_items.stub_number, 
	ap_check_selection_items.sort_order, 
	ap_check_selections.ap_check_selection, 
	ap_documents.pay_unit,
	ap_documents.bank_account,
	ap_documents.currency,
	ap_documents.direct_deposit,
	--ap_documents.buy_vendor,
	buy_vendor=ap_documents.pay_vendor,
	ap_documents.document_type,
	ap_documents.ap_document,
	ap_documents.purchase_order,	
	purchase_orders.po_type,
	ap_documents.document_date,
	ap_documents.payment_term,
	ap_documents.due_date,
	ap_documents.document_amount * ap_documents.multiplier document_amount,
	ap_documents.ledger_amount * ap_documents.multiplier ledger_amount,
	(SELECT open_amount
		FROM GetDocumentOpenAmount(ap_documents.document_type,
                                     ap_documents.document_id1,
                                     ap_documents.document_id2,
                                     ap_documents.document_id3)) * ap_documents.multiplier open_amount,
	ap_check_selection_items.discount_amount * ap_documents.multiplier discount_amount, 
	ap_check_selection_items.pay_amount, 
	ap_document_items.document_line inv_cm_line, 
	ap_document_items.sort_line inv_cm_sort_line,
	item=coalesce(ap_document_items.item,ap_document_items.item_description),
	ap_document_items.item_description,
	ap_document_items.posting_account,
	ap_document_items.quantity,
	ap_document_items.quantity_uom,
	ap_document_items.unit_cost as AP_Price,
	ap_document_items.unit_cost_uom,
	ap_document_items.document_amount * ap_documents.multiplier item_document_amount,
	chart_of_account_items.account_description,
	gl_cost_transactions.posting_account gl_posting_account,
    convert(numeric(18,2),isnull(gl_cost_transactions.ledger_amount,0)) gl_amount,
	purchase_order_items.unit_cost po_unit_cost,
	po_receiver_items.shipping_advice,
	po_receiver_items.quantity quantity_received, 
    po_receiver_items.unit_cost po_receiver_items_unit_cost,
    po_receiver_items.document_amount po_receiver_items_total_cost, 
	po_receiver_items.posting_account po_receiver_items_posting_account,
    po_receiver_items.item po_receiver_items_item
	,approver_comments=case when document_approval_items.approval_sequence is NULL then NULL else document_approval_items.approver_comments end
	,approver=case when document_approval_items.approval_sequence is NULL then NULL else document_approval_items.approver  end
INTO #tmp 
 FROM   
	ap_check_selections INNER JOIN 
	ap_check_selection_items ON 
		ap_check_selection_items.ap_check_selection = ap_check_selections.ap_check_selection INNER JOIN  
	ap_documents ON
		ap_documents.buy_vendor = ap_check_selection_items.buy_vendor AND 
		ap_documents.ap_document = ap_check_selection_items.ap_document AND
		ap_documents.document_type = ap_check_selection_items.document_type INNER JOIN
	ap_document_items ON
		ap_document_items.buy_vendor = ap_documents.buy_vendor AND 
		ap_document_items.ap_document = ap_documents.ap_document AND
		ap_document_items.document_type = ap_documents.document_type INNER JOIN
	gl_cost_transactions ON
		gl_cost_transactions.document_type = ap_document_items.document_type AND
		gl_cost_transactions.document_id1 = ap_document_items.document_id1 AND
		gl_cost_transactions.document_id2 = ap_document_items.document_id2 AND
		gl_cost_transactions.document_id3 = ap_document_items.document_id3 AND
		gl_cost_transactions.document_line = ap_document_items.document_line INNER JOIN
	posting_accounts ON
		posting_accounts.fiscal_year = gl_cost_transactions.fiscal_year AND
		posting_accounts.ledger = gl_cost_transactions.ledger AND
		posting_accounts.posting_account = gl_cost_transactions.posting_account INNER JOIN
	chart_of_account_items ON
		chart_of_account_items.fiscal_year = posting_accounts.fiscal_year AND
		chart_of_account_items.coa = posting_accounts.coa AND
		chart_of_account_items.account = posting_accounts.account LEFT OUTER JOIN
	purchase_orders ON
		purchase_orders.purchase_order = ap_documents.purchase_order AND
		purchase_orders.purchase_order_release = ap_documents.purchase_order_release LEFT OUTER JOIN
	purchase_order_items ON
		purchase_order_items.purchase_order = ap_document_items.purchase_order AND
		purchase_order_items.purchase_order_release = ap_document_items.purchase_order_release AND
		purchase_order_items.document_line = ap_document_items.purchase_order_document_line LEFT OUTER JOIN
	po_receiver_application_items ON
		po_receiver_application_items.source_document_type = ap_document_items.document_type AND
		po_receiver_application_items.source_document_id1 = ap_document_items.document_id1 AND
		po_receiver_application_items.source_document_id2 = ap_document_items.document_id2 AND
		po_receiver_application_items.source_document_id3 = ap_document_items.document_id3 AND
		po_receiver_application_items.source_document_line = ap_document_items.document_line LEFT OUTER JOIN
	po_receiver_items ON
		po_receiver_items.purchase_order = po_receiver_application_items.por_purchase_order AND
		po_receiver_items.purchase_order_release = po_receiver_application_items.por_purchase_order_release AND
		po_receiver_items.shipping_advice = po_receiver_application_items.por_shipping_advice AND
		po_receiver_items.document_type = po_receiver_application_items.por_document_type AND
		po_receiver_items.document_line = po_receiver_application_items.por_document_line LEFT OUTER JOIN
	document_approval_items document_approval_items ON 
		document_approval_items.document_id1 = ap_document_items.document_id1 
		AND document_approval_items.document_id2 = ap_document_items.document_id2 
		AND document_approval_items.document_id3 = ap_document_items.document_id3 
		AND document_approval_items.document_type = ap_document_items.document_type  
WHERE
	ap_check_selections.ap_check_selection = @ProofReportID
ORDER BY           
	ap_documents.posting_account,
	ap_documents.pay_vendor,
	ap_documents.due_date

--Select	*
--from	#tmp
--where	ap_document='AUGUST 2017 COPPER'

 declare @columnas varchar(max),
		@GrupByColumns varchar(max),
		@SumByColumns varchar(max),
		@columnasLABEL varchar(max)

set @columnas = ''
set	@GrupByColumns = ''
set @columnasLABEL=''
set @SumByColumns=''

select @columnasLABEL = coalesce(@columnasLABEL + '[' + cast(account as varchar(150)) + ']=isnull(['+ gl_posting_account + '],0),', '')
FROM (select distinct account=replace(account_description,':','') + ' (' + gl_posting_account + ')', gl_posting_account from #tmp) as DTM

--select @GrupByColumns = coalesce(@GrupByColumns + 'sum([' + cast(Account as varchar(150)) + ']),', '') 
--FROM (select distinct Account=replace(account_description,':','') + ' (' + gl_posting_account + ')' from #tmp) as DTM

--select @GrupByColumns
select @columnas = coalesce(@columnas + '[' + cast(Account as varchar(150)) + '],', '')
FROM (select distinct Account=gl_posting_account from #tmp) as DTM

select @GrupByColumns = coalesce(@GrupByColumns + 'sum([' + cast(Account as varchar(150)) + ']),', '') 
FROM (select distinct Account=gl_posting_account from #tmp) as DTM

select @SumByColumns = coalesce(@SumByColumns + 'Convert(numeric(18,2),ISNULL([' + cast(Account as varchar(150)) + '],0.00))+', '') 
FROM (select distinct Account=gl_posting_account from #tmp) as DTM

if len(@columnas ) >0
begin
	set @columnas = left(@columnas,LEN(@columnas)-1)
	set @GrupByColumns = left(@GrupByColumns,LEN(@GrupByColumns)-1)
	
	set @SumByColumns = left(@SumByColumns,LEN(@SumByColumns)-1)
	set @columnasLABEL = left(@columnasLABEL,LEN(@columnasLABEL)-1)

	declare @ListaColumnas nvarchar(max)
	set @ListaColumnas=NULL
	select @ListaColumnas= Coalesce(@ListaColumnas + ' ,' + campo,campo)
	from(
	Select id, value = ltrim(rtrim(value)), Campo = 'Account' + convert(varchar,id)
	from   monitor.[FT].[udf_SplitStringToRows] (@columnas,',')  )Data

--select @ListaColumnas = + @ListaColumnas + ')'

--select @ListaColumnas
	--print @SumByColumns
	--print @GrupByColumns

	DECLARE @SQLString nvarchar(max)

	set @SQLString = N'
		SELECT *,GrandTotal=NULL
		into HN.TROY_Proof_Report
		FROM 
		(
			Select	buy_vendor,item,gl_amount=isnull(gl_amount,0),approver_comments,approver,gl_posting_account,AP_Price=max(AP_Price),ap_document,document_date,po_receiver_items_unit_cost
			from	#tmp
			group by buy_vendor,item,gl_amount,approver_comments,approver,gl_posting_account,ap_document,document_date,po_receiver_items_unit_cost
			) AS SourceTable
		PIVOT
		(
		SUM(gl_amount)
		FOR gl_posting_account IN (' + @columnas + ')
		) AS PivotTable;	
		'

		--Select	buy_vendor,item,gl_amount,approver_comments,approver,gl_posting_account
		--	from	#tmp

	--select @SQLString

	EXECUTE sp_executesql @SQLString

	--set	@SQLString = 'insert into  HN.TROY_Proof_Report( buy_vendor, approver_comments,approver,GrandTotal,'+  @columnas + ') select buy_vendor+''-SubTotal'',approver_comments='''',approver='''',GrandTotal=0.00,' + @GrupByColumns + ' from  HN.TROY_Proof_Report group by buy_vendor'
	--EXECUTE sp_executesql @SQLString
	set	@SQLString = 'update HN.TROY_Proof_Report set GrandTotal=0.00'
	EXECUTE sp_executesql @SQLString
	
	set	@SQLString = 'update HN.TROY_Proof_Report set GrandTotal=convert(numeric(18,2),('+  @SumByColumns + '))'
	EXECUTE sp_executesql @SQLString

	--set	@SQLString = 'SELECT buy_vendor,item,approver_comments,approver,AP_Price,ap_document,document_date,po_receiver_items_unit_cost, ' + @columnasLABEL + ', GrandTotal=convert(numeric(18,2),GrandTotal) FROM HN.TROY_Proof_Report order by buy_vendor '
	--EXECUTE sp_executesql @SQLString

	create table  #result 
	(
		buy_vendor						varchar(25),
		item							varchar(4000),
		approver_comments				varchar(4000),
		approver						varchar(25),
		AP_Price						numeric(18,6),
		ap_document						varchar(25),
		document_date					datetime,
		po_receiver_items_unit_cost		numeric(18,6),
		Account1						numeric(18,2),
		Account2						numeric(18,2),
		Account3						numeric(18,2),
		Account4						numeric(18,2),
		Account5						numeric(18,2),
		Account6						numeric(18,2),
		Account7						numeric(18,2),
		Account8						numeric(18,2),
		Account9						numeric(18,2),
		Account10						numeric(18,2),
		Account11						numeric(18,2),
		Account12						numeric(18,2),
		Account13						numeric(18,2),
		Account14						numeric(18,2),
		GrandTotal						numeric(18,2)
	)

	declare @ColumnasFijas nvarchar(max)
	Set @ColumnasFijas = 'buy_vendor, item, approver_comments, approver, AP_Price, ap_document, document_date, po_receiver_items_unit_cost'

declare @InsertInto nvarchar(max)
--select @ColumnasFijas,@ListaColumnas
set @InsertInto= 'Insert into #result  (' + @ColumnasFijas + ',' +  @ListaColumnas + ', GrandTotal )' + ' Select ' + @ColumnasFijas + ',' + @columnas + ', GrandTotal FROM HN.TROY_Proof_Report order by buy_vendor '
--set @InsertInto= 'Insert into #result  (' + @ColumnasFijas + ',' +  @ListaColumnas + ', GrandTotal' + ' Select ' + @ColumnasFijas + ',' + @columnas + ', GrandTotal=convert(numeric(18,2),GrandTotal) FROM HN.TROY_Proof_Report order by buy_vendor '

--Select @InsertInto
--Insert into #result  (buy_vendor, item, approver_comments, approver, AP_Price, ap_document, document_date, po_receiver_items_unit_cost,Account1 ,Account2 ,Account3 ,Account4, GrandTotal ) 
--Select buy_vendor, item, approver_comments, approver, AP_Price, ap_document, document_date, po_receiver_items_unit_cost,[212112],[213712],[505412],[801112], GrandTotal 
--FROM HN.TROY_Proof_Report order by buy_vendor 

EXECUTE sp_executesql @InsertInto

	if @Type =0
	begin
		select	*	from	#result
	end

	if @Type=1
	begin
		select	DISTINCT splitrows.id,
				AccountField=splitrows.Campo, 
				AccountDescription=temp.account_description + '( ' + splitrows.value + ' )'
				--+ '( ' replace(replace(splitrows.value,'[',''),']','') + ' )'
		from(
			Select id, value = ltrim(rtrim(value)), Campo = 'Account' + convert(varchar,id),gl_posting=replace(replace(ltrim(rtrim(value)),'[',''),']','')
			from   monitor.[FT].[udf_SplitStringToRows] (@columnas,',') 
		)splitrows
		join #tmp temp on temp.gl_posting_account = gl_posting
	end
end

drop table #tmp
drop table HN.TROY_Proof_Report
drop table #result
GO
