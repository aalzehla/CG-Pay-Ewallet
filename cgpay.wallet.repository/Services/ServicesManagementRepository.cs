using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Services;

namespace cgpay.wallet.repository.Services
{
    public class ServicesManagementRepository : IServicesManagementRepository
    {
        RepositoryDao DAO;
        public ServicesManagementRepository()
        {
            DAO = new RepositoryDao();
        }
        public List<ServicesCommon> GetServicesList(string UserId = "")
        {
            var list = new List<ServicesCommon>();
            string sql = "sproc_manage_services @flag='v'";
            sql += (string.IsNullOrEmpty(UserId) ? "" : ", @user_id =" + DAO.FilterString(UserId));
            var dt = DAO.ExecuteDataTable(sql);
            //  List<ServicesCommon> list = new List<ServicesCommon>();
            if (dt != null)
            {

                //int sn = 1;
                foreach (DataRow item in dt.Rows)
                {
                    var common = new ServicesCommon();
                    //{
                    common.ProductId = item["product_id"].ToString();
                    common.TransactionType = item["txn_type"].ToString();
                    common.Company = item["company"].ToString();
                    // ProductServiceInfo = item[""].ToString(),
                    common.ProductLabel = item["product_label"].ToString();
                    common.ProductType = item["product_type"].ToString();
                    common.ProductCategory = item["product_category"].ToString();
                    common.MinDenominationAmount = item["min_denomination_amount"].ToString();
                    common.MaxDenomonationAmount = item["max_denomination_amount"].ToString();
                    common.ProductLogo = item["product_logo"].ToString();
                    common.ProductCode = dt.Columns.Contains("product_code") ? item["product_code"].ToString() : "";
                    common.ProductUrl = dt.Columns.Contains("product_url") ? item["product_url"].ToString() : "";
                    //PrimaryGateway = item[""].ToString(),
                    //SecondaryGateway = item[""].ToString(),
                    common.Status = item["product_status"].ToString();
                    common.ClientPmtUrl = item["clientPmtUrl"].ToString();
                    // };
                    if (!string.IsNullOrEmpty(UserId))
                    {
                        common.CommissionValue = item["commission_value"].ToString();
                        common.CommissionType = item["commission_type"].ToString();
                    }

                    list.Add(common);
                }
            }

            else
                list = null;
            return list;
        }

