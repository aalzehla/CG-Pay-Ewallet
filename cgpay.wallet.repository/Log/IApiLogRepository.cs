using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Log;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.Log
{
    public interface IApiLogRepository
    {
        List<ApiLogCommon> GetApiLogList(string api_log_id = "", string fromDate = "", string toDate = "", string txnId = "", string userName = "");

        CommonDbResponse InsertApiLog(ApiLogCommon apiLog);
        CommonDbResponse UpdateApiLog(ApiLogCommon apiLog);
    }
}
