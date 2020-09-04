using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Balance;

namespace cgpay.wallet.repository.Balance
{
    public interface IBalanceRepository
    {
        Dictionary<string, string> GetDistributorName();
        Dictionary<string, string> GetBankList();
        CommonDbResponse DistributorTR(BalanceCommon balanceCommon);
        List<BalanceCommon> GetDistributorReport(string AgentId = "", string BalanceId="");
        List<BalanceCommon> GetAgentName(string AgentId = "");
        CommonDbResponse AgentTR(BalanceCommon balanceCommon);
        List<BalanceCommon> GetAgentReport(string AgentId = "", string BalanceId = "");
        List<BalanceCommon> GetSubAgentName(string AgentId);
    }
}
