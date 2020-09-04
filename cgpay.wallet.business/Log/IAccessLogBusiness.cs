using cgpay.wallet.shared.Models.Log;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.Log
{
    public interface IAccessLogBusiness
    {
        List<AccessLogCommon> GetAccessLogList(string from, string to);
    }
}
