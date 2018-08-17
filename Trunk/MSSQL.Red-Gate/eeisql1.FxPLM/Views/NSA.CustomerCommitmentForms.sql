SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [NSA].[CustomerCommitmentForms]
as
select
	ccf.FormOfCommitment
,	RowID = isnull(row_number() over (order by ccf.FormOfCommitment), 0)
from
	(	select distinct
			aq.FormOfCommitment
		from
			NSA.AwardedQuotes aq
		union
		select
			'Letter of Intent'
		union
		select
			'Nomination Letter'
		union
		select
			'Sourcing Letter'
		union
		select
			'Award Letter'
	) ccf

GO
