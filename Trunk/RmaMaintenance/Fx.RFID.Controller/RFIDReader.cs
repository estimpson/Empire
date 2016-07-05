#region Using

using System;
using System.Text;
using System.Windows.Forms;

#endregion

namespace Fx.RFID.Controller
{
// ReSharper disable once InconsistentNaming
    public static class RFIDReader
    {
        public class RFIDReaderReadArgs : EventArgs
        {
            public readonly string ReaderData;

            public RFIDReaderReadArgs(string readerData)
            {
                ReaderData = readerData;
            }
        }

        private static bool _readingStarted;
        private static StringBuilder _value;

        public static void ViewOnKeyPress(object sender, KeyPressEventArgs e)
        {
            switch (e.KeyChar)
            {
                case '`':
                    _readingStarted = true;
                    _value = new StringBuilder();
                    e.Handled = true;
                    return;
                case '~':
                    _readingStarted = false;
                    OnRFIDRead();
                    e.Handled = true;
                    return;
                default:
                    e.Handled = _readingStarted;
                    if (_readingStarted)
                    {
                        _value.Append(e.KeyChar);
                    }
                    return;
            }
        }

        private static void OnRFIDRead()
        {
            var handler = RFIDRead;
            if (handler != null && _value != null)
            {
                handler(Application.ExecutablePath, new RFIDReaderReadArgs(_value.ToString()));
            }
        }

        public static event EventHandler<RFIDReaderReadArgs> RFIDRead;
    }
}