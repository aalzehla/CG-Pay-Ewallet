using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Log;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.Log
{
    public interface IActivityLogRepository
    {
        CommonDbResponse InsertActivityLog(ActivityLog al);
        List<ActivityLog> ActivityLog(string ActionUser, string FromDate, string ToDate, string email = "", string mobilenumber = "");
    }
}
