using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace cgpay.wallet.repository.Dashboard
{
    public class DashboardRepository: IDashboardRepository
    {
        RepositoryDao DAO;
        public DashboardRepository()
        {
            DAO = new RepositoryDao();
        }

        public DataSet CountTransactionByProduct(string User)
        {
            var sql = "EXEC sproc_dashboard ";
            sql += "@FLAG = 'dashboardChart'";
            sql += ",@User = " + DAO.FilterString(User);
            var ds = DAO.ExecuteDataset(sql);
            return ds;
        }
    }
}
