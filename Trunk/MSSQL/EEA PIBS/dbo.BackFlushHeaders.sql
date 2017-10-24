
if not exists ( select
                    *
                from
                    dbo.sysindexes
                where
                    id = object_id(N'dbo.BackFlushHeaders')
                    and name = N'idx_BackFlushHeaders_1' ) 
    create nonclustered index idx_BackFlushHeaders_1 on dbo.BackFlushHeaders 
    (
    SerialProduced asc,
    QtyProduced asc,
    ID asc
    )
go
if not exists ( select
                    *
                from
                    dbo.sysindexes
                where
                    id = object_id(N'dbo.BackFlushHeaders')
                    and name = N'idx_BackFlushHeaders_2' ) 
    create nonclustered index idx_BackFlushHeaders_2 on dbo.BackFlushHeaders 
    (
    TranDT asc,
    SerialProduced asc,
    ID asc,
    QtyProduced asc
    )
go
if not exists ( select
                    *
                from
                    dbo.sysindexes
                where
                    id = object_id(N'dbo.BackFlushHeaders')
                    and name = N'idx_BackFlushHeaders_3' ) 
    create nonclustered index idx_BackFlushHeaders_3 on dbo.BackFlushHeaders 
    (
    TranDT asc,
    ID asc
    )
go
if not exists ( select
                    *
                from
                    dbo.sysindexes
                where
                    id = object_id(N'dbo.BackFlushHeaders')
                    and name = N'IX_BackFlushHeaders' ) 
    create nonclustered index IX_BackFlushHeaders on dbo.BackFlushHeaders 
    (
    SerialProduced asc,
    ID asc
    )
go
