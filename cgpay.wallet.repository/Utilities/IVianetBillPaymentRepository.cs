﻿using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Utilities.Vianet;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.Utilities
{
   public interface IVianetBillPaymentRepository
    {
        CommonDbResponse BillPayment(VianetBillPaymentCommon payment);
        CommonDbResponse CheckVianetAccount(VianetBillInquiryCommon Common);
    }
}
