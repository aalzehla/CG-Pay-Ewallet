using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.repository.Dashboard;
using System.Data;

namespace cgpay.wallet.business.Dashboard
{
    public class DashboardBusiness:IDashboardBusiness
    {
        IDashboardRepository _repo;

        public DashboardBusiness()
        {
            _repo = new DashboardRepository();
        }

        public DataSet CountTransactionByProduct(String User)
        {
            return _repo.CountTransactionByProduct(User);
        }
    }
}
