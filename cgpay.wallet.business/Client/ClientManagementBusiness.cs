using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.repository.Client;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.WalletUser;

namespace cgpay.wallet.business.Client
{
    public class ClientManagementBusiness : IClientManagementBusiness
    {
        IClientManagementRepository _repo;
        public ClientManagementBusiness()
        {
            _repo = new ClientManagementRepository();
        }

        public List<WalletUserInfo> WalletUserList(string agentType = "", string agentId = "", string ParentId = "")
        {
            return _repo. WalletUserList(agentType ,  agentId,  ParentId);
        }

        public CommonDbResponse UserStatusChange(string userId, string agentId, string status = "")
        {
            return _repo.UserStatusChange(userId,agentId, status);
        }

        public CommonDbResponse AddUser(WalletUserInfo walletUser)
        {
            return _repo.AddUser(walletUser);
        }

        public CommonDbResponse InsertBalance(WalletUserInfo walletUser)
        {
            return _repo.InsertBalance(walletUser);
        }

        public CommonDbResponse ResetPassword(WalletUserInfo walletUser)
        {
            return _repo.ResetPassword(walletUser);
        }
    }
}
