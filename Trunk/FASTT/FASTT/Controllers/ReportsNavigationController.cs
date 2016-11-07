using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using FASTT.DataModels;
using FASTT.Model;

namespace FASTT.Controllers
{
    public class ReportsNavigationController
    {
        private MONITOREntities2 _context;

        private NavigationGroupDataModel _navigationGroup;
        public List<NavigationGroupDataModel> NavigationGroupsList = new List<NavigationGroupDataModel>();

        private NavigationItemDataModel _navigationItem;
        public List<NavigationItemDataModel> NavigationItemsList = new List<NavigationItemDataModel>();


        public ReportsNavigationController()
        {
            _context = new MONITOREntities2();
        }


        public void GetNavigationGroups(out string error)
        {
            error = "";
            NavigationGroupsList.Clear();

            try
            {
                foreach (NavigationGroups item in _context.usp_ST_Metrics_GetNavigationGroups())
                {
                    _navigationGroup = new NavigationGroupDataModel
                        {
                            NavigationGroup = item.NavigationGroup
                        };
                    NavigationGroupsList.Add(_navigationGroup);
                }
            }
            catch (Exception ex)
            {
                string msg = "Failed to return menu groups.  Error: ";
                error = (ex.InnerException == null)
                    ? msg + ex.Message
                    : msg + ex.InnerException.Message;
            }
        }

        public void GetNavigationGroupItems(string navGroup, out string error)
        {
            error = "";
            NavigationItemsList.Clear();

            try
            {
                foreach (NavigationItems item in _context.usp_ST_Metrics_GetNavigationGroupItems(navGroup))
                {
                    _navigationItem = new NavigationItemDataModel
                    {
                        NavigationItem = item.NavigationItem
                    };
                    NavigationItemsList.Add(_navigationItem);
                }
            }
            catch (Exception ex)
            {
                string msg = string.Format("Failed to return menu items for group {0}.  Error: ", navGroup);
                error = (ex.InnerException == null)
                    ? msg + ex.Message
                    : msg + ex.InnerException.Message;
            }
        }


    }
}
