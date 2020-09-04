using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.LoadBalance;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.LoadBalance
{
    public interface ILoadBalanceRepositroy
    {
        CommonDbResponse LoadBalance(LoadBalanceCommon balance);
        CommonDbResponse CheckTrnasactionExistence(string MerchantTxnId, string GatewayTxnId);

        CommonDbResponse UpdateTransaction(LoadBalanceCommon balance);

        CommonDbResponse GetTransactionReposne(string MerchantTxnId, string GatewayTxnId);

        CommonDbResponse GetTransactionLimit(string AgentId);
    }
}
