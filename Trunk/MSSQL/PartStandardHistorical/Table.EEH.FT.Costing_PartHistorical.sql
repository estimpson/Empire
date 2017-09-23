
/*
drop table
	FT.Costing_PartHistorical
*/


create table
	FT.Costing_PartHistorical
(	Part varchar(25) not null
,	BeginDT datetime not null
,	EndDT datetime null
,	Name varchar(100) not null
,	CrossRef varchar(50) null
,	PartClass char(1) null
,	PartType char(1) null
,	Commodity varchar(30) null
,	GroupTechnology varchar(30) null
,	ProductLine varchar(30) null
,	BinCheckSum int
,	LastSnapshotRowID int
,	primary key
		(	Part
		,	BeginDT
		)
)

CREATE NONCLUSTERED INDEX [ix_Costing_PartHistorical_1] ON [FT].[Costing_PartHistorical] ([Part], [EndDT], [BinCheckSum]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_Costing_PartHistorical_2] ON [FT].[Costing_PartHistorical] ([BeginDT], [EndDT], [Part]) INCLUDE (PartClass, PartType, ProductLine) ON [PRIMARY]
GO
