using cgpay.wallet.shared.Models;
using System.Collections.Generic;

namespace cgpay.wallet.business.Agent
{
    public interface IAgentBusiness
    {
        List<shared.Models.AgentCommon> GetAgentList(string ParentId = "");
        shared.Models.AgentCommon GetAgentById(string AgentId, string ParentId = "", string username = "");
        Dictionary<string, string> Dropdown(string flag, string search1 = "");
        CommonDbResponse ManageAgent(AgentCommon discomm, string username);
        List<shared.Models.AgentCommon> GetUserList(string AgentId = "");
        CommonDbResponse AssignAgentRole(string AgentId, string UserId, string RoleId, string IsPrimary);
        CommonDbResponse getAgentRoleAssigned(string AgentId, string UserId);
        shared.Models.AgentCommon GetUserById(string AgentId, string UserId = "");
        CommonDbResponse ManageUser(AgentCommon discomm);
        CommonDbResponse block_unblockuser(string userid, string status, string agentid);
    }
}
