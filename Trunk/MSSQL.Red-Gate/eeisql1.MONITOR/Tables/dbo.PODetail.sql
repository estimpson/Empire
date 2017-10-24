CREATE TABLE [dbo].[PODetail]
(
[PONumber] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DueDT] [datetime] NOT NULL,
[RowId] [numeric] (20, 6) NOT NULL,
[NewBalance] [numeric] (20, 6) NULL,
[NewReceived] [numeric] (20, 6) NULL,
[LastReceivedAmount] [numeric] (20, 6) NOT NULL,
[LastReceivedDT] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PODetail] ADD CONSTRAINT [PK__PODetail__4D2CD54C] PRIMARY KEY NONCLUSTERED  ([LastReceivedAmount], [PONumber], [Part], [DueDT], [RowId]) ON [PRIMARY]
GO
