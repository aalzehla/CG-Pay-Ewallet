using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.repository.DynamicReport;
using cgpay.wallet.shared.Models.DynamicReport;

namespace cgpay.wallet.business.DynamicReport
{
    public class DynamicReportBusiness:IDynamicReportBusiness
    {
        IDynamicReportRepository _repo;
        public DynamicReportBusiness()
        {
            _repo = new DynamicReportRepository();
        }
        public List<DynamicReportCommon> GetTransactionReport(DynamicReportFilter model)
        {
            return _repo.GetTransactionReport(model);
        }
        public DynamicReportCommon GetTransactionReportDetail(string TxnId, string AgentId = "")
        {
            return _repo.GetTransactionReportDetail(TxnId,AgentId);
        }
        public List<DynamicReportCommon> GetPendingReport(DynamicReportFilter model)
        {
            return _repo.GetPendingReport(model);
        }
        public List<DynamicReportCommon> GetSettlementReport(DynamicReportFilter model)
        {
            return _repo.GetSettlementReport(model);
        }
        public List<DynamicReportCommon> GetSettlementReportclient(DynamicReportFilter DRF)
        {
            return _repo.GetSettlementReportclient(DRF);
        }
        public List<DynamicReportCommon> GetManualCommissionReport(DynamicReportFilter model)
        {
            return _repo.GetManualCommissionReport(model);
        }
        public DynamicReportCommon GetActivityDetail(string txnid, string flag)
        {
            return _repo.GetActivityDetail(txnid, flag);
        }

        public List<PaymentGatewayTransactionReport> PaymentGatewayTransactionList(DynamicReportFilter filter)
        {
            return _repo.PaymentGatewayTransactionList(filter);
        }

        public PaymentGatewayTransactionReport PaymentGatewayTransactionDetail(string TxnId)
        {
            return _repo.PaymentGatewayTransactionDetail(TxnId);
        }

        public List<MerchantTransactionCommon> MerchantTransactionReport(DynamicReportFilter model)
        {
            return _repo.MerchantTransactionReport(model);
        }

        public Dictionary<string, string> MerchantDropdown()
        {
            return _repo.MerchantDropdown();
        }
    }
}
