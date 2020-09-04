using cgpay.wallet.repository.AdminCommission;
using cgpay.wallet.shared.Models.DynamicReport;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.AdminCommission
{
    public class AdminCommissionBusiness : IAdminCommissionBusiness
    {
        IAdminCommissionRepository _repo;
        public AdminCommissionBusiness()
        {
            _repo = new AdminCommissionRepository();
        }
        public List<AdminCommissionReportCommon> GetAdminCommissionDetail(string TransactionId)
        {
            return _repo.GetAdminCommissionDetail(TransactionId);
        }

        public List<AdminCommissionReportCommon> GetAdminCommissionDetailList(string ProductId, string CurrentDate)
        {
            return _repo.GetAdminCommissionDetailList(ProductId, CurrentDate);
        }

        public List<AdminCommissionReportCommon> GetAdminCommissionReport(string FromDate ="", string ToDate="")
        {
            return _repo.GetAdminCommissionReport(FromDate, ToDate); 
        }
    }
}
