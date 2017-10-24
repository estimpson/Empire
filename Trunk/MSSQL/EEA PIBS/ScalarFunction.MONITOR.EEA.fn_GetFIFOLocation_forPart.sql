
/*
Create ScalarFunction.MONITOR.EEA.fn_GetFIFOLocation_forPart.sql
*/

use MONITOR
go

if	objectproperty(object_id('EEA.fn_GetFIFOLocation_forPart'), 'IsScalarFunction') = 1 begin
	drop function EEA.fn_GetFIFOLocation_forPart
end
go

create function EEA.fn_GetFIFOLocation_forPart
(	@Part varchar(25)
,	@Status varchar(1) = 'A'
,	@Location varchar(10) = null
,	@GroupNo varchar(25) = null 
,	@Secured char(1) = 'N'
)
returns varchar(10)
as 
begin
	declare @Objects table
	(	ID int not null IDENTITY(1, 1) primary key
	,	Serial int
	,	Location varchar(10)
	,	Quantity numeric(20, 6)
	,	BreakoutSerial int null
	,	FirstDT datetime null
	,	IsInFifo char(1)
	)

	insert
		@Objects
	(	Serial
	,	Location
	,	Quantity
	,	BreakoutSerial
	,	FirstDT
	,	IsInFifo
	)
	select
		Serial
	,	Location
	,	Quantity
	,	BreakoutSerial
	,	FirstDT
	,	IsInFifo
	from
		EEA.fn_GetPartFIFO(@Part, @Status, @Location, @GroupNo, @Secured)
	
	declare
		@FIFOLocation varchar(10)
	
	select
		@FIFOLocation = Location
	from
		@Objects
	where
		ID = 1
	
	return
		@FIFOLocation
end
go

