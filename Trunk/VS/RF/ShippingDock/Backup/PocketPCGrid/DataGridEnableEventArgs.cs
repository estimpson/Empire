using System;
using System.Collections.Generic;
using System.Text;

namespace PocketPCGrid
{
    public class DataGridEnableEventArgs : EventArgs
    {
        private int _column;
        private int _row;
        private bool _meetsCriteria;

        public DataGridEnableEventArgs(int row, int col, bool val)
        {
            _row = row;
            _column = col;
            _meetsCriteria = val;
        }

        public int Column
        {
            get { return _column; }
            set { _column = value; }
        }

        public int Row
        {
            get { return _row; }
            set { _row = value; }
        }

        public bool MeetsCriteria
        {
            get { return _meetsCriteria; }
            set { _meetsCriteria = value; }
        }
    }
}
