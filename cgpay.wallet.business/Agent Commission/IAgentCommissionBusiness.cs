using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Commission;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.Agent_Commission
{
    public interface IAgentCommissionBusiness
    {
        List<CommissionCategoryCommon> GetAgentCommissionCategoryList(string agentid);

        CommissionCategoryCommon GetAgentCommissionCategoryById(string Id);

        CommonDbResponse ManageAgentCommissionCategory(CommissionCategoryCommon CC);

        CommissionCategoryDetailCommon GetAgentCommissioncategoryProductById(string id);

        List<CommissionCategoryDetailCommon> GetAgentCommissionCategoryProductList(string Id);

        CommonDbResponse block_unblockCategory(CommissionCategoryCommon ccc, string status);

        CommonDbResponse ManageAgentCommissionCategoryProduct(CommissionCategoryDetailCommon CDC);

        List<AssignCommissionCommon> GetAssignedCategoryList(AssignCommissionCommon ACC);

        AssignCommissionCommon GetAssignedCategoryById(string id);


        CommonDbResponse ManageAssignCategory(AssignCommissionCommon ACC);

       AssignCommissionCommon GetAdminCommCatagory(string id);

        CommissionCategoryDetailCommon GetAdminCommvalue(string catId, string productId);

    }
}
