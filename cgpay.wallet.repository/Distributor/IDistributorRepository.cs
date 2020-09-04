using cgpay.wallet.shared.Models;
using System.Collections.Generic;

namespace cgpay.wallet.repository.Distributor
{
    public interface IDistributorRepository
    {
        List<shared.Models.DistributorCommon> GetDistributorList(string AgentId = "");
        shared.Models.DistributorCommon GetDistributorById(string DistId, string username);
        Dictionary<string, string> Dropdown(string flag, string search1 = "");
        CommonDbResponse ManageDistributor(DistributorCommon discomm, string username);
        List<shared.Models.DistributorCommon> GetUserList(string DistId,string UserId="");
        CommonDbResponse AssignDistributorRole(string DistId, string UserId, string RoleId, string IsPrimary);
        CommonDbResponse getDistributorRoleAssigned(string DistId, string UserId);
        shared.Models.DistributorCommon GetUserById(string DistId, string UserId = "");
        CommonDbResponse ManageUser(DistributorCommon discomm);
        CommonDbResponse block_unblockuser(string userid, string status, string agentid);

    }
}
