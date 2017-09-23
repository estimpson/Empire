SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [EEIUser].[usp_QT_Metrics_CategoryByQuantity]
as
set nocount on
set ansi_warnings off

--- <Body>
declare @tempQuotes table
(
	Category varchar(50)
,	Quantity int
)

declare 
	@CategoryList varchar(255)
,	@CategoryCode varchar(50)

set @CategoryList = 'A,DC,F,L,S,O,PCB,EPS,SVR'

while (@CategoryList != '') begin
	if (PATINDEX('%,%', @CategoryList) > 0) begin
		set @CategoryCode = SUBSTRING(@CategoryList,0, PATINDEX('%,%', @CategoryList))
	end
	else begin
		set @CategoryCode = @CategoryList
	end
	

	insert @tempQuotes
	(
		Category
	,	Quantity
	)
	select
		Category = ql.ApplicationCode
	,	Quantity = COUNT(ql.ApplicationCode)
	from
		eeiuser.QT_QuoteLog ql
	where
		ql.ApplicationCode = @CategoryCode
		and DATEPART(YYYY, ql.ReceiptDate) = DATEPART(yyyy, getdate())
	group by
		ql.ApplicationCode
		
		
	if (PATINDEX('%,%', @CategoryList) > 0) begin
		set @CategoryList = SUBSTRING(@CategoryList, PATINDEX('%,%', @CategoryList) + 1, LEN(@CategoryList))
	end
	else begin
		set @CategoryList = ''
	end
end

update @tempQuotes set Category = 'Airbag' where Category = 'A'
update @tempQuotes set Category = 'Direct Connect' where Category = 'DC'
update @tempQuotes set Category = 'Fascia' where Category = 'F'
update @tempQuotes set Category = 'Lighting' where Category = 'L'
update @tempQuotes set Category = 'Steering' where Category = 'S'
update @tempQuotes set Category = 'Other' where Category = 'O'
update @tempQuotes set Category = 'PCB' where Category = 'PCB'
update @tempQuotes set Category = 'EPS' where Category = 'EPS'
update @tempQuotes set Category = 'Service' where Category = 'SRV'
--- </Body>
	
	
--- <Return>	
select 
	Category
,	Quantity
from 
	@tempQuotes
--- </Return>
GO
