namespace ImportCSM
{
    public enum ProgressStates
    {
        Open,
        CreateTableInsertRows,
        RollCsmForward,
        ImportCsm,
        ImportComplete,
        ImportFailed,
        ImportDeltaCsm,
        ImportDeltaCsmComplete,
        ImportDeltaCsmFailed
    }
}
