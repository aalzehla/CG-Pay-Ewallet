using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.shared.Models.Log;

namespace cgpay.wallet.repository.Log
{
    public interface IAccessLogRepository
    {
        List<AccessLogCommon> GetAccessLogList(string from , string to);      

    }
}
