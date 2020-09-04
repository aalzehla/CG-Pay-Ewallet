using cgpay.wallet.shared.Models;

using cgpay.wallet.shared.Models.SubAgentManagement;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.SubAgentManagement
{
   public interface ISubAgentManagementRepository
    {
        List<SubAgentManagementCommon> GetSubAgentList(string username, string AgentId, string SubAgentId = "");

        SubAgentManagementCommon GetSubAgentById(string AgentId, string username);
        CommonDbResponse ManageSubAgent(SubAgentManagementCommon AC);
        CommonDbResponse ExtendCreditLimit(SubAgentCreditLimitCommon acc);
        CommonDbResponse Disable_EnableSubAgent(SubAgentManagementCommon amc);
    }
}
