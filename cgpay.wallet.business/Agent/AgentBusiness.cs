using cgpay.wallet.repository.Agent;
using cgpay.wallet.shared.Models;
using System.Collections.Generic;

namespace cgpay.wallet.business.Agent
{
    public class AgentBusiness : IAgentBusiness
    {
        IAgentRepository _repo;
        public AgentBusiness()
        {
            _repo = new AgentRepository();
        }

        //List<shared.Models.AgentCommon> GetAgentList(string ParentId = "");
        //shared.Models.AgentCommon GetAgentById(string AgentId, string ParentId = "", string username = "");
        //Dictionary<string, string> Dropdown(string flag, string search1 = "");
        //CommonDbResponse ManageAgent(AgentCommon discomm, string username);
        //List<shared.Models.AgentCommon> GetUserList(string AgentId = "");
        //CommonDbResponse AssignAgentRole(string AgentId, string UserId, string RoleId, string IsPrimary);
        //CommonDbResponse getAgentRoleAssigned(string AgentId, string UserId);
        //shared.Models.AgentCommon GetUserById(string AgentId, string UserId = "");
        //CommonDbResponse ManageUser(AgentCommon discomm);
        //CommonDbResponse block_unblockuser(string userid, string status, string agentid);
        public List<shared.Models.AgentCommon> GetAgentList(string ParentId = "")
        {
            return _repo.GetAgentList(ParentId);
        }
        public shared.Models.AgentCommon GetAgentById(string AgentId, string ParentId = "", string username = "")
        {
            return _repo.GetAgentById(AgentId,ParentId, username);
        }
        public Dictionary<string, string> Dropdown(string flag, string search1 = "")
        {
            return _repo.Dropdown(flag, search1);
        }
        public CommonDbResponse ManageAgent(AgentCommon discomm, string username)
        {
            return _repo.ManageAgent(discomm, username);
        }
        public List<shared.Models.AgentCommon> GetUserList(string AgentId)
        {
            return _repo.GetUserList(AgentId);
        }
        public AgentCommon GetUserById(string AgentId, string UserId = "")
        {
            return _repo.GetUserById(AgentId, UserId);
        }
        public CommonDbResponse AssignAgentRole(string AgentId, string UserId, string RoleId, string IsPrimary)
        {
            return _repo.AssignAgentRole(AgentId, UserId, RoleId, IsPrimary);
        }
        public CommonDbResponse getAgentRoleAssigned(string AgentId, string UserId)
        {
            return _repo.getAgentRoleAssigned(AgentId, UserId);
        }
        public CommonDbResponse ManageUser(AgentCommon discomm)
        {
            return _repo.ManageUser(discomm);
        }

        public CommonDbResponse block_unblockuser(string userid, string status, string agentid)
        {
            return _repo.block_unblockuser(userid, status, agentid);
        }
    }
}
