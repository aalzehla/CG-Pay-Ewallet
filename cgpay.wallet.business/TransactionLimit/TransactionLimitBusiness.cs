using cgpay.wallet.repository.TransactionLimit;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.TransactionLimit;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.TransactionLimit
{
    public class TransactionLimitBusiness : ITransactionLimitBusiness
    {
        ITransactionLimitRepository _repo;
        public TransactionLimitBusiness()
        {
            _repo = new TransactionLimitRepository();
        }

        public TransactionLimitCommon GetTransactionLimitById(string Id)
        {
            return _repo.GetTransactionLimitById(Id);
        }

        public List<TransactionLimitCommon> GetTransactionLimitList()
        {
            return _repo.GetTransactionLimitList();
        }

        public CommonDbResponse ManageTransactionlimit(TransactionLimitCommon TLC)
        {
            return _repo.ManageTransactionlimit(TLC);
        }

        public TransactionLimitCommon GetTransactionLimitForUser(string AgentId)
        {
            return _repo.GetTransactionLimitForUser(AgentId);
        }


    }
}
