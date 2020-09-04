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
   public class WorldLinkBillPaymentBusiness:IWorldLinkBillPaymentBusiness
    {

        IWorldLinkBillPaymentRepository repo;
        public WorldLinkBillPaymentBusiness()
        {
            repo = new WorldLinkBillPaymentRepository();
        }
        public CommonDbResponse CheckWlinkAccount(WorldLinkBillInquiryCommon Common)
        {
            return repo.CheckWlinkAccount(Common);
        }
        public CommonDbResponse BillPayment(WorldLinkBillPaymentCommon payment)
        {
            return repo.BillPayment(payment);
        }
    }
}
