SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_EEIPOReceiptTotals]
as
begin transaction
set nocount on
create table FT.POReceiptTotals_New
(	PONumber int NOT NULL,
	Part varchar(25) NOT NULL,
	StdQty numeric(20, 6) NOT NULL,
	AccumAdjust numeric(20, 6) NOT NULL,
	LastReceivedAmount numeric(20, 6) NULL,
	LastReceivedDT datetime NULL,
	ReceiptCount int NOT NULL,
	LastUpdated datetime NOT NULL,
	primary key clustered
	(	PONumber,
		Part))

insert	FT.POReceiptTotals_New
select	*
from	FT.vwPOReceiptTotals

drop table FT.POReceiptTotals

execute sp_rename 'FT.POReceiptTotals_New', 'POReceiptTotals'
commit
GO
