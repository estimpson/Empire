use EEH
go

create table dbo.po_receiver_items_historical_daily_new
(	time_stamp datetime not null
,	fiscal_year varchar(5) not null
,	period smallint not null
,	reason varchar(15) null
,	purchase_order varchar(25) not null
,	bill_of_lading varchar(25) not null
,	bol_line smallint not null
,	receiver varchar(25) not null
,	invoice varchar(25) null
,	inv_line smallint null
,	item varchar(50) null
,	approved char(1) null
,	receiver_comments text null
,	ledger_account_code varchar(50) null
,	quantity_received numeric(18, 6) null
,	unit_cost numeric(18, 6) null
,	changed_date datetime null
,	changed_user_id varchar(25) null
,	total_cost numeric(18, 6) null
,	item_description text null
,	container_id varchar(25) null
,	package varchar(25) null
,	country_of_origin varchar(25) null
,	freight_cost numeric(18, 6) null
,	other_cost numeric(18, 6) null
,	MonthEnd varchar(1) null
) on Third textimage_on Third
go

alter table dbo.po_receiver_items_historical_daily_new add primary key nonclustered 
(	time_stamp
,	fiscal_year
,	period
,	purchase_order
,	bill_of_lading
,	bol_line
,	receiver
) on Third
go

insert
	dbo.po_receiver_items_historical_daily_new
select
	*
from
	dbo.po_receiver_items_historical_daily prihd
where
	prihd.time_stamp > dateadd(month, -3, getdate())
go

exec sp_rename 'dbo.po_receiver_items_historical_daily', 'po_receiver_items_historical_daily_old'
go

exec sp_rename 'dbo.po_receiver_items_historical_daily_new', 'po_receiver_items_historical_daily'
go

drop table dbo.po_receiver_items_historical_daily_old
go

create nonclustered index idx_po_receiver_items_historical_daily_1 on dbo.po_receiver_items_historical_daily
(	time_stamp
,	purchase_order
) on Third
go

create nonclustered index rgni_reconciliation on dbo.po_receiver_items_historical_daily
(	fiscal_year
,	period
,	time_stamp
,	invoice
) on Third
go
