using cgpay.wallet.repository.Distributor;
using cgpay.wallet.shared.Models;
using System.Collections.Generic;

namespace cgpay.wallet.business.Distributor
{
    public class DistributorBusiness : IDistributorBusiness
    {
        IDistributorRepository _repo;
        public DistributorBusiness()
        {
            _repo = new DistributorRepository();
        }
        public List<shared.Models.DistributorCommon> GetDistributorList(string AgentId = "")
        {
            return _repo.GetDistributorList(AgentId);
        }
        public shared.Models.DistributorCommon GetDistributorById(string DistId, string username)
        {
            return _repo.GetDistributorById(DistId, username);
        }
        public Dictionary<string, string> Dropdown(string flag, string search1 = "")
        {
            return _repo.Dropdown(flag, search1);
        }
        public CommonDbResponse ManageDistributor(DistributorCommon discomm, string username)
        {
            return _repo.ManageDistributor(discomm, username);
        }
        public List<shared.Models.DistributorCommon> GetUserList(string DistId, string UserId = "")
        {
            return _repo.GetUserList(DistId,UserId);
        }
        public DistributorCommon GetUserById(string DistId, string UserId = "")
        {
            return _repo.GetUserById(DistId, UserId);
        }
        public CommonDbResponse AssignDistributorRole(string DistId, string UserId, string RoleId, string IsPrimary)
        {
            return _repo.AssignDistributorRole(DistId, UserId, RoleId, IsPrimary);
        }
        public CommonDbResponse getDistributorRoleAssigned(string DistId, string UserId)
        {
            return _repo.getDistributorRoleAssigned(DistId, UserId);
        }
        public CommonDbResponse ManageUser(DistributorCommon discomm)
        {
            return _repo.ManageUser(discomm);
        }

        public CommonDbResponse block_unblockuser(string userid, string status, string agentid)
        {
            return _repo.block_unblockuser(userid, status, agentid);
        }
    }
}
