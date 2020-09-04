using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.repository.Balance;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Balance;

namespace cgpay.wallet.business.Balance
{
    public class BalanceBusiness:IBalanceBusiness
    {
        IBalanceRepository _repo;
        public BalanceBusiness()
        {
            _repo = new BalanceRepository();
        }
        public Dictionary<string, string> GetDistributorName()
        {
            return _repo.GetDistributorName();
        }

        public Dictionary<string, string> GetBankList()
        {
            return _repo.GetBankList();
        }

        public CommonDbResponse DistributorTR(BalanceCommon balanceCommon)
        {
            return _repo.DistributorTR(balanceCommon);
        }

        public List<BalanceCommon> GetDistributorReport(string AgentId = "",string BalanceId="")
        {
            return _repo.GetDistributorReport( AgentId,BalanceId );
        }

        public List<BalanceCommon> GetAgentName(string AgentId = "")
        {
            return _repo.GetAgentName(AgentId);
        }

        public CommonDbResponse AgentTR(BalanceCommon balanceCommon)
        {
            return _repo.AgentTR(balanceCommon);
        }

        public List<BalanceCommon> GetAgentReport(string AgentId = "", string BalanceId = "")
        {
            return _repo.GetAgentReport(AgentId,BalanceId);
        }

        public List<BalanceCommon> GetSubAgentName(string AgentId)
        {
            return _repo.GetSubAgentName(AgentId);
        }
    }
}
