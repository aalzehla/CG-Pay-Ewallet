using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.ErrorHandler
{
    public class ErrorHandlerRepository : IErrorHandlerRepository
    {
        RepositoryDao Dao;
        public ErrorHandlerRepository()
        {
            Dao = new RepositoryDao();
        }
        public string LogError(Exception ex, string Page, string UserName, string IpAddress)
        {
            return Dao.LogError(ex, Page, UserName, IpAddress);
        }
    }
}
