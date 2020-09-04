using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Errors;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.Error
{
    public class ErrorLogRepository : IErrorLogRepository
    {
        RepositoryDao Dao;
        public ErrorLogRepository()
        {
            Dao = new RepositoryDao();
        }
        public CommonDbResponse InsertErrors(ErrorsLog el)
        {

            string sqlCommand = "Execute sproc_errors @flag = 'i',";
            sqlCommand += "@error_Page = " + Dao.FilterString(el.error_page) + ",";
            sqlCommand += "@error_Msg = " + Dao.FilterString(el.error_msg) + ",";
            sqlCommand += "@error_Detail = " + Dao.FilterString(el.error_detail) + ",";
            sqlCommand += "@USER =" + Dao.FilterString(el.user);
            return Dao.ParseCommonDbResponse(sqlCommand);
        }
    }
}
