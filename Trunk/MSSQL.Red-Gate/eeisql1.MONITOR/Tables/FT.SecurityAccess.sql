CREATE TABLE [FT].[SecurityAccess]
(
[SecurityID] [uniqueidentifier] NOT NULL,
[ResourceID] [uniqueidentifier] NOT NULL,
[Status] [int] NULL CONSTRAINT [DF__SecurityA__Statu__2054D13E] DEFAULT ((0)),
[Type] [int] NULL CONSTRAINT [DF__SecurityAc__Type__2148F577] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [FT].[SecurityAccess] ADD CONSTRAINT [PK__Security__7B6611441E6C88CC] PRIMARY KEY CLUSTERED  ([SecurityID], [ResourceID]) ON [PRIMARY]
GO
