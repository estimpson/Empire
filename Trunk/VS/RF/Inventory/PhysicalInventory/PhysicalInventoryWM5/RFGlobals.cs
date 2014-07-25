#region Using

using System;
using System.IO;
using System.Threading;
using System.Xml.Serialization;

#endregion

namespace PhysicalInventory
{
    public class RFGlobals
    {
        private const string GLOBALS_FILE = @"RFGlobals.xml";
        public string Plant { get; set; }

        private void PersistState()
        {
            VerifyFileCanOpen();
            using (var fs = new FileStream(GLOBALS_FILE, FileMode.Create))
            {
                var xs = new XmlSerializer(typeof (RFGlobals));
                xs.Serialize(fs, this);
            }
        }

        public static RFGlobals GetInstance()
        {
            RFGlobals thisGlobals;
            try
            {
                VerifyFileCanOpen();
                using (var fs = new FileStream(GLOBALS_FILE, FileMode.Open))
                {
                    var xs = new XmlSerializer(typeof (RFGlobals));
                    thisGlobals = (RFGlobals) xs.Deserialize(fs);
                }
            }
            catch (Exception ex)
            {
                thisGlobals = new RFGlobals();
                thisGlobals.PersistState();

                using (var wtr = new StreamWriter(@"My Device\Temp\debugFXMES.txt", true))
                {
                    wtr.WriteLine("{0} - {1}", DateTime.Now, ex.Message);
                }
            }
            thisGlobals.PersistState();
            return thisGlobals;
        }

        private static void VerifyFileCanOpen()
        {
            var globalFile = new FileInfo(GLOBALS_FILE);
            while (true)
            {
                // Cause the current thread to sleep for 100 miliseconds.
                Thread.Sleep(100);
                try
                {
                    // Try to open the file for reading.
                    globalFile.OpenWrite().Close();
                    // If the file can be opened for reading, then exit the loop and continue execution of the method.
                    break;
                }
// ReSharper disable EmptyGeneralCatchClause
                catch
// ReSharper restore EmptyGeneralCatchClause
                {
                    // If the file cannot be read from yet, then continue looping.
                }
            }
        }
    }
}