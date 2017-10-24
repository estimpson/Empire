SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_Metrics_GetNavigationGroupItems]
	@NavigationGroup varchar(100)
as
set nocount on
set ansi_warnings off

--- <Body>
declare @navigation table
(
	NavGroup varchar(100)
,	NavItem varchar(100)
,	GroupSequence int
,	ItemSequence int
)
				
if (@NavigationGroup = 'RFQs Quote Engineers') begin
	-- For this particular group, a navigation item needs to be created dynamically for each quote engineer 
	declare @engineers table
	(
		FirstName varchar(50)
	,	Processed int
	)	

	-- Get a list of active quote engineers
	insert into @engineers
	(
		FirstName
	,	Processed
	)
	select
		qei.FirstName
	,	0
	from
		EEIUser.QT_EngineeringInitials qei
	where
		coalesce(qei.FirstName, '') != ''
		and coalesce(qei.LastName, '') != ''
	order by
		qei.FirstName	
	
	-- Create 'RFQs Quote Engineers' navigation items for active quote engineers
	declare 
		@firstName varchar(50)
	,	@sequence int = 1

	while exists(select * from @engineers where Processed = 0)
	begin
		select top 1 @firstName = FirstName from @engineers where Processed = 0

		insert into @navigation
		(
			NavGroup
		,	NavItem
		,	GroupSequence
		,	ItemSequence
		)
		values
		(
			'RFQs Quote Engineers'
		,	@firstName + ' By Month'
		,	1
		,	@sequence
		)

		update @engineers set Processed = 1 where FirstName = @firstName 

		set @sequence = @sequence + 1
	end
end

-- Get all navigation items for this group
insert into @navigation
(
	NavGroup
,	NavItem
,	GroupSequence
,	ItemSequence
)
select 
	ng.NavigationGroup
,	ni.NavigationItem
,	ng.Sequence
,	ni.Sequence
from
	EEIUser.QT_Metrics_NavigationGroups ng
	join EEIUser.QT_Metrics_NavigationItems ni
		on ni.NavigationGroup = ng.NavigationGroup
where
	ng.NavigationGroup = @NavigationGroup
--- </Body>


--- <Return>
select
	NavItem
from
	@navigation
order by
	ItemSequence
--- </Return>
GO
