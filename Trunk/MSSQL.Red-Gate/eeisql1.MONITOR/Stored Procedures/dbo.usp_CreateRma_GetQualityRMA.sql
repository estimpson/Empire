SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[usp_CreateRma_GetQualityRMA]
	@RMANumber varchar(50)
,	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings off
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
declare
	@RMAShippers table
(	RMAShipperID int primary key
,	RMADateStamp datetime
,	RMASerialList varchar(max)
)
insert
	@RMAShippers
(	RMAShipperID
,	RMADateStamp
,	RMASerialList
)
select
	RMAShipperID = at.shipper
,	RMADateStamp = max(at.date_stamp)
,	RMASerialList = FX.ToList(at.serial)
from
	dbo.audit_trail at
where
	at.notes = @RMANumber
	and at.type = 'U'
group by
	at.shipper

declare
	@RTVShippers table
(	RTVShipperID int
,	RTVDateStamp datetime
,	RTVSerialList varchar(max)
,	RMAShipperID int
)

insert
	@RTVShippers
(	RTVShipperID
,	RTVDateStamp
,	RTVSerialList
,	RMAShipperID
)

select
	RTVShipperID = RTVShippers.RTVShipperID
,	RTVDateStamp = RTVShippers.RTVDateStamp
,	RTVSerialList = RTVShippers.RTVSerialList
,	rs.RMAShipperID
from
	@RMAShippers rs
	outer apply
		(	select
				RTVShipperID = at.shipper
			,	RTVDateStamp = max(at.date_stamp)
			,	RTVSerialList = FX.ToList(at.serial)
			from
				dbo.audit_trail at
			where
				at.serial in
					(	select
							fstr.Value
						from
							dbo.fn_SplitStringToRows(rs.RMASerialList, ',') fstr
					)
				and at.type = 'V'
				and at.date_stamp > rs.RMADateStamp
			group by
				at.shipper
		) RTVShippers

select
	RMAShipperID = RMAs.RMAShipperID
,	RMADateStamp = RMAs.RMADateStamp
,	RMASerialList = RMAs.RMASerialList
,	rmaShipper.RMAStatus
,	RTVShipperID = RTVs.RTVShipperID
,	RTVDateStamp = RTVs.RTVDateStamp
,	RTVSerialList = RTVs.RTVSerialList
,	rtvShipper.RTVStatus
from
	@RMAShippers RMAs
	left join @RTVShippers RTVs
		on RTVs.RMAShipperID = RMAs.RMAShipperID
	outer apply
	(	select
			RMAShipperID = s.id
		,	RMAStatus = s.status
		from
			dbo.shipper s
		where
			s.id = RMAs.RMAShipperID
	) rmaShipper
	outer apply
		(	select
				RTVShipperID = s.id
			,	RTVStatus = s.status
			from
				dbo.shipper s
			where
				s.id = RTVs.RTVShipperID
		) rtvShipper

--- </Body>

---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>

/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go

declare
	@Param1 [scalar_data_type]

set	@Param1 = [test_value]

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_CreateRma_GetQualityRMA
	@Param1 = @Param1
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/
GO
