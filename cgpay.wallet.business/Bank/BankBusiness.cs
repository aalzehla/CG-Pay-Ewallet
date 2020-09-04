using cgpay.wallet.repository.Bank;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Bank;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.Bank
{
    public class BankBusiness : IBankBusiness
    {
        IBankRepository repo;
        public BankBusiness(BankRepository _repo)
        {
            this.repo = _repo;
        }
        public CommonDbResponse AddBank(BankCommon bank)
        {
            return repo.AddBank(bank);
        }

        public List<BankCommon> GetBankList()
        {
            return repo.GetBankList();
        }

        public CommonDbResponse UpdateBank(BankCommon bank)
        {
            return repo.UpdateBank(bank);
        }
    }
}
