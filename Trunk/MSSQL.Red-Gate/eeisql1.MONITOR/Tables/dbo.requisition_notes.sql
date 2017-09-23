CREATE TABLE [dbo].[requisition_notes]
(
[code] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[notes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[requisition_notes] ADD CONSTRAINT [PK__requisition_note__6C6E1476] PRIMARY KEY CLUSTERED  ([code]) ON [PRIMARY]
GO
