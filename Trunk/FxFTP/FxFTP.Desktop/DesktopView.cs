#region Using

using System;
using System.ComponentModel;
using System.Linq;
using System.Threading;
using System.Windows.Forms;
using System.Xml;
using FxFTP.Model;
using WinSCP;
using Timer = System.Windows.Forms.Timer;

#endregion

namespace FxFTP.Desktop
{
    public partial class DesktopView : Form
    {
        private readonly Timer timer = new Timer();

        private DateTime _currentDT;
        private int _filesMissing;
        private int _corruptFiles;


        private string _lro2, _lro3, _lro4, _lro5;
        private DateTime? _lr2, _nr2, _lr3, _nr3, _lr4, _nr4, _lr5, _nr5;

        private readonly BackgroundWorker _bWorker = new BackgroundWorker();

        public DesktopView()
        {
            InitializeComponent();
            timer.Interval = 3000;
            timer.Tick += TimerTick;
            timer.Start();

            UpdateActivityMonitor();
            UpdateOverallStatus();

            _bWorker.DoWork += BWorkerOnDoWork;
            _bWorker.ProgressChanged += BWorkerOnProgressChanged;
            _bWorker.RunWorkerCompleted += BWorkerOnRunWorkerCompleted;
            _bWorker.WorkerReportsProgress = true;
        }

        private void TimerTick(object sender, EventArgs e)
        {
            timer.Stop();
            UpdateOverallStatus();
            _bWorker.RunWorkerAsync();
        }

        private void BWorkerOnDoWork(object sender, DoWorkEventArgs doWorkEventArgs)
        {
            if (_currentDT >= _nr2)
            {
                FTPTasks.TryMonitorArchiveFolder(_bWorker);
            }
            if (_currentDT >= _nr3)
            {
                RetrieveMissingFiles();
            }
            if (_currentDT >= _nr4)
            {
                ReplaceBadFiles();
            }
            if (_currentDT >= _nr5)
            {
                UpdateReceivedDirectoryPoll();
            }
        }

        private void BWorkerOnProgressChanged(object sender, ProgressChangedEventArgs progressChangedEventArgs)
        {
            switch (progressChangedEventArgs.ProgressPercentage)
            {
                case 2:
                    s2.Text = (string)progressChangedEventArgs.UserState;
                    break;
                case 3:
                    s3.Text = (string)progressChangedEventArgs.UserState;
                    break;
                case 4:
                    s4.Text = (string)progressChangedEventArgs.UserState;
                    break;
                case 5:
                    s5.Text = (string)progressChangedEventArgs.UserState;
                    break;
            }
        }

        private void BWorkerOnRunWorkerCompleted(object sender, RunWorkerCompletedEventArgs runWorkerCompletedEventArgs)
        {
            UpdateActivityMonitor();
            timer.Start();
        }

        private void RetrieveMissingFiles()
        {
            FTPTasks.TryRetrieveMissingFiles(_bWorker);
        }

        private void ReplaceBadFiles()
        {
            FTPTasks.TryReplaceBadFiles(_bWorker);
        }

        private void UpdateReceivedDirectoryPoll()
        {
            FTPTasks.TryUpdateReceivedDirectoryPoll(_bWorker);
        }

        private void UpdateOverallStatus()
        {
            var result = OverallStatus.GetOverallStatus();
            _currentDT = (DateTime) result[0];
            _filesMissing = (int) result[1];
            _corruptFiles = (int) result[2];

            ct.Text = _currentDT.ToString("h:mm tt");
            cd.Text = _currentDT.ToString("M/d/yyyy");
        }

        private void UpdateActivityMonitor()
        {
            var result = TaskActivityMonitor.GetTaskActivity();

            _lro2 = (string) result[0];
            _lr2 = (DateTime?) result[1];
            _nr2 = (DateTime?) result[2];

            _lro3 = (string) result[3];
            _lr3 = (DateTime?) result[4];
            _nr3 = (DateTime?) result[5];

            _lro4 = (string) result[6];
            _lr4 = (DateTime?) result[7];
            _nr4 = (DateTime?) result[8];
            
            _lro5 = (string)result[9];
            _lr5 = (DateTime?)result[10];
            _nr5 = (DateTime?)result[11];

            lro2.Text = _lro2;
            s2.Text = "Idle";
            lr2.Text = _lr2 == null ? "Never" : ((DateTime)_lr2).ToString("M/d/yyyy h:mm tt");
            nr2.Text = _nr2 == null ? "On Demand" : ((DateTime)_nr2).ToString("M/d/yyyy h:mm tt");

            lro3.Text = _lro3;
            s3.Text = "Idle";
            lr3.Text = _lr3 == null ? "Never" : ((DateTime)_lr3).ToString("M/d/yyyy h:mm tt");
            nr3.Text = _nr3 == null ? "On Demand" : ((DateTime)_nr3).ToString("M/d/yyyy h:mm tt");

            lro4.Text = _lro4;
            s4.Text = "Idle";
            lr4.Text = _lr4 == null ? "Never" : ((DateTime)_lr4).ToString("M/d/yyyy h:mm tt");
            nr4.Text = _nr4 == null ? "On Demand" : ((DateTime)_nr4).ToString("M/d/yyyy h:mm tt");

            lro5.Text = _lro5;
            s5.Text = "Idle";
            lr5.Text = _lr5 == null ? "Never" : ((DateTime)_lr5).ToString("M/d/yyyy h:mm tt");
            nr5.Text = _nr5 == null ? "On Demand" : ((DateTime)_nr5).ToString("M/d/yyyy h:mm tt");
        }
    }
}