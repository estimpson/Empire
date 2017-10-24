CREATE TABLE [EEIUser].[ELPASO_INV]
(
[location] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pallet_number] [int] NULL,
[parent_serial] [int] NULL,
[child_serial] [int] NOT NULL,
[status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[comments] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qty] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[ELPASO_INV] ADD CONSTRAINT [PK_ELPASO_INV] PRIMARY KEY CLUSTERED  ([child_serial]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
