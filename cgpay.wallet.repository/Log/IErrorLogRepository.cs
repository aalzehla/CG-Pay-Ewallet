using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Errors;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.Error
{
   public interface IErrorLogRepository
    {
        CommonDbResponse InsertErrors(ErrorsLog el);
    }
}
