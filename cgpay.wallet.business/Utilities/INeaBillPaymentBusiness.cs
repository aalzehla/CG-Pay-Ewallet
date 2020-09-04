using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.Utilities
{
    public interface INeaBillPaymentBusiness
    {
        Dictionary<string, string> GetNeaOfficeList();
        CommonDbResponse GetPackage(NeaBillInquiryCommon NBI);
        CommonDbResponse payment(NeaBillPaymentCommon BP);
        CommonDbResponse neabillCharges(NeaBillChargeCommon NBIR);

    }
}
