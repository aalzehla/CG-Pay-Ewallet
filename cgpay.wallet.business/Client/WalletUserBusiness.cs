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
    public class WalletUserBusiness : IWalletUserBusiness
    {
        IWalletUserRepository _repo;
        public WalletUserBusiness()
        {
            _repo = new WalletUserRepository();
        }
        public List<ClientCommon> ServiceDetail(string userid = "")
        {
            return _repo.ServiceDetail(userid);
        }
        public WalletUserInfo UserInfo(string UserId = "")
        {
            return _repo.UserInfo(UserId);
        }
        public Dictionary<string, string> GetProposeList()
        {
            return _repo.GetProposeList();
        }

        public CommonDbResponse WalletBalanceRT(WalletBalanceCommon walletBalance)
        {
            return _repo.WalletBalanceRT(walletBalance);
        }

        public CommonDbResponse AgentToWallet(WalletBalanceCommon walletBalance)
        {
            return _repo.AgentToWallet(walletBalance);
        }

        public CommonDbResponse CheckMobileNumber(string agentid, string mobileno, string usertype, string mode)
        {
            return _repo.CheckMobileNumber(agentid, mobileno, usertype, mode);
        }

        public CommonDbResponse CheckProduct(string AgentId, string UserType, string ProductId)
        {
            return _repo.CheckProduct(AgentId, UserType, ProductId);
        }
    }
}
