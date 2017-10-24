
if not exists ( select
                    *
                from
                    dbo.sysindexes
                where
                    id = object_id(N'dbo.BackFlushDetails')
                    and name = N'idx_BackflushDetails_1' ) 
    create nonclustered index idx_BackflushDetails_1 on dbo.BackFlushDetails 
    (
    BFID asc,
    PartConsumed asc,
    QtyIssue asc,
    ID asc
    ) 
GO
if not exists ( select
                    *
                from
                    dbo.sysindexes
                where
                    id = object_id(N'dbo.BackFlushDetails')
                    and name = N'idx_BackflushDetails_2' ) 
    create nonclustered index idx_BackflushDetails_2 on dbo.BackFlushDetails 
    (
    SerialConsumed asc,
    QtyIssue asc,
    BFID asc
    ) 
GO
