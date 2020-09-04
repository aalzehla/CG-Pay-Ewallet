using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Mobile;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.Mobile
{
    public class MobileTopUpPaymentRepository : IMobileTopUpPaymentRepository
    {

        RepositoryDao dao;
        public MobileTopUpPaymentRepository()
        {
            dao = new RepositoryDao();
        }
        public CommonDbResponse MobileTopUpPaymentRequest(MobileTopUpPaymentRequest mr)
        {
            string sqlCommand = "Execute sproc_txn_request @flag = 'i',";
            sqlCommand += "@action_user = " + dao.FilterString(mr.action_user);
            sqlCommand += ",@product_id = " + dao.FilterString(mr.product_id);
            sqlCommand += ",@amount = " + dao.FilterString(mr.amount);
            sqlCommand += ",@subscriber_no = " + dao.FilterString(mr.subscriber_no);
            sqlCommand += ",@quantity = " + dao.FilterString(mr.quantity);
            sqlCommand += ",@additional_data= " + dao.FilterString(mr.additonal_data);
            sqlCommand += ",@card_no= " + dao.FilterString(mr.CardNo);
            sqlCommand += ",@created_ip= " + dao.FilterString(mr.CreatedIp);
            //sqlCommand += ",@card_amount= " + dao.FilterString(mr.CardAmount);
            return dao.ParseCommonDbResponse(sqlCommand);
        }

        public CommonDbResponse MobileTopUpPaymentResponse(MobileTopUpPaymentUpdateRequest mr)
        {
            string sqlCommand = "sproc_txn_response @product_id =" + dao.FilterString(mr.product_id) +
            ",@subscriber_no =" + dao.FilterString(mr.subscriber_no) +
            ",@amount =" + dao.FilterString(mr.amount) +
            ",@status =" + dao.FilterString(mr.status_code) +
            ",@created_ip =" + dao.FilterString(mr.ip_address) +
            ",@updated_by =" + dao.FilterString(mr.action_user) +
            ",@service_charge =" + dao.FilterString(mr.service_charge) +
            ",@txn_id =" + dao.FilterString(mr.transaction_id) +
            ",@partner_txn_id =" + dao.FilterString(mr.partner_txn_id) +
            ",@remarks =" + dao.FilterString(mr.remarks) +
            ",@gtw_response =" + dao.FilterString(mr.remarks) +
            ",@gtw_bill_id =" + dao.FilterString(mr.bill_number) +
            ",@gtw_txn_id =" + dao.FilterString(mr.refstan);
            sqlCommand += ",@additional_data= " + dao.FilterString(mr.additonal_data);
            return dao.ParseCommonDbResponse(sqlCommand);
        }
    }
}
