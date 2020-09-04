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
    public class ApiLogBusiness : IApiLogBusiness
    {
        IApiLogRepository _api;
        public ApiLogBusiness()
        {
            _api = new ApiLogRepository();
        }
        public List<ApiLogCommon> GetApiLogList(string api_log_id = "", string fromDate = "", string toDate = "", string txnId = "", string userName = "")
        {
            return _api.GetApiLogList(api_log_id, fromDate, toDate, txnId, userName);
        }

        public CommonDbResponse InsertApiLog(ApiLogCommon apiLog)
        {
            return _api.InsertApiLog(apiLog);
        }

        public CommonDbResponse UpdateApiLog(ApiLogCommon apiLog)
        {
            return _api.UpdateApiLog(apiLog);
        }
    }
}
