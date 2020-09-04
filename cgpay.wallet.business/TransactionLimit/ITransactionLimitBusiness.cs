using cgpay.wallet.repository.TransactionLimit;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.TransactionLimit;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.TransactionLimit
{
   
    public interface ITransactionLimitBusiness
    {
       List<TransactionLimitCommon> GetTransactionLimitList();
        TransactionLimitCommon GetTransactionLimitById(string Id);
        CommonDbResponse ManageTransactionlimit(TransactionLimitCommon CC);
        TransactionLimitCommon GetTransactionLimitForUser(string AgentId);

    }
}
