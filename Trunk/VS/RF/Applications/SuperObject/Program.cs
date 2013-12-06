#region Using

using System;
using Connection;

#endregion

namespace SuperObject
{
    internal static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [MTAThread]
        private static void Main()
        {
            FXRFGlobals.GetRFGlobals();

#if PocketPC
            var myRFGun = new SymbolRFGun.SymbolRFGun();
            FXRFGlobals.MyRFGun = myRFGun;
#endif

#pragma warning disable 168
            var appCon = new SuperObjectController();
#pragma warning restore 168

#if PocketPC
            FXRFGlobals.MyRFGun.StopRead();
            myRFGun.Close();
#endif
        }
    }
}