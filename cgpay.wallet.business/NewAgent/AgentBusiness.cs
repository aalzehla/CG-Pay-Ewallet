using cgpay.wallet.repository.NewAgent;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.SubDistributor;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.NewAgent
{
   public class AgentBusiness:IAgentBusiness
    {
        IAgentRepository repo;
        public AgentBusiness(AgentRepository _repo)
        {
            repo = _repo;
        }
        public List<AgentNewCommon> GetAgentList(string AgentId, string username, string parentid = "")
        {
            return repo.GetAgentList(AgentId, username, parentid);
        }
        public CommonDbResponse ManageAgent(AgentNewCommon AC)
        {
            return repo.ManageAgent(AC);
        }
        public AgentNewCommon GetAgentById(string AgentId, string username)
        {
            return repo.GetAgentById(AgentId, username);
        }
        public List<AgentNewCommon> GetWalletUserList(string DistId, string UserId = "")
        {
            return repo.GetWalletUserList(DistId, UserId);
                }
    }
}
