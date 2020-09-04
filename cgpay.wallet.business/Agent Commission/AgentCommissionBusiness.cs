using cgpay.wallet.repository.AgentCommission;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Commission;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.Agent_Commission
{
    public class AgentCommissionBusiness : IAgentCommissionBusiness
    {
        IAgentCommissionRepository _repo;
        public AgentCommissionBusiness()
        {
            _repo = new AgentCommissionRepository();
        }

        public CommonDbResponse block_unblockCategory(CommissionCategoryCommon ccc, string status)
        {
            return _repo.block_unblockCategory(ccc,status);

        }

        public AssignCommissionCommon GetAdminCommCatagory(string id)
        {
            return _repo.GetAdminCommCatagory(id);
        }

        public CommissionCategoryDetailCommon GetAdminCommvalue(string catId, string productId)
        {
            return _repo.GetAdminCommvalue(catId, productId);

        }

        public CommissionCategoryCommon GetAgentCommissionCategoryById(string Id)
        {
            return _repo.GetAgentCommissionCategoryById(Id);
        }

        public List<CommissionCategoryCommon> GetAgentCommissionCategoryList(string agentid)
        {
            return _repo.GetAgentCommissionCategoryList(agentid);
        }

        public CommissionCategoryDetailCommon GetAgentCommissioncategoryProductById(string id)
        {
            return _repo.GetAgentCommissioncategoryProductById(id);
        }

        public List<CommissionCategoryDetailCommon> GetAgentCommissionCategoryProductList(string Id)
        {
            return _repo.GetAgentCommissionCategoryProductList(Id);

        }

        public AssignCommissionCommon GetAssignedCategoryById(string id)
        {
            return _repo.GetAssignedCategoryById(id);

        }

        public List<AssignCommissionCommon> GetAssignedCategoryList(AssignCommissionCommon ACC)
        {
            return _repo.GetAssignedCategoryList(ACC);

        }

        public CommonDbResponse ManageAgentCommissionCategory(CommissionCategoryCommon CC)
        {
            return _repo.ManageAgentCommissionCategory(CC);

        }

        public CommonDbResponse ManageAgentCommissionCategoryProduct(CommissionCategoryDetailCommon CDC)
        {
            return _repo.ManageAgentCommissionCategoryProduct(CDC);

        }

        public CommonDbResponse ManageAssignCategory(AssignCommissionCommon ACC)
        {
            return _repo.ManageAssignCategory(ACC);
        }
    }
}
