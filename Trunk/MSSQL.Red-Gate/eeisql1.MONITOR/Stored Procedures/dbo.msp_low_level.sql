SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[msp_low_level]
(	@part	varchar (25) )
as
---------------------------------------------------------------------------------------
--	This procedure explodes a parts bill of material, calculating the low level
--	and usage of each component.
--
--	Modifications:	?? ??? ????, Eric E. Stimpson	Original.
--			11 OCT 1999, Eric E. Stimpson	Reformatted.
--							Use cursor for performance.
--	
--	Parameters:	@part	optional
--
--	Returns:	  0	success
--			 -1	invalid flow router (infinte loop)
--			100	part has no router
--
--	Process:
--	1.	Declare local variables.
--	2.	Create temporary table for exploding components.
--	3,	Declare trigger for looping through parts at current low level.
--	4.	Initialize stack with part or list of top parts.
--	5.	If rows found, loop through current level, adding children.
--	6.	Add components for each part at current level using cursor.
--	7.	Store level and total usage at this level for components.
--	8.	Continue incrementing level as long as new components are added.
--	9.	Deallocate components cursor.
--	10.	Return result set.
--	11.	Return.
---------------------------------------------------------------------------------------

--	1.	Declare local variables.
declare @current_level int
declare @count int
declare	@childpart varchar (25)

--	2.	Create temporary table for exploding components.
create table #stack 
(
	part	varchar (25),
	stack_level	int,
	quantity numeric (20, 6)
) 

--	3,	Declare trigger for looping through parts at current low level.
declare	childparts cursor for
select	part
from	#stack
where	stack_level = @current_level

--	4.	Initialize stack with part or list of top parts.
select @current_level = 1
if @part =  '' 
	insert into #stack
	select part, @current_level, 1
	from part
	where part not in ( select part from bill_of_material ) 

else

	insert into #stack
	values ( @part, @current_level, 1 )

--	5.	If rows found, loop through current level, adding children.
if @@rowcount > 0 
	select @count = 1
else
	select @count = 0

while @count > 0
begin

--	6.	Add components for each part at current level using cursor.
	select @count = 0

	open childparts

	fetch	childparts
	into	@childpart

	while @@fetch_status = 0
	begin

--	7.	Store level and total usage at this level for components.
		insert	#stack
		select	bom.part,
			@current_level + 1,
			bom.quantity * (
			select	sum ( #stack.quantity )
			from	#stack
			where	#stack.part = @childpart and
				#stack.stack_level = @current_level )
		from	bill_of_material as bom
		where	bom.parent_part = @childpart

		select	@count = 1

		fetch	childparts
		into	@childpart
	end

	close	childparts

--	8.	Continue incrementing level as long as new components are added.
	if @count = 1
		select @current_level = @current_level + 1
end

--	9.	Deallocate components cursor.
deallocate childparts

--	10.	Return result set.
select part, max ( stack_level ), sum ( quantity )
from #stack
group by part
order by max ( stack_level )

--	11.	Return.
if @@rowcount > 0
	return 0
else
	return 100
GO
