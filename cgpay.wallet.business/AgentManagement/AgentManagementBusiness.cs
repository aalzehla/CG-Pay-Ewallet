
using cgpay.wallet.repository.AgentManagement;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.AgentManagement;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.AgentManagement
{
    public class AgentManagementBusiness : IAgentManagementBusiness
    {
        IAgentManagementRepository repo;
        public AgentManagementBusiness(AgentManagementRepository _repo)
        {
            repo = _repo;
        }
        public List<AgentManagementCommon> GetAgentList(string AgentId, string username, string parentid = "")
        {
            return repo.GetAgentList(AgentId, username, parentid);
        }
        public CommonDbResponse ManageAgent(AgentManagementCommon AC)
        {
            return repo.ManageAgent(AC);
        }
        public AgentManagementCommon GetAgentById(string AgentId, string username)
        {
            return repo.GetAgentById(AgentId, username);
        }
        //public List<AgentManagementCommon> GetWalletUserList(string DistId, string UserId = "")
        //{
        //    return repo.GetWalletUserList(DistId, UserId);
        //}
        public CommonDbResponse ExtendCreditLimit(AgentCreditLimitCommon acc)
        {
            return repo.ExtendCreditLimit(acc);
        }
        public CommonDbResponse Disable_EnableAgent(AgentManagementCommon amc)
        {
            return repo.Disable_EnableAgent(amc);
        }

        public List<AgentManagementCommon> GetUserList(AgentManagementCommon amc)
        {
            return repo.GetUserList(amc);
        }

        public CommonDbResponse ManageAgentUser(AgentManagementCommon amc)
        {
            return repo.ManageAgentUser(amc);
        }

        public CommonDbResponse Disable_EnableAgentUser(AgentManagementCommon amc)
        {
            return repo.Disable_EnableAgentUser(amc);
        }

        public CommonDbResponse ResetPassword(AgentManagementCommon Common)
        {
            return repo.ResetPassword(Common);
        }
        public CommonDbResponse AssignAgentUserRole(AgentManagementCommon amc)
        {
            return repo.AssignAgentUserRole(amc);
        }

        public AgentManagementCommon getAgentUserRO(AgentManagementCommon amc)
        {
            return repo.getAgentUserRO(amc);
        }
    }
}
