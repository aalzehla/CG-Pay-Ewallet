using cgpay.wallet.shared.Models.Menus;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Library
{
    public class UserMonitor
    {
        private static UserMonitor Instance = new UserMonitor();
        private static readonly Dictionary<string, LoggedInUser> UserList = new Dictionary<string, LoggedInUser>();

        public static UserMonitor GetInstance()
        {
            if (Instance == null)
            {
                lock (UserList)
                {
                    if (Instance == null)
                        return Instance = new UserMonitor();
                }
            }
            return Instance;
        }

        public Dictionary<string, LoggedInUser> GetLoggedInUsers()
        {
            return UserList;
        }

        public bool HasRight(string username, string ControllerName, string Action)
        {
            //return true;
            foreach (
                LoggedInUser loggedInUser in
                UserList.Values.Where(loggedInUser => loggedInUser.UserName == username))
            {
                var returnVal = false;
                returnVal = loggedInUser.Menu.function.ToList().Where(a => a.FunctionId == Action).Count() > 0 ? true : false;
                
                return returnVal;
            }
            return false;
        }
    }
    public class LoggedInUser
    {
        public int UserId { get; set; }
        public string UserName { get; set; }
        public string UserFullName { get; set; }
        public DateTime LoginTime { get; set; }
        public string UserAccessLevel { get; set; }
        public string IPAddress { get; set; }
        public string Browser { get; set; }
        public int SessionTimeOutPeriod { get; set; }
        public string UserAgentName { get; set; }
        public DateTime LastLoginTime { get; set; }
        public DateTime LastActiveTime { get; set; }
        public string SessionID { get; set; }
        public UserMenuFunctions Menu { get; set; }
    }
}