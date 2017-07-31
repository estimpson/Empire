using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data.EntityClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using QuoteLogData.Models;

namespace QuoteLogTest.Console
{
    class Program
    {
        static void Main(string[] args)
        {
            //ListApplications();
        }

        //static void ListApplications()
        //{
        //    using (var context = new QuoteLogContext())
        //    {
        //        //var queryString = "select value a from QuoteLogContext.GetApplicationCodes() as a where a.ApplicationCode > 'L'";
        //        //var entityConnection = new EntityConnection(System.Configuration.ConfigurationManager.ConnectionStrings["QuoteLogContext"].ToString());
        //        //entityConnection.Open();
        //        //var entityCommand = entityConnection.CreateCommand();
        //        //entityCommand.CommandText = queryString;
        //        //var entityReader = entityCommand.ExecuteReader();
        //        //while (entityReader.Read())
        //        //{
        //        //    System.Console.WriteLine("{0} {1}", entityReader["ApplicationID"], entityReader["ApplicationCode"]);
        //        //}
        //        //System.Console.Write("Press Enter...");
        //        //System.Console.ReadLine();

        //        var applications = from a in context.GetApplicationCodes()
        //                           where a.ApplicationID >= 3
        //                           select a;

        //        foreach (var a in applications)
        //        {
        //            System.Console.WriteLine("{0} {1}", a.ApplicationID, a.ApplicationCode);
        //        }

        //        var quotes = from q in context.QuoteLog
        //                     where q.RowID < 10
        //                     select q;

        //        foreach (var q in quotes)
        //        {
        //            System.Console.WriteLine("{0} {1}", q.QuoteNumber, q.Customer);
        //        }
        //    }
        //    System.Console.Write("Press Enter...");
        //    System.Console.ReadLine();
        //}
    }
}
