using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.WalletUser;

namespace cgpay.wallet.repository.Client
{
    public interface IWalletUserRepository
    {
        List<ClientCommon> ServiceDetail(string userid = "");
        WalletUserInfo UserInfo(string UserId = "");
        Dictionary<string, string> GetProposeList();
        CommonDbResponse WalletBalanceRT(WalletBalanceCommon walletBalance);
        CommonDbResponse AgentToWallet(WalletBalanceCommon walletBalance);
        CommonDbResponse CheckMobileNumber(string agentid, string mobileno, string usertype, string mode);
        CommonDbResponse CheckProduct(string AgentId, string UserType, string ProductId);
    }
}
