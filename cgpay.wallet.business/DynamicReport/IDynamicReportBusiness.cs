using cgpay.wallet.shared.Models.DynamicReport;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.DynamicReport
{
    public interface IDynamicReportBusiness
    {
        List<DynamicReportCommon> GetTransactionReport(DynamicReportFilter model);
        DynamicReportCommon GetTransactionReportDetail(string TxnId, string AgentId = "");
        List<DynamicReportCommon> GetPendingReport(DynamicReportFilter model);
        List<DynamicReportCommon> GetSettlementReport(DynamicReportFilter model);
        List<DynamicReportCommon> GetSettlementReportclient(DynamicReportFilter DRW);
        List<DynamicReportCommon> GetManualCommissionReport(DynamicReportFilter model);
        DynamicReportCommon GetActivityDetail(string txnid, string flag);
        List<PaymentGatewayTransactionReport> PaymentGatewayTransactionList(DynamicReportFilter filter);
        PaymentGatewayTransactionReport PaymentGatewayTransactionDetail(string TxnId);
        List<MerchantTransactionCommon> MerchantTransactionReport(DynamicReportFilter model);
        Dictionary<string, string> MerchantDropdown();
    }
}
