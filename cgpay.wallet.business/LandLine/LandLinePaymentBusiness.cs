using cgpay.wallet.repository.LandlinePayment;
using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.LandLine
{
    public class LandLinePaymentBusiness:ILandLinePaymentBusiness
    {
        ILandLinePaymentRepository repo;
        public LandLinePaymentBusiness()
        {
            repo = new LandLinePaymentRepository();
        }
       public CommonDbResponse GetPackage(string PhoneNumber, long Amount, string servicecode)
        {
            return repo.GetPackage(PhoneNumber, Amount, servicecode);
        }
        public CommonDbResponse Payment(string PhoneNumber, long Amount, string servicecode, string billnumber, string refstan)
        {
            return repo.Payment(PhoneNumber, Amount, servicecode, billnumber, refstan);
        }
       public CommonDbResponse ConsumeService(string PhoneNumber, long Amount)
        {
            return repo.ConsumeService(PhoneNumber, Amount);
        }
         
       public  CommonDbResponse DirectPayment(string TransactionId)
        {
            return repo.DirectPayment(TransactionId);
        }
        //public Dictionary<string, string> Denomination(string ProductId, Dictionary<string, string> dictionary)
        //{
        //    return repo.Denomination( ProductId,  dictionary);
        //}
    }
}
