using cgpay.wallet.repository.Error;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Errors;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.Log
{
    public class ErrorLogBusiness : IErrorLogBusiness
    {
        IErrorLogRepository _errl;
        public ErrorLogBusiness()
        {
            _errl = new ErrorLogRepository();
        }
        public CommonDbResponse InsertErrors(ErrorsLog el)
        {
            return _errl.InsertErrors(el);
        }
    }
}
