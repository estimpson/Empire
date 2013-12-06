using System;
using System.Collections.Generic;
using System.Text;

using Symbol.Barcode;
using Symbol.Audio;
using Symbol.StandardForms;

namespace SymbolRFGun
{
    public class SymbolRFGunException : System.Exception
    {
        public SymbolRFGunException(string Message)
            : base(Message)
        {
        }
    }

    public class RFScanEventArgs : EventArgs
    {
        private readonly string text;

        public RFScanEventArgs(string text)
        {
            this.text = text;
        }

        public string Text
        {
            get { return text; }
        }
    }
    
    public delegate void RFScanEventHandler(object sender, RFScanEventArgs e);

    public class SymbolRFGun
    {
        #region Initializations
        private Reader MyReader = null;
        private ReaderData MyReaderData = null;
        private Symbol.Notification.Beeper MyBeeper = null;
        private System.EventHandler MyEventHandler = null;
        private Symbol.Audio.Controller MyAudioController = null;
        public event RFScanEventHandler RFScan;

        public SymbolRFGun()
        {
            InitializeComponent();
        }

        /// <summary>
        /// Initialize all components.
        /// </summary>
        private void InitializeComponent()
        {
            InitReader();
            InitAudio();
            InitNotifier();
        }

        /// <summary>
        /// Initialize the reader.
        /// </summary>
        private void InitReader()
        {
            //  If reader is already present, fail.
            if (MyReader != null) return;

            MyReader = new Symbol.Barcode.Reader();
            if (MyReader == null)
            {
                throw new SymbolRFGunException("Unable to initialize reader");
            }

            //  Create reader data.
            MyReaderData = new Symbol.Barcode.ReaderData(
                Symbol.Barcode.ReaderDataTypes.Text,
                Symbol.Barcode.ReaderDataLengths.DefaultText);
            if (MyReaderData == null)
            {
                throw new SymbolRFGunException("Unable to initialize reader data");
            }

            //  Create event handler delegate.
            MyEventHandler = new EventHandler(MyReader_ReadNotify);
            if (MyEventHandler == null)
            {
                throw new SymbolRFGunException("Unable to initialize event handler for reader");
            }

            //  Enable reader.
            MyReader.Actions.Enable();
            MyReader.Decoders.CODE39.FullAscii = true; 

            //  Handle success and failure sounds manually.
            MyReader.Parameters.Feedback.Success.BeepTime = 0;

            //  Start reader.
            StartRead();
        }

        /// <summary>
        /// Initialize the reader.
        /// </summary>
        private void InitAudio()
        {
            Symbol.Audio.Device MyAudioDevice = (Symbol.Audio.Device)SelectDevice.Select(
                    Symbol.Audio.Controller.Title,
                    Symbol.Audio.Device.AvailableDevices);

            if (MyAudioDevice == null)
            {
                throw new SymbolRFGunException("Unable to initialize audio device.");
            }

            //check the device type
            switch (MyAudioDevice.AudioType)
            {
                //if standard device
                case Symbol.Audio.AudioType.StandardAudio:
                    MyAudioController = new Symbol.Audio.StandardAudio(MyAudioDevice);
                    break;

                //if simulated device
                case Symbol.Audio.AudioType.SimulatedAudio:
                    MyAudioController = new Symbol.Audio.SimulatedAudio(MyAudioDevice);
                    break;

                default:
                    throw new SymbolRFGunException("Unknown Device Type");
            }
        }

        /// <summary>
        /// Initialize beep notifier.
        /// </summary>
        private void InitNotifier()
        {
            Symbol.Notification.Device device = new Symbol.Notification.Device("Beeper", Symbol.Notification.NotifyType.BEEPER, 2);
            if (device == null)
            {
                throw new SymbolRFGunException("Unable to initialize notifier.");
            }
            MyBeeper = new Symbol.Notification.Beeper(device);
            MyBeeper.Duration = 1000;
            MyBeeper.Frequency = 3000;
            MyBeeper.Volume = 1;
        }
        #endregion
        
        #region Terminations
        public void Close()
        {
            TermComponents();
        }

