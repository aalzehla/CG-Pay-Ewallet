using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.Merchant
{
    public class MerchantTransactionReportCommon : Common
    {
       
            
            public string MerchantID { get; set; }
            public string MerchantCode { get; set; }
            public string Amount { get; set; }
            public string CommissionAmount { get; set; }
            public string TransactionId { get; set; }
                     
            public string UserID { get; set; }
            
        
    }
}
