#region Using

using System;
using System.Runtime.InteropServices;
using System.Text;

#endregion

namespace RmaMaintenance.LabelPrinting
{
    public class DocumentPrinter
    {
        [StructLayout(LayoutKind.Sequential)]
        private struct DOCINFOW
        {
            [MarshalAs(UnmanagedType.LPWStr)] public string pDocName;
            [MarshalAs(UnmanagedType.LPWStr)] public readonly string pOutputFile;
            [MarshalAs(UnmanagedType.LPWStr)] public string pDataType;
        }

        [DllImport("winspool.Drv", EntryPoint = "GetDefaultPrinterW",
            SetLastError = true, CharSet = CharSet.Unicode,
            ExactSpelling = true, CallingConvention = CallingConvention.StdCall)]
        private static extern bool GetDefaultPrinter(StringBuilder pszBuffer, ref int size);

        [DllImport("winspool.Drv", EntryPoint = "OpenPrinterW",
            SetLastError = true, CharSet = CharSet.Unicode,
            ExactSpelling = true, CallingConvention = CallingConvention.StdCall)]
        private static extern bool OpenPrinter(string src, ref IntPtr hPrinter, IntPtr pd);

        [DllImport("winspool.Drv", EntryPoint = "ClosePrinter",
            SetLastError = true, CharSet = CharSet.Unicode,
            ExactSpelling = true, CallingConvention = CallingConvention.StdCall)]
        private static extern bool ClosePrinter(IntPtr hPrinter);

        [DllImport("winspool.Drv", EntryPoint = "StartDocPrinterW",
            SetLastError = true, CharSet = CharSet.Unicode,
            ExactSpelling = true, CallingConvention = CallingConvention.StdCall)]
        private static extern bool StartDocPrinter(IntPtr hPrinter, int level, ref DOCINFOW pDI);

        [DllImport("winspool.Drv", EntryPoint = "EndDocPrinter",
            SetLastError = true, CharSet = CharSet.Unicode,
            ExactSpelling = true, CallingConvention = CallingConvention.StdCall)]
        private static extern bool EndDocPrinter(IntPtr hPrinter);

        [DllImport("winspool.Drv", EntryPoint = "StartPagePrinter",
            SetLastError = true, CharSet = CharSet.Unicode,
            ExactSpelling = true, CallingConvention = CallingConvention.StdCall)]
        private static extern bool StartPagePrinter(IntPtr hPrinter);

        [DllImport("winspool.Drv", EntryPoint = "EndPagePrinter",
            SetLastError = true, CharSet = CharSet.Unicode,
            ExactSpelling = true, CallingConvention = CallingConvention.StdCall)]
        private static extern bool EndPagePrinter(IntPtr hPrinter);

        [DllImport("winspool.Drv", EntryPoint = "WritePrinter",
            SetLastError = true, CharSet = CharSet.Unicode,
            ExactSpelling = true, CallingConvention = CallingConvention.StdCall)]
        private static extern bool WritePrinter(IntPtr hPrinter, IntPtr pBytes, int dwCount, ref int dwWRitten);

        [DllImport("kernel32.dll", EntryPoint = "GetLastError",
            SetLastError = true, CharSet = CharSet.Unicode,
            ExactSpelling = true, CallingConvention = CallingConvention.StdCall)]
        private static extern Int32 GetLastError();

        private static bool SendBytesToPrinter(string printerName, IntPtr pBytes, Int32 dwCount)
        {
            var di = new DOCINFOW();
            di.pDocName = "LABEL";
            di.pDataType = "RAW";

            bool bSuccess = false;
            try
            {
                IntPtr hPrinter = IntPtr.Zero;
                if (OpenPrinter(printerName, ref hPrinter, IntPtr.Zero))
                {
                    if (StartDocPrinter(hPrinter, 1, ref di))
                    {
                        if (StartPagePrinter(hPrinter))
                        {
                            Int32 dwWritten = 0;
                            bSuccess = WritePrinter(hPrinter, pBytes, dwCount, ref dwWritten);
                            EndPagePrinter(hPrinter);
                        }
                        EndDocPrinter(hPrinter);
                    }
                    ClosePrinter(hPrinter);
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Print failed.", ex);
            }
            return bSuccess;
        }

        public static bool Print(string printerName, string document)
        {
            IntPtr pBytes = Marshal.StringToCoTaskMemAnsi(document);
            Int32 dwCount = document.Length;
            bool result = SendBytesToPrinter(printerName, pBytes, dwCount);
            Marshal.FreeCoTaskMem(pBytes);
            return result;
        }

        public static bool Print(string document)
        {
            var dp = new StringBuilder(256);
            int size = dp.Capacity;
            if (GetDefaultPrinter(dp, ref size))
            {
                string printerName = dp.ToString().Trim();
                return Print(printerName, document);
            }
            return false;
        }
    }
}