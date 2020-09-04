using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.MobileTopup
{
    public interface IMobilePaymentRepository
    {
        CommonDbResponse GetPackage(string MobileNumber, long Amount,string servicecode);
        CommonDbResponse Payment(string MobileNumber, long Amount,string servicecode,string billnumber,string refstan);
        CommonDbResponse ConsumeService(string MobileNumber, long Amount);
        CommonDbResponse DirectPayment(string TransactionId);
    }
}
