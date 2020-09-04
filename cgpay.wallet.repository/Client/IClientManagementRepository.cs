using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.WalletUser;

namespace cgpay.wallet.repository.Client
{
    public interface IClientManagementRepository
    {
        List<WalletUserInfo> WalletUserList(string agentType = "", string agentId = "", string ParentId = "");
        CommonDbResponse UserStatusChange(string userId, string agentId, string status = "");
        CommonDbResponse AddUser(WalletUserInfo walletUser);
        CommonDbResponse InsertBalance(WalletUserInfo walletUser);
        CommonDbResponse ResetPassword(WalletUserInfo walletUser);
    }
}
