
if	objectproperty(object_id('FT.fn_GetFIFOLocation_forPart'), 'IsScalarFunction') = 1 begin
	drop function FT.fn_GetFIFOLocation_forPart
end
go

create function FT.fn_GetFIFOLocation_forPart
(	@Part varchar(25)
,	@Status varchar(1) = 'A'
,	@Plant varchar(10) = null
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
		FT.fn_GetPartFIFO(@Part, @Status, @Plant, @Location, @GroupNo, @Secured)
	
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


select
	*
from
	FT.fn_GetPartFIFO('K938 828-06', 'A', 'EEA', null, null, 'N')

select
	FT.fn_GetFIFOLocation_forPart('K938 828-06', 'A', 'EEA', null, null, 'N')
