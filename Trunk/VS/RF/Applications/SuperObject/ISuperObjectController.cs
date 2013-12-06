using System;

namespace SuperObject
{

    public delegate void SuccessfulLogin(object sender, LogInArgs args);

    public delegate void FailedLogin(object sender, EventArgs args);

    public class LogInArgs : EventArgs
    {
        public string OperatorCode;
        public string OperatorName;
    }

    public interface ISuperObjectController
    {
        //  Methods:
        void Close();
        void Login(string text);
        void Logoff();

        event SuccessfulLogin SuccessfulLogin;
        event FailedLogin FailedLogin;
    }
}