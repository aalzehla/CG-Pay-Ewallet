using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.shared.Models.Commission;
using cgpay.wallet.repository.Commission;
using cgpay.wallet.shared.Models;

namespace cgpay.wallet.business.Commission
{
    public class CommissionBusiness:ICommissionBusiness
    {
        ICommissionRepository _repo;
        public CommissionBusiness()
        {
            _repo = new CommissionRepository();
        }
       public List<CommissionCategoryCommon> GetCommissionCategoryList(string agentid)
        {
            return _repo.GetCommissionCategoryList(agentid);
        }
        public CommonDbResponse ManageCommissionCategory(CommissionCategoryCommon CC)
        {
            return _repo.ManageCommissionCategory(CC);
        }
        public CommissionCategoryCommon GetCommissionCategoryById(string Id)
        {
            return _repo.GetCommissionCategoryById(Id);
        }
        public List<CommissionCategoryDetailCommon> GetCommissionCategoryProductList(string Id)
        {
            return _repo.GetCommissionCategoryProductList(Id);
        }
        public CommissionCategoryDetailCommon GetCommissioncategoryProductById(string id)
        {
            return _repo.GetCommissioncategoryProductById(id);
        }
        public CommonDbResponse ManageCommissionCategoryProduct(CommissionCategoryDetailCommon CDC)
        {
            return _repo.ManageCommissionCategoryProduct(CDC);
        }
        public List<AssignCommissionCommon> GetAssignedCategoryList(AssignCommissionCommon ACC)
        {
            return _repo.GetAssignedCategoryList(ACC);
        }
        public AssignCommissionCommon GetAssignedCategoryById(string id)
        {
            return _repo.GetAssignedCategoryById(id);
        }
        public CommonDbResponse ManageAssignCategory(AssignCommissionCommon ACC)
        {
            return _repo.ManageAssignCategory(ACC);
        }
        public CommonDbResponse block_unblockCategory(CommissionCategoryCommon ccc, string status)
        {
            return _repo.block_unblockCategory(ccc, status);
        }
    }
}
