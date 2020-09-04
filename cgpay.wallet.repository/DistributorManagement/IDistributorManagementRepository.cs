using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.DistributorManagement;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.DistributorManagement
{
    public interface IDistributorManagementRepository
    {
        List<DistributorManagementCommon> GetDistributorList(string ParentId, string username, string AgentId = "");
        DistributorManagementCommon GetDistributorById(string AgentId, string username);
        CommonDbResponse ManageDistributor(DistributorManagementCommon DC);
        CommonDbResponse Disable_EnableDistributor(DistributorManagementCommon DMC);
        CommonDbResponse ExtendCreditLimit(DistributorCreditLimitCommon acc);
        List<DistributorManagementCommon> GetUserList(string DistId, string username, string UserId = "");
        CommonDbResponse ManageUser(DistributorManagementCommon discomm);
        DistributorManagementCommon GetUserById(string DistId, string UserId,string username);
        CommonDbResponse Disable_EnableDistributorUser(DistributorManagementCommon DMC);
        DistributorManagementRolesCommon getDistributorRoleAssigned(string DistId, string UserId, string username);
       CommonDbResponse AssignDistributorRole(string DistId, string UserId, string RoleId, string IsPrimary);
    }
}
