using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.SubDistributorManagement;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.SubDistributorManagement
{
    public interface ISubDistributorManagementBusiness
    {
        List<SubDistributorManagementCommon> GetSubDistributorList(string ParentId, string username, string AgentId = "");
        SubDistributorManagementCommon GetSubDistributorById(string AgentId, string username);
        CommonDbResponse ManageSubDistributor(SubDistributorManagementCommon DC);
        CommonDbResponse Disable_EnableSubDistributor(SubDistributorManagementCommon DMC);
        CommonDbResponse ExtendCreditLimit(SubDistributorCreditLimitCommon acc);
        List<SubDistributorManagementCommon> GetUserList(string DistId, string username, string UserId = "");
        CommonDbResponse ManageUser(SubDistributorManagementCommon discomm);
        SubDistributorManagementCommon GetUserById(string DistId, string UserId, string username);
        CommonDbResponse Disable_EnableSubDistributorUser(SubDistributorManagementCommon DMC);
        SubDistributorManagementRolesCommon getSubDistributorRoleAssigned(string DistId, string UserId, string username);
        CommonDbResponse AssignSubDistributorRole(string DistId, string UserId, string RoleId, string IsPrimary);
    }
}
