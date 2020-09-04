using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.Utilities
{
    public interface IWorldLinkBillPaymentRepository
    {
        CommonDbResponse CheckWlinkAccount(WorldLinkBillInquiryCommon Common);
        CommonDbResponse BillPayment(WorldLinkBillPaymentCommon payment);
    }
}
