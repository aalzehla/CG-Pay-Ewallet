using cgpay.wallet.repository.Utilities;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Utilities.Vianet;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.Utilities
{
    public class VianetBillPaymentBusiness:IVianetBillPaymentBusiness
    {
        IVianetBillPaymentRepository repo;
        public VianetBillPaymentBusiness()
        {
            repo = new VianetBillPaymentRepository();
        }
        public CommonDbResponse BillPayment(VianetBillPaymentCommon payment)
        {
            return repo.BillPayment(payment);
        }
        public CommonDbResponse CheckVianetAccount(VianetBillInquiryCommon Common)
        {
            return repo.CheckVianetAccount(Common);
        }
    }
}
