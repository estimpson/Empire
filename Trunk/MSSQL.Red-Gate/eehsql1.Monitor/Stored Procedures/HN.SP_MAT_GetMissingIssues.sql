SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [HN].[SP_MAT_GetMissingIssues](
		@FromDT datetime,
		@ToDT datetime,
		@Group as varchar(25) ) as
create table #BFH 
	(	BFID int,
		SerialProduced int,
		TranDT datetime,
		PartProduce varchar(25),
		ChildPart varchar(25),
		BOMQty numeric(20,3),
		Type varchar(1) )

insert into #BFH( BFID, SerialProduced, TranDT, PartProduce, ChildPart, BOMQty, Type )
select	BFID = BFH.ID, SerialProduced, TranDT, PartProduced, ChildPart, bomQty = SUM(QtyProduced*xQty), MAX(part.type)
from	BackFlushHeaders BFH
		join ft.xrt xrt on xrt.TopPart = BFH.PartProduced
		join WOs on WOs.ID = BFH.WODID
		join part on part.part = xrt.ChildPart
		join location on location.code = WOs.Machine
where	group_no like @Group
		and BFH.TranDT >= @FromDT
		and BFH.TranDT <= @ToDT
group by BFH.ID,SerialProduced, TranDT, PartProduced, ChildPart
				
			
create table #BFD 
	(	BFID int,
		ChildPart varchar(25),
		BFIQty numeric(20,6) )

insert into #BFD(BFID, ChildPart, BFIQty)
select	BFID, ChildPart=PartConsumed, BFIQty = SUM( isnull(BFD.QtyIssue,0) + ISNULL(bfd.QtyOverage,0))
from	BackFlushDetails BFD
		join BackFlushHeaders BFH on BFD.BFID = BFH.ID
		join WOs on WOs.ID = BFH.WODID
		join location on location.code = WOs.Machine
where	group_no like @Group
		and BFH.TranDT > @FromDT
		and BFH.TranDT <= @ToDT
group by BFID, PartConsumed


select	SerialProduced, PartProduce, TranDT,
		Header.ChildPart, bomQty,BFIQty
from	#BFH Header
		left join #BFD Detail on Detail.ChildPart = Header.ChildPart and Detail.BFID = Header.BFID
where	BFIQty is null
		and Type = 'R'
		
GO
