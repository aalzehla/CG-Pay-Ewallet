using cgpay.wallet.repository.DistributorManagement;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.DistributorManagement;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.DistributorManagement
{
    public class DistributorManagementBusiness:IDistributorManagementBusiness
    {
        IDistributorManagementRepository repo;
        public DistributorManagementBusiness(DistributorManagementRepository _repo)
        {
            repo = _repo;
        }
       public List<DistributorManagementCommon> GetDistributorList(string ParentId, string username, string AgentId = "")
        {
            return repo.GetDistributorList(ParentId, username, AgentId);
        }
        public DistributorManagementCommon GetDistributorById(string AgentId, string username)
        {
            return repo.GetDistributorById( AgentId,  username);
        }

        public CommonDbResponse ManageDistributor(DistributorManagementCommon DC)
        {
            return repo.ManageDistributor( DC);
        }
        public CommonDbResponse Disable_EnableDistributor(DistributorManagementCommon DMC)
        {
            return repo.Disable_EnableDistributor(DMC);
        }
        public CommonDbResponse ExtendCreditLimit(DistributorCreditLimitCommon acc)
        {
            return repo.ExtendCreditLimit(acc);
        }
        public List<DistributorManagementCommon> GetUserList(string DistId, string username, string UserId = "")
        {
            return repo.GetUserList(DistId, username, UserId);
        }
        public CommonDbResponse ManageUser(DistributorManagementCommon discomm)
        {
            return repo.ManageUser(discomm);
        }
        public DistributorManagementCommon GetUserById(string DistId, string UserId,string username)
        {
            return repo.GetUserById(DistId, UserId, username);
        }
        public CommonDbResponse Disable_EnableDistributorUser(DistributorManagementCommon DMC)
        {
            return repo.Disable_EnableDistributorUser(DMC);
        }
        public DistributorManagementRolesCommon getDistributorRoleAssigned(string DistId, string UserId, string username)
        {
           return repo.getDistributorRoleAssigned( DistId,  UserId,username);
        }
       public CommonDbResponse AssignDistributorRole(string DistId, string UserId, string RoleId, string IsPrimary)
        {
            return repo.AssignDistributorRole(DistId, UserId, RoleId, IsPrimary);
        }
    }
}
