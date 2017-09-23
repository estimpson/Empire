SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[usp_DESADV_Delphi_ParentSerialPartPackDetails]
	@ParentSerial int
,	@Part varchar(25)
,	@PackageType varchar(25)
,	@BoxQty int
with encryption
as
declare
	@result int
set nocount on
set ansi_warnings off

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

--- <Body>
/*	Loop through serials and write details. */
declare
	@boxSerial int

declare
	boxSerials cursor local for
select
	Serial
from
	#ShipperSerials ss
where
	Box = 1
	and
		(
			ParentSerial = @ParentSerial
			or
				(
					ParentSerial is null
					and
						@ParentSerial is null
				)
		)
	and
		Part = @Part
	and
		PackageType = @PackageType
	and
		BoxQty = @BoxQty

open
	boxSerials
	
while
	1 = 1 begin
	
	fetch
		boxSerials
	into
		@boxSerial
	
	if	@@FETCH_STATUS != 0 begin
		break
	end
	
	--insert #desadvData (MessageSection, EDIFACTData) select '0510', 'GIR+3+' + convert(varchar, @boxSerial) + ':AW'''
end

close
	boxSerials

deallocate
	boxSerials

--- </Body>

---	<Return>
set	@result = 0
return
	@result
--- </Return>
GO
