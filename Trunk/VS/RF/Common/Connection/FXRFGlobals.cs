#region Using

using System;
using System.IO;
using System.Threading;
using System.Xml.Serialization;

#endregion

namespace Connection
{
    public class FXRFGlobals
    {
#if PocketPC
        public static SymbolRFGun.SymbolRFGun MyRFGun = null;
#endif
        private static string _globalsFile = @"FXRFGlobals.xml";

        public static string _eeiConnectionString;

        public string EEIConnectionString
        {
            get { return _eeiConnectionString; }
            set { _eeiConnectionString = value; }
        }

        public static string _eehConnectionString;

        public string EEHConnectionString
        {
            get { return _eehConnectionString; }
            set { _eehConnectionString = value; }
        }

        public FXRFGlobals()
        {
            EEIConnectionString = EEIConnectionString ?? "";
            EEHConnectionString = EEHConnectionString ?? "";
        }

        private void PersistState()
        {
            VerifyFileCanOpen();
            using (var fs = new FileStream(_globalsFile, FileMode.Create))
            {
                var xs = new XmlSerializer(typeof (FXRFGlobals));
                xs.Serialize(fs, this);
            }
        }

        public static FXRFGlobals GetRFGlobals()
        {
            FXRFGlobals thisGlobals;
            try
            {
                VerifyFileCanOpen();
                using (var fs = new FileStream(_globalsFile, FileMode.Open))
                {
                    var xs = new XmlSerializer(typeof (FXRFGlobals));
                    thisGlobals = (FXRFGlobals) xs.Deserialize(fs);
                }
            }
            catch (Exception ex)
            {
                thisGlobals = new FXRFGlobals();
                thisGlobals.PersistState();

                using (var wtr = new StreamWriter(@"\Application Data\debugFXMES.txt", true))
                {
                    wtr.WriteLine("{0} - {1}", DateTime.Now.ToString(), ex.Message);
                }
            }
            thisGlobals.PersistState();
            return thisGlobals;
        }

        private static void VerifyFileCanOpen()
        {
            var globalFile = new FileInfo(_globalsFile);
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
                catch (Exception)
// ReSharper restore EmptyGeneralCatchClause
                {
                    // If the file cannot be read from yet, then continue looping.
                }
            }
        }
    }
}