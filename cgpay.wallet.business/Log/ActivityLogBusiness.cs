
using cgpay.wallet.repository.Log;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Log;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.Log
{
  public  class ActivityLogBusiness : IActivityLogBusiness
    {
        IActivityLogRepository _act;
        public ActivityLogBusiness()
        {
            _act = new ActivityLogRepository() ;
        }
        public CommonDbResponse InsertActivityLog(ActivityLog al)
        {
            return _act.InsertActivityLog(al);
        }
        public List<ActivityLog> ActivityLog(string ActionUser, string FromDate, string ToDate, string email = "", string mobilenumber = "")
        {
            return _act.ActivityLog(ActionUser, FromDate, ToDate,email,mobilenumber);
        }
    }
}