        /// <summary>
        /// Close all components.
        /// </summary>
        private void TermComponents()
        {
            TermReader();
            TermAudio();
            TermBeeper();
        }

        /// <summary>
        /// Stop reading and disable/close reader.
        /// </summary>
        private void TermReader()
        {
            // If we have a reader
            if (this.MyReader != null)
            {
                // Disable the reader
                this.MyReader.Actions.Disable();

                // Free it up
                this.MyReader.Dispose();

                // Indicate we no longer have one
                this.MyReader = null;
            }

            // If we have a reader data
            if (this.MyReaderData != null)
            {
                // Free it up
                this.MyReaderData.Dispose();

                // Indicate we no longer have one
                this.MyReaderData = null;
            }
        }

        /// <summary>
        /// Close audio controller.
        /// </summary>
        private void TermAudio()
        {
            // If we have audio
            if (MyAudioController != null)
            {
                // Disable the reader
                MyAudioController.Dispose();
            }
        }

        /// <summary>
        /// Close beeper.
        /// </summary>
        private void TermBeeper()
        {
            // If we have a beeper
            if (MyBeeper != null)
            {
                // Disable the reader
                MyBeeper.Dispose();
            }
        }
        #endregion

        #region Scanning
        protected virtual void OnRFScan(RFScanEventArgs e)
        {
            if (RFScan != null)
            {
                RFScan(this, e);
            }
        }

        /// <summary>
        /// Read complete or failure notification.
        /// </summary>
        private void MyReader_ReadNotify(object sender, EventArgs e)
        {
            Symbol.Barcode.ReaderData TheReaderData = this.MyReader.GetNextReaderData();

            // If it is a successful read (as opposed to a failed one)
            if (TheReaderData.Result == Symbol.Results.SUCCESS)
            {
                //  Handle the data from this read.
                RFScanEventArgs eRFScan = new RFScanEventArgs(TheReaderData.Text);
                OnRFScan(eRFScan);

                // Start the next read
                this.StartRead();
            }
        }

        /// <summary>
        /// Start a read on the reader.
        /// </summary>
        public void StartRead()
        {
            // If we have both a reader and a reader data
            if ((this.MyReader != null) &&
                 (this.MyReaderData != null))
            {
                // Submit a read
                this.MyReader.ReadNotify += this.MyEventHandler;
                this.MyReader.Actions.Read(this.MyReaderData);
            }
        }

        /// <summary>
        /// Stop all reads on the reader.
        /// </summary>
        public void StopRead()
        {
            // If we have a reader
            if (this.MyReader != null)
            {
                // Flush (Cancel all pending reads)
                this.MyReader.ReadNotify -= this.MyEventHandler;
                this.MyReader.Actions.Flush();
            }
        }

        /// <summary>
        /// Notify bad read.
        /// </summary>
        public void BadReadNotification()
        {
            if (MyAudioController != null)
            {
                MyAudioController.PlayAudio(1000, 1000, @"\windows\notify.wav");
                //MyAudioController.PlayAudio(1000, 2000);
                //MyAudioController.PlayWaveFile(@"\windows\notify.wav");
            }
        }

        /// <summary>
        /// Notify good read.
        /// </summary>
        public void GoodReadNotification()
        {
            if (MyAudioController != null)
            {
                MyAudioController.PlayWaveFile(@"\windows\decode.wav");
            }
        }

        public void ApproveNotification()
        {
            if (MyAudioController != null)
            {
                MyAudioController.PlayWaveFile(@"\windows\Approve.wav");
            }
        }

        public void FailNotification()
        {
            if (MyAudioController != null)
            {
                MyAudioController.PlayWaveFile(@"\windows\Fail.wav");
            }
        }

        #endregion

        #region Obsolete beep.
        /// <summary>
        /// Beep notification
        /// </summary>
        public void Beep()
        {
            // If we have a beeper.
            if (this.MyBeeper != null)
            {
                MyBeeper.State = Symbol.Notification.NotifyState.CYCLE;
            }
        }
        #endregion
    }
}
