CREATE TABLE [dbo].[edi_buyer]
(
[buyer_id] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[name] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[edi_buyer] ADD CONSTRAINT [PK__edi_buyer__4B7734FF] PRIMARY KEY CLUSTERED  ([buyer_id]) ON [PRIMARY]
GO
