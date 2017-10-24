using System;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Xml;
using FxFTP.Desktop.Properties;
using FxFTP.Model;
using WinSCP;

namespace FxFTP.Desktop
{
    public static class FTPTasks
    {
        // Setup session options
        private static readonly SessionOptions SessionOptions = new SessionOptions
        {
            Protocol = Protocol.Ftp,
            HostName = Settings.Default.HostName,
            UserName = Settings.Default.UserName,
            Password = Settings.Default.Password,
        };

        public static void TryReplaceBadFiles(BackgroundWorker bWorker)
        {
            try
            {
                bWorker.ReportProgress(4, "Starting");
                var badFiles = FxFTP.Model.Files.TryGetBadFiles();
                if (badFiles.Count <= 0) return;

                //  FTP download.
                using (var session = new Session())
                {
                    // Connect
                    bWorker.ReportProgress(4, "Connecting...");
                    session.Open(SessionOptions);
                    bWorker.ReportProgress(4, "Connected");

                    // Download files
                    foreach (var badFile in badFiles)
                    {
                        if (
                            session.FileExists(Settings.Default.iExchangeWebArchiveFolder + '/' +
                                               badFile.SourceFileName))
                        {
                            var transferOptions = new TransferOptions();
                            transferOptions.TransferMode = TransferMode.Automatic;

                            bWorker.ReportProgress(4, string.Format("Get {0}", badFile.SourceFileName));
                            var transferResult =
                                session.GetFiles(
                                    Settings.Default.iExchangeWebArchiveFolder + '/' + badFile.SourceFileName,
                                    Settings.Default.DownloadTempFolder, false, transferOptions);

                            //  Throw on any error
                            try
                            {
                                transferResult.Check();
                            }
                            catch (Exception)
                            {
                                continue;
                            }

                            //  Remove bad file.
                            Files.RemoveBadFile(badFile.RowID);

                            //  Move new file to file table.
                            bWorker.ReportProgress(4, string.Format("Moving {0}", badFile.SourceFileName));
                            File.Move(Path.Combine(Settings.Default.DownloadTempFolder, badFile.SourceFileName), Path.Combine(Settings.Default.CustomerEDIFileTablePath, badFile.SourceFileName));

                            //  Update bad file.
                            bWorker.ReportProgress(4, "Update Missing File Log");
                            Files.UpdateReceiveFileLogForReplacedBadFile(badFile.RowID);
                        }
                        else
                        {
                            //  Update unavailable file.
                            bWorker.ReportProgress(4, "Update Unavailable File Log");
                            Files.UpdateReceiveFileLogForUnavailableFile(badFile.RowID);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                bWorker.ReportProgress(4, "Error");
            }
        }

        public static void TryRetrieveMissingFiles(BackgroundWorker bWorker)
        {
            try
            {
                bWorker.ReportProgress(3, "Starting");
                var missingFiles = FxFTP.Model.Files.TryGetMissingFiles();
                if (missingFiles.Count <= 0) return;

                //  FTP download.
                using (var session = new Session())
                {
                    // Connect
                    bWorker.ReportProgress(3, "Connecting...");
                    session.Open(SessionOptions);
                    bWorker.ReportProgress(3, "Connected");

                    // Download files
                    foreach (var missingFile in missingFiles)
                    {
                        if (
                            session.FileExists(Settings.Default.iExchangeWebArchiveFolder + '/' +
                                               missingFile.SourceFileName))
                        {
                            var transferOptions = new TransferOptions();
                            transferOptions.TransferMode = TransferMode.Automatic;

                            bWorker.ReportProgress(3, string.Format("Get {0}", missingFile.SourceFileName));
                            var transferResult =
                                session.GetFiles(
                                    Settings.Default.iExchangeWebArchiveFolder + '/' + missingFile.SourceFileName,
                                    Settings.Default.DownloadTempFolder, false, transferOptions);

                            //  Throw on any error
                            try
                            {
                                transferResult.Check();
                            }
                            catch (Exception)
                            {
                                continue;
                            }

                            //  Move this file to file table.
                            bWorker.ReportProgress(3, string.Format("Moving {0}", missingFile.SourceFileName));
                            File.Move(Path.Combine(Settings.Default.DownloadTempFolder, missingFile.SourceFileName), Path.Combine(Settings.Default.CustomerEDIFileTablePath, missingFile.SourceFileName));

                            //  Update missing file.
                            bWorker.ReportProgress(3, "Update Missing File Log");
                            Files.UpdateReceiveFileLogForMissingFile(missingFile.RowID);
                        }
                        else
                        {
                            //  Update unavailable file.
                            bWorker.ReportProgress(3, "Update Unavailable File Log");
                            Files.UpdateReceiveFileLogForUnavailableFile(missingFile.RowID);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                bWorker.ReportProgress(3, "Error");
            }
        }

        public static void TryMonitorArchiveFolder(BackgroundWorker bWorker)
        {
            try
            {
                bWorker.ReportProgress(2, "Starting");
                var range = ReceivedDirectoryPoll.GetPendingDateRange();
                var rcvdDir = new XmlDocument();
                using (var session = new Session())
                {
                    // Connect
                    bWorker.ReportProgress(2, "Connecting...");
                    session.Open(SessionOptions);
                    bWorker.ReportProgress(2, "Connected");

                    //  FTP Directory.
                    var directory = session.ListDirectory(Settings.Default.iExchangeWebArchiveFolder);
                    bWorker.ReportProgress(2, "Dir. Received");

                    //  XML
                    var root = rcvdDir.CreateElement("Root");
                    var localDT = rcvdDir.CreateAttribute("LocalDT");
                    localDT.Value = DateTime.Now.ToString();
                    root.Attributes.Append(localDT);
                    rcvdDir.AppendChild(root);

                    var rangeElement = rcvdDir.CreateElement("Range");
                    var fromDT = rcvdDir.CreateAttribute("FromDT");
                    fromDT.Value = range[0].ToString();
                    var toDT = rcvdDir.CreateAttribute("ToDT");
                    toDT.Value = range[1].ToString();
                    rangeElement.Attributes.Append(fromDT);
                    rangeElement.Attributes.Append(toDT);
                    root.AppendChild(rangeElement);

                    foreach (
                        var fileInfo in
                            directory.Files.Where(
                                fi => !fi.IsDirectory && fi.LastWriteTime > range[0] && fi.LastWriteTime <= range[1]))
                    {
                        var file = rcvdDir.CreateElement("File");
                        var fileName = rcvdDir.CreateAttribute("FileName");
                        fileName.Value = fileInfo.Name;
                        file.Attributes.Append(fileName);

                        var sourceFileDT = rcvdDir.CreateAttribute("SourceFileDT");
                        sourceFileDT.Value = fileInfo.LastWriteTime.ToString();
                        file.Attributes.Append(sourceFileDT);

                        var sourceFileLen = rcvdDir.CreateAttribute("SourceFileLen");
                        sourceFileLen.Value = fileInfo.Length.ToString();
                        file.Attributes.Append(sourceFileLen);

                        var sourceCRC32 = rcvdDir.CreateAttribute("SourceCRC32");

                        try
                        {
                            sourceCRC32.Value =
                                BitConverter.ToString(session.CalculateFileChecksum("crc32", fileInfo.FullName))
                                    .Replace("-", "")
                                    .ToUpper();
                        }
                        catch (Exception ex)
                        {
                            sourceCRC32.Value = ex.Message.Split('-')[1].Trim().ToUpper();
                        }
                        bWorker.ReportProgress(2, "Checksum Retrieved");
                        file.Attributes.Append(sourceCRC32);

                        root.AppendChild(file);
                    }
                }
                bWorker.ReportProgress(2, "Updating Logs");
                ReceivedDirectoryPoll.RecordReceiveFileLog(rcvdDir.InnerXml);
                bWorker.ReportProgress(2, "Logs Updated");
            }
            catch (Exception ex)
            {
                bWorker.ReportProgress(2, "Error");
            }
        }

        public static void TryUpdateReceivedDirectoryPoll(BackgroundWorker bWorker)
        {
            try
            {
                bWorker.ReportProgress(5, "Starting");
                ReceivedDirectoryPoll.UpdateReceivedDirectoryPoll();
                bWorker.ReportProgress(5, "Directory Poll Updated");
            }
            catch (Exception ex)
            {
                bWorker.ReportProgress(5, "Error");
            }
        }
    }
}