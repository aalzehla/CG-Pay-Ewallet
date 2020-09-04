using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.Gateway
{
    public class GatewayRepository : IGatewayRepository
    {
        RepositoryDao dao;

        public GatewayRepository()
        {
            dao = new RepositoryDao();
        }

        public List<GatewayCommon> GetGatewayList()
        {
            var sql = "Exec sproc_gateway_detail ";
            sql += "@flag = 's' ";
            //sql += ",@gateway_id = " + dao.FilterString(gateway_id);

            var dt = dao.ExecuteDataTable(sql);
            var list = new List<GatewayCommon>();

            if (null != dt)
            {
                int sn = 1;

                foreach (DataRow item in dt.Rows)
                {
                    var common = new GatewayCommon
                    {
                        GatewayId = item["gateway_id"].ToString(),
                        GatewayName = item["gateway_name"].ToString(),
                        GatewayBalance = item["gateway_balance"].ToString(),
                        GatewayURL = item["gateway_url"].ToString(),
                        GatewayStatus = item["STATUS"].ToString()
                    };
                    sn++;
                    list.Add(common);
                }
            }
            return list;
        }

        public GatewayCommon GetGatewayById(string gateway_id)
        {
            var sql = "Exec sproc_gateway_detail ";
            sql += "@flag = 's' ";
            sql += ",@gateway_id = " + dao.FilterString(gateway_id);

            var dt = dao.ExecuteDataTable(sql);
            var item = new GatewayCommon();
           

            if (null != dt)
            {
                int sn = 1;

                foreach (DataRow dr in dt.Rows)
                {
                    var common = new GatewayCommon
                    {
                        GatewayId = dr["gateway_id"].ToString(),
                        GatewayName = dr["gateway_name"].ToString(),
                        GatewayBalance = dr["gateway_balance"].ToString(),
                        GatewayCountry = dr["gateway_country"].ToString(),
                        GatewayCurrency = dr["gateway_currency"].ToString(),
                        GatewayUsername = dr["gateway_username"].ToString(),
                        GatewayPwd = dr["gateway_password"].ToString(),
                        GatewayAccessCode = dr["gateway_access_code"].ToString(),
                        GatewaySecurityCode = dr["gateway_security_code"].ToString(),
                        GatewayApitoken = dr["gateway_api_token"].ToString(),
                        IsDirectGateway = dr["is_direct_gateway"].ToString().ToUpper()=="Y"?true:false,
                        GatewayType = dr["gateway_type"].ToString(),                     
                        GatewayURL = dr["gateway_url"].ToString(),
                        GatewayStatus = dr["STATUS"].ToString()
                    };
                    
                    return common;
                }
            }
            return item;
        }

        public CommonDbResponse ManageGateway(GatewayCommon setup)
        {
            var sql = "Exec sproc_gateway_detail ";
            sql += "@flag = '" + (string.IsNullOrEmpty(setup.GatewayId) ? "i" : "u") + "' ";
            sql += ",@gateway_name = " + dao.FilterString(setup.GatewayName);
           // sql += ",@gateway_balance = " + dao.FilterString(setup.GatewayBalance);
            sql += ",@gateway_country = " + dao.FilterString(setup.GatewayCountry);
            sql += ",@gateway_currency = " + dao.FilterString(setup.GatewayCurrency);
            sql += ",@gateway_user_name = " + dao.FilterString(setup.GatewayUsername);
            sql += ",@gateway_password = " + dao.FilterString(setup.GatewayPwd);
            sql += ",@gateway_access_code = " + dao.FilterString(setup.GatewayAccessCode);
            sql += ",@gateway_security_code = " + dao.FilterString(setup.GatewaySecurityCode);
            sql += ",@gateway_api_token = " + dao.FilterString(setup.GatewayApitoken);
            sql += ",@gateway_url = " + dao.FilterString(setup.GatewayURL);
            sql += ",@gateway_status = " + dao.FilterString(setup.GatewayStatus);
            sql += ",@gateway_contact = " + dao.FilterString(setup.GatewayContact);
            sql += ",@is_direct_gateway = " + dao.FilterString(setup.IsDirectGateway==true?"Y":"N");
            sql += ",@gateway_type = " + dao.FilterString(setup.GatewayType);
            sql += ",@action_user = " + dao.FilterString(setup.ActionUser);
            sql += ",@from_ip_address = " + dao.FilterString(setup.IpAddress);
            sql += ",@gateway_id = " + (string.IsNullOrEmpty(setup.GatewayId) ? "''" : dao.FilterString(setup.GatewayId) );

            //sql += "," + (string.IsNullOrEmpty(setup.GatewayId) ? "@action_user" : "@updated_by") + " = " + dao.FilterString(setup.ActionUser);
            return dao.ParseCommonDbResponse(sql);
        }
        public CommonDbResponse updatebalance(GatewayBalanceCommon bc)
        {
            var sql = "Exec sproc_gateway_detail ";
            sql += "@flag ='ub'";
            sql += ", @gateway_id=" + dao.FilterString(bc.Gatewayid);
            sql += ", @gateway_balance=" + dao.FilterString(bc.BalanceToBeAdd.ToString());
            sql += ", @remarks=" + dao.FilterString(bc.Remarks);
            sql += ", @action_user=" + dao.FilterString(bc.ActionUser);
            sql += ", @from_ip_address=" + dao.FilterString(bc.IpAddress);


            return dao.ParseCommonDbResponse(sql);
        }

        public List<GatewayProductCommon> GetGatewayProductList(string GatewayId, string ProductId)
        {
            var sql = "exec sproc_gateway_products_commission";
            sql += " @flag = 's' ";
            sql += ", @gateway_id ="+dao.FilterString(GatewayId);
            sql += ", @product_id ="+dao.FilterString(ProductId);
            var dt = dao.ExecuteDataTable(sql);
            var list = new List<GatewayProductCommon>();

            if (null != dt)
            {
                int sn = 1;

                foreach (DataRow item in dt.Rows)
                {
                    var common = new GatewayProductCommon
                    {
                        GatewayProductId = (int)item["gatewayproductid"],
                        GatewayId = item["gatewayid"].ToString(),
                        ProductId=item["productid"].ToString(),
                        ProductLabel = item["servicename"].ToString(),
                        CommissionValue = float.Parse(item["commission"].ToString()),
                        CommissionType = item["commissiontype"].ToString()
                    };
       
    
                    sn++;
                    list.Add(common);
                }
            }
            return list;

        }

        //public GatewayProductCommon GetGatewayProductByid(string GatewayId, string ProductId)
        //{
        //    var sql = "exec sproc_gateway_products_commission";
        //    sql += " @flag = 's' ";
        //    sql += ", @gateway_id =" + dao.FilterString(GatewayId);
        //    sql += ", @product_id =" + dao.FilterString(ProductId);
        //    var dt = dao.ExecuteDataTable(sql);
        //    if (null != dt)
        //    {
        //        var common = new GatewayProductCommon
        //        {
        //            GatewayId = .tostring();
        //        };
        //    }
        //}
        public CommonDbResponse ManageGatewayProductCommission(GatewayProductCommon GWPC)
        {
            var sql = "exec sproc_gateway_products_commission";
            sql += string.Equals(GWPC.IsProduct,"Y")? " @flag='u'" : " @flag='i'";
            sql += ", @gateway_id="+dao.FilterString(GWPC.GatewayId);
            sql += ", @product_id="+ dao.FilterString(GWPC.ProductId);
            sql += ", @commission="+ dao.FilterString(GWPC.CommissionValue.ToString());
            sql += ", @commission_type="+ dao.FilterString(GWPC.CommissionType);
            sql += ", @ipaddress="+ dao.FilterString(GWPC.IpAddress);
            sql += ", @createdby="+ dao.FilterString(GWPC.ActionUser);
            return dao.ParseCommonDbResponse(sql);
        }

        public List<GatewayBalanceCommon> GetGatewayReportList()
        {
            var sql = "sproc_gateway_detail @flag = 'r'";
            var dt = dao.ExecuteDataTable(sql);
            var list = new List<GatewayBalanceCommon>();

            if (null != dt)
            {
                foreach (DataRow item in dt.Rows)
                {
                    GatewayBalanceCommon common = new GatewayBalanceCommon();
                    common.Gatewayid = item["gateway_id"].ToString();
                    common.GatewayName = item["gateway_name"].ToString();
                    common.GatewayStatus = item["balance_type"].ToString();
                    common.AvaliableBalance = float.Parse(item["amount"].ToString());
                    common.BalanceToBeAdd = float.Parse(item["updated_balance"].ToString());
                    common.GatewayCurrency = item["currency_code"].ToString();
                    common.CreatedBy = item["created_by"].ToString();
                    common.Remarks = item["admin_remarks"].ToString();
                    list.Add(common);
                }
            }
            return list;
        }
    }
}
