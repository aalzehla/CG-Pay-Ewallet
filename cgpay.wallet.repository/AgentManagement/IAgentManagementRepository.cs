using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.AgentManagement;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.AgentManagement
{
    public interface IAgentManagementRepository
    {
        List<AgentManagementCommon> GetAgentList(string AgentId, string username, string parentid = "");
        CommonDbResponse ManageAgent(AgentManagementCommon AC);
        AgentManagementCommon GetAgentById(string AgentId, string username);
        //List<AgentManagementCommon> GetWalletUserList(string DistId, string UserId = "");
        CommonDbResponse ExtendCreditLimit(AgentCreditLimitCommon acc);
        CommonDbResponse Disable_EnableAgent(AgentManagementCommon amc);
        List<AgentManagementCommon> GetUserList(AgentManagementCommon amc);
        CommonDbResponse ManageAgentUser(AgentManagementCommon amc);
        CommonDbResponse Disable_EnableAgentUser(AgentManagementCommon amc);
        CommonDbResponse ResetPassword(AgentManagementCommon Common);
        CommonDbResponse AssignAgentUserRole(AgentManagementCommon amc);
        AgentManagementCommon getAgentUserRO(AgentManagementCommon amc);


    }
}
