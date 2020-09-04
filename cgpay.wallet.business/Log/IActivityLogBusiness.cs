using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Log;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.Log
{
    public interface IActivityLogBusiness
    {
        CommonDbResponse InsertActivityLog(ActivityLog al);
        List<ActivityLog> ActivityLog(string ActionUser, string FromDate, string ToDate, string email = "", string mobilenumber = "");
    }
}
