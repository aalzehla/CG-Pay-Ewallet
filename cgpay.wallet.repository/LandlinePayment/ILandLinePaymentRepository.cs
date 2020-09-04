using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.LandlinePayment
{
    public interface ILandLinePaymentRepository
    {
        CommonDbResponse GetPackage(string PhoneNumber, long Amount, string servicecode);
        CommonDbResponse Payment(string PhoneNumber, long Amount, string servicecode, string billnumber, string refstan);
        CommonDbResponse ConsumeService(string PhoneNumber, long Amount);
        CommonDbResponse DirectPayment(string TransactionId);
        //Dictionary<string, string> Denomination(string ProductId, Dictionary<string, string> dictionary);
    }
}
