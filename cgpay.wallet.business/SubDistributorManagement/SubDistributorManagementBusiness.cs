using cgpay.wallet.repository.SubDistributorManagement;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.SubDistributorManagement;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.SubDistributorManagement
{
    public class SubDistributorManagementBusiness:ISubDistributorManagementBusiness
    {
        ISubDistributorManagementRepository repo;
        public SubDistributorManagementBusiness(SubDistributorManagementRepository _repo)
        {
            repo = _repo;
        }
         public List<SubDistributorManagementCommon> GetSubDistributorList(string ParentId, string username, string AgentId = "")
        {
            return repo.GetSubDistributorList(ParentId, username, AgentId);
        }
        public SubDistributorManagementCommon GetSubDistributorById(string AgentId, string username)
        {
            return repo.GetSubDistributorById( AgentId,  username);
        }

        public CommonDbResponse ManageSubDistributor(SubDistributorManagementCommon DC)
        {
            return repo.ManageSubDistributor( DC);
        }
        public CommonDbResponse Disable_EnableSubDistributor(SubDistributorManagementCommon DMC)
        {
            return repo.Disable_EnableSubDistributor(DMC);
        }
        public CommonDbResponse ExtendCreditLimit(SubDistributorCreditLimitCommon acc)
        {
            return repo.ExtendCreditLimit(acc);
        }
        public List<SubDistributorManagementCommon> GetUserList(string DistId, string username, string UserId = "")
        {
            return repo.GetUserList(DistId, username, UserId);
        }
        public CommonDbResponse ManageUser(SubDistributorManagementCommon discomm)
        {
            return repo.ManageUser(discomm);
        }
        public SubDistributorManagementCommon GetUserById(string DistId, string UserId,string username)
        {
            return repo.GetUserById(DistId, UserId,username);
        }
        public CommonDbResponse Disable_EnableSubDistributorUser(SubDistributorManagementCommon DMC)
        {
            return repo.Disable_EnableSubDistributorUser(DMC);
        }
        public SubDistributorManagementRolesCommon getSubDistributorRoleAssigned(string DistId, string UserId, string username)
        {
           return repo.getSubDistributorRoleAssigned( DistId,  UserId,username);
        }
       public CommonDbResponse AssignSubDistributorRole(string DistId, string UserId, string RoleId, string IsPrimary)
        {
            return repo.AssignSubDistributorRole(DistId, UserId, RoleId, IsPrimary);
        }
    }
}
