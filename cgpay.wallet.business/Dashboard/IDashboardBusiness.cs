using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace cgpay.wallet.business.Dashboard
{
    public interface IDashboardBusiness
    {
        DataSet CountTransactionByProduct(String User);
    }
}
