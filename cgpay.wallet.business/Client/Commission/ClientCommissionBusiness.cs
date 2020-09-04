using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.repository.Client.Commission;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.ClientCommission;

namespace cgpay.wallet.business.Client.Commission
{
    public class ClientCommissionBusiness:IClientCommissionBusiness
    {
        IClientCommissionRepository _repo;
        public ClientCommissionBusiness()
        {
            _repo = new ClientCommissionRepository();
        }
        public List<ClientCommissionCategoryCommon> GetCommissionCategoryList(string agentid)
        {
            return _repo.GetCommissionCategoryList(agentid);
        }
        public CommonDbResponse ManageCommissionCategory(ClientCommissionCategoryCommon CC)
        {
            return _repo.ManageCommissionCategory(CC);
        }
        public ClientCommissionCategoryCommon GetCommissionCategoryById(string Id)
        {
            return _repo.GetCommissionCategoryById(Id);
        }
        public List<ClientCommissionCategoryDetailCommon> GetCommissionCategoryProductList(string Id)
        {
            return _repo.GetCommissionCategoryProductList(Id);
        }
        public ClientCommissionCategoryDetailCommon GetCommissioncategoryProductById(string id)
        {
            return _repo.GetCommissioncategoryProductById(id);
        }
        public CommonDbResponse ManageCommissionCategoryProduct(ClientCommissionCategoryDetailCommon CDC)
        {
            return _repo.ManageCommissionCategoryProduct(CDC);
        }
        public List<ClientAssignCommissionCommon> GetAssignedCategoryList(ClientAssignCommissionCommon ACC)
        {
            return _repo.GetAssignedCategoryList(ACC);
        }
        public ClientAssignCommissionCommon GetAssignedCategoryById(string id)
        {
            return _repo.GetAssignedCategoryById(id);
        }
        public CommonDbResponse ManageAssignCategory(ClientAssignCommissionCommon ACC)
        {
            return _repo.ManageAssignCategory(ACC);
        }
        public CommonDbResponse block_unblockCategory(ClientCommissionCategoryCommon ccc, string status)
        {
            return _repo.block_unblockCategory(ccc, status);
        }
    }
}
