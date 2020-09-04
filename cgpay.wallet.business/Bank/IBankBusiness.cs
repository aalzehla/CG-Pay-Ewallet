using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Bank;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.Bank
{
    public interface IBankBusiness
    {
        List<BankCommon> GetBankList();
        CommonDbResponse AddBank(BankCommon bank);
        CommonDbResponse UpdateBank(BankCommon bank);
    }
}
