using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.TransactionLimit;

namespace cgpay.wallet.repository.TransactionLimit
{
    public interface ITransactionLimitRepository
    {
        List<TransactionLimitCommon> GetTransactionLimitList();

        TransactionLimitCommon GetTransactionLimitById(string Id);

        CommonDbResponse ManageTransactionlimit(TransactionLimitCommon CC);
        TransactionLimitCommon GetTransactionLimitForUser(string AgentId);
    }
}
