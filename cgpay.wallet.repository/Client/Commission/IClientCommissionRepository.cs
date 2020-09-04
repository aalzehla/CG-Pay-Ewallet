using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.ClientCommission;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.Client.Commission
{
    public interface IClientCommissionRepository
    {
        List<ClientCommissionCategoryCommon> GetCommissionCategoryList(string agentid);
        CommonDbResponse ManageCommissionCategory(ClientCommissionCategoryCommon CC);
        ClientCommissionCategoryCommon GetCommissionCategoryById(string Id);
        List<ClientCommissionCategoryDetailCommon> GetCommissionCategoryProductList(string Id);
        ClientCommissionCategoryDetailCommon GetCommissioncategoryProductById(string id);
        CommonDbResponse ManageCommissionCategoryProduct(ClientCommissionCategoryDetailCommon CDC);
        List<ClientAssignCommissionCommon> GetAssignedCategoryList(ClientAssignCommissionCommon ACC);
        ClientAssignCommissionCommon GetAssignedCategoryById(string id);
        CommonDbResponse ManageAssignCategory(ClientAssignCommissionCommon ACC);
        CommonDbResponse block_unblockCategory(ClientCommissionCategoryCommon ccc, string status);
    }
}
