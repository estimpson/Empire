SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[msp_generate_kanban] (
	@orderno	numeric (8) )
as
-------------------------------------------------------------------------------------
--	This procedure generates kanban table information from data stored in order
--	header.
--
--	Modifications:	12 MAR 1999, Eric E. Stimpson	Original
--			25 MAY 1999, Eric E. Stimpson	Modified formatting.
--							Changed decimal to numeric.
--
--	Paramters:	@orderno	mandatory
--
--	Returns:	  0	success
--			 -1	error, invalid begin or end kanban number for order
--
--	Process:
--	1. Declarations.
--	2. Get beginning and ending kanban numbers from order.
--	3. Find the common alpha numeric root index (position) between beginning and ending kanban numbers.
--	4. Calculate the root and suffixes from the root index.
--	5. If suffixes are numeric, calculate the beginning and ending counters.
--	6. If kanban numbers are valid, generate kanban table data.
--	7. Otherwise return error code.
--	8. Return success.
---------------------------------------------------------------------------------------

--	1. Declarations.
declare	@beginkanban	varchar (6),
	@endkanban	varchar (6),
	@rootindex	integer,
	@root		varchar (5),
	@suffix1	char (6),
	@suffix2	char (6),
	@begin		integer,
	@end		integer,
	@count		integer


--	2. Get beginning and ending kanban numbers from order.
select	@beginkanban = begin_kanban_number,
	@endkanban = end_kanban_number
  from	order_header
 where	order_no = @orderno

--	3. Find the common alpha numeric root index (position) between beginning and ending kanban numbers.
select	@rootindex = (
		case	
			when substring ( @beginkanban, 1, 1 ) = substring ( @endkanban, 1, 1 )
				then (
					case
						when substring ( @beginkanban, 2, 1 ) = substring ( @endkanban, 2, 1 )
							then (
								case
									when substring ( @beginkanban, 3, 1 ) = substring ( @endkanban, 3, 1 )
										then (
											case
												when substring ( @beginkanban, 4, 1 ) = substring ( @endkanban, 4, 1 )
													then (
														case
															when substring ( @beginkanban, 5, 1 ) = substring ( @endkanban, 5, 1 )
																then 5
																else 4
														end )
													else 3
											end )
											else 2
								end )
								else 1
					end )
					else 0
		end )

--	4. Calculate the root and suffixes from the root index.
select	@root = substring ( @beginkanban, 1, @rootindex ),
	@suffix1 = right ( '000000' + substring ( @beginkanban, @rootindex + 1, 6 ), 6 ),
	@suffix2 = right ( '000000' + substring ( @endkanban, @rootindex + 1, 6 ), 6 )

--	5. If suffixes are numeric, calculate the beginning and ending counters.
if @suffix1 like '[0-9][0-9][0-9][0-9][0-9][0-9]' and
	@suffix2 like '[0-9][0-9][0-9][0-9][0-9][0-9]' and
	@root is not null
	select	@begin = convert ( integer, @suffix1 ),
			@end = convert ( integer, @suffix2 ),
			@count = convert ( integer, @suffix1 )

--	6. If kanban numbers are valid, generate kanban table data.
if @end >= @begin
	while @count <= @end
	begin -- (1B)
		begin transaction -- (1T)
		insert	kanban
		select	substring ( @root + right ( '00000' + convert ( varchar (6), @count ), datalength ( @beginkanban ) - datalength ( @root ) ), 1, datalength ( @beginkanban ) ) kanban,
			@orderno,
			line11,
			line12,
			line13,
			line14,
			line15,
			line16,
			line17,
			'A' status,
			standard_pack
		  from	order_header
		 where	order_no = @orderno 
		select	@count = @count + 1
		commit transaction -- (1T)
	end -- (1T)

--	7. Otherwise return error code.
else
	return -1

--	8. Return success.
return 0
GO
