using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Mobile;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.Mobile
{
    interface IMobileTopUpPaymentRepository
    {
        CommonDbResponse MobileTopUpPaymentRequest(MobileTopUpPaymentRequest mr);
        CommonDbResponse MobileTopUpPaymentResponse(MobileTopUpPaymentUpdateRequest mr);
    }
}
