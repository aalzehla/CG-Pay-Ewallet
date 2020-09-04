using cgpay.wallet.repository.Utilities;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.Utilities
{
    public class NwscBillPaymentBusiness : INwscBillPaymentBusiness
    {

        INwscBillPaymentRepository repo;
        public NwscBillPaymentBusiness()
        {
            repo = new NwscBillPaymentRepository();
        }
        public CommonDbResponse GetNwscBill(NwscBillInquiryCommon billinq)
        {
            return repo.GetNwscBill(billinq);
        }
        public CommonDbResponse BillPayment(NwscBillPaymentCommon payment)
        {
            return repo.BillPayment(payment);
        }

    }
}