        public ServicesCommon GetServicesByProductId(int ProductId)
        {
            var services = new ServicesCommon();
            string sql = "sproc_manage_services @flag='vid',@product_id=" + DAO.FilterString(ProductId.ToString());
            var dr = DAO.ExecuteDataRow(sql);
            if (dr != null)
            {
                services.ProductId = dr["product_id"].ToString();
                services.TransactionType = dr["txn_type"].ToString();
                services.Company = dr["company"].ToString();
                services.ProductServiceInfo = dr["Product_service_info"].ToString();
                services.ProductLabel = dr["product_label"].ToString();
                services.ProductType = dr["product_type"].ToString();
                services.ProductCategory = dr["product_category"].ToString();
                services.MinDenominationAmount = dr["min_denomination_amount"].ToString();
                services.MaxDenomonationAmount = dr["max_denomination_amount"].ToString();
                services.ProductLogo = dr["product_logo"].ToString();
                services.ProductCode = dr.Table.Columns.Contains("product_code") ? dr["product_code"].ToString() : "";
                services.ProductUrl = dr.Table.Columns.Contains("product_url") ? dr["product_url"].ToString() : "";
                services.PrimaryGateway = dr["primary_gateway"].ToString();
                services.SecondaryGateway = dr["secondary_gateway"].ToString();
                services.Status = dr["product_status"].ToString().Trim();
            }
            return services;
        }
        public CommonDbResponse ManageServices(ServicesCommon SC, string username)
        {
            string[] producttype = SC.ProductType.Split('|');
            string sql = "sproc_manage_services ";
            sql += "@flag ='" + (string.IsNullOrEmpty(SC.ProductId) ? "i" : "u") + "' ";


            sql += ",@product_label=" + DAO.FilterString(SC.ProductLabel);
            sql += ",@product_type_id=" + DAO.FilterString(producttype[0]);
            sql += ",@product_type=" + DAO.FilterString(producttype[1]);

            sql += ",@product_logo=" + DAO.FilterString(SC.ProductLogo);
            sql += ",@product_service_info=" + DAO.FilterString(SC.ProductServiceInfo);
            sql += ",@product_category=" + DAO.FilterString(SC.ProductCategory);
            sql += ",@denomination_min=" + DAO.FilterString(SC.MinDenominationAmount);
            sql += ",@denomination_max=" + DAO.FilterString(SC.MaxDenomonationAmount);
            sql += "," + (string.IsNullOrEmpty(SC.ProductId) ? "@created_by" : "@updated_by") + " = " + DAO.FilterString(username);
            sql += ",@product_url=" + DAO.FilterString(SC.ProductUrl);
            if (string.IsNullOrEmpty(SC.ProductId))
            {
                string[] trantype = SC.TransactionType.Split('|');
                string[] company = SC.Company.Split('|');
                sql += ",@product_status=" + DAO.FilterString(SC.Status);
                sql += ",@product_code=" + DAO.FilterString(SC.ProductCode);
                sql += ",@txn_type_id=" + DAO.FilterString(trantype[0]);
                sql += ",@txn_type=" + DAO.FilterString(trantype[1]);
                sql += ",@company_id=" + DAO.FilterString(company[0]);
                sql += ",@company=" + DAO.FilterString(company[1]);
                sql += ",@primary_gateway=" + DAO.FilterString(SC.PrimaryGateway);
                sql += ",@secondary_gateway=" + DAO.FilterString(SC.SecondaryGateway);
                sql += ",@created_ip=" + DAO.FilterString(SC.CreatedIp);
            }
            else
            {
                sql += ",@product_id=" + DAO.FilterString(SC.ProductId.ToString());
            }
            return DAO.ParseCommonDbResponse(sql);
        }
        public void ServicesStatus(string[] services, string username, string ipaddress)
        {
            string sql = "update tbl_manage_services set status=null";
            var resp = DAO.ExecuteDataRow(sql);

            for (Int32 i = 0; i < services.Length; i++)
            {
                sql = "update tbl_manage_services set status='Y' where product_id=" + DAO.FilterString(services[i].ToString());
                resp = DAO.ExecuteDataRow(sql);
            }

        }

        public Dictionary<string, string> Dropdown(string flag)
        {
            string sql = "sproc_get_dropdown_list";
            sql += " @flag=" + DAO.FilterString(flag);
            Dictionary<string, string> dict = DAO.ParseSqlToDictionary(sql);
            return dict;
        }

        // public CommonDbResponse UpdateServicesByProductId(ServicesCommon SC,string username)
        //{
        //    CommonDbResponse dbres = new CommonDbResponse();
        //    string sql = "sproc_manage_services @flag='U',@product_id=" + DAO.FilterString(SC.ProductId.ToString()) +
        //        ",@txn_type=" + DAO.FilterString(SC.TransactionType) +
        //        ",@product_label=" + DAO.FilterString(SC.TransactionType) +
        //        ",@product_logo=" + DAO.FilterString(SC.TransactionType) +
        //        ",@product_service_info=" + DAO.FilterString(SC.TransactionType) +
        //        ",@product_category=" + DAO.FilterString(SC.TransactionType) +
        //        ",@min_denomination_amount=" + DAO.FilterString(SC.TransactionType) +
        //        ",@max_denomination_amount=" + DAO.FilterString(SC.TransactionType) +
        //        ",@status=" + DAO.FilterString(SC.TransactionType) +
        //        ",@updated_by=" + DAO.FilterString(username);
        //    var resp = DAO.ExecuteDataRow(sql);
        //    // dbres.Code = resp["Code"].ToString();
        //    dbres.Message = resp["message"].ToString();
        //    return dbres;

        //}

    }
}
