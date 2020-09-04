using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.Utilities
{
    public interface INeaBillPaymentRepository
    {
        Dictionary<string, string> GetNeaOfficeList();
        CommonDbResponse GetPackage(NeaBillInquiryCommon NBI);
        CommonDbResponse neabillCharges(NeaBillChargeCommon NBIR);
        CommonDbResponse payment(NeaBillPaymentCommon BP);
    }
}
