if not exists ( select
                    *
                from
                    dbo.sysindexes
                where
                    id = object_id(N'FT.XRt')
                    and name = N'idx_XRt_1' ) 
    create nonclustered index idx_XRt_1 on FT.XRt 
    (
    BOMLevel asc,
    ChildPart asc,
    ID asc
    )
go
if not exists ( select
                    *
                from
                    dbo.sysindexes
                where
                    id = object_id(N'FT.XRt')
                    and name = N'idx_XRt_2' ) 
    create nonclustered index idx_XRt_2 on FT.XRt 
    (
    TopPart asc,
    BeginOffset asc,
    ID asc
    )
go
if not exists ( select
                    *
                from
                    dbo.sysindexes
                where
                    id = object_id(N'FT.XRt')
                    and name = N'idx_XRt_3' ) 
    create nonclustered index idx_XRt_3 on FT.XRt 
    (
    ChildPart asc,
    BOMLevel asc,
    ID asc
    )
go
if not exists ( select
                    *
                from
                    dbo.sysindexes
                where
                    id = object_id(N'FT.XRt')
                    and name = N'idx_XRt_4' ) 
    create nonclustered index idx_XRt_4 on FT.XRt 
    (
    ChildPart asc,
    TopPart asc,
    ID asc
    )
go
if not exists ( select
                    *
                from
                    dbo.sysindexes
                where
                    id = object_id(N'FT.XRt')
                    and name = N'idx_XRt_5' ) 
    create nonclustered index idx_XRt_5 on FT.XRt 
    (
    TopPart asc,
    ChildPart asc,
    XQty asc,
    ID asc
    )
go