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
    public class NeaBillPaymentBusinsess:INeaBillPaymentBusiness
    {
        
        INeaBillPaymentRepository repo;
        public NeaBillPaymentBusinsess()
        {
            repo = new NeaBillPaymentRepository();
        }

        public Dictionary<string, string> GetNeaOfficeList()
        {
            return repo.GetNeaOfficeList();
        }
        public CommonDbResponse GetPackage(NeaBillInquiryCommon NBI)
        {
            return repo.GetPackage(NBI);
        }
        public CommonDbResponse payment(NeaBillPaymentCommon BP)
        {
          return  repo.payment( BP);
        }
        public CommonDbResponse neabillCharges(NeaBillChargeCommon NBIR)
        {
            return repo.neabillCharges(NBIR);
        }
    }
}
