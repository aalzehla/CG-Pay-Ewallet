using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Commission;
using cgpay.wallet.repository.Commission;
using System.Data;

namespace cgpay.wallet.repository.Commission
{
    public class CommissionRepository : ICommissionRepository
    {
        RepositoryDao dao;
        public CommissionRepository()
        {
            dao = new RepositoryDao();
        }

        public List<CommissionCategoryCommon> GetCommissionCategoryList(string agentid)
        {
            string sql = "exec sproc_commission_detail ";
            sql += " @flag='list'";
            sql += ", @agent_id=" + dao.FilterString(agentid);
            var dt = dao.ExecuteDataTable(sql);
            List<CommissionCategoryCommon> list = new List<CommissionCategoryCommon>();

            if (dt != null)
            {
                foreach (DataRow item in dt.Rows)
                {
                    var common = new CommissionCategoryCommon
                    {
                        CategoryId = item["category_id"].ToString(),
                        CategoryName = item["category_name"].ToString(),
                        CreatedBy = item["created_by"].ToString(),
                        CreateDate = item["created_local_date"].ToString(),
                        IsActive=item["is_active"].ToString()
                        //UpdatedBy = item["updated_by"].ToString()
                    };
                    list.Add(common);

                }
            }
            return list;
        }
        public CommonDbResponse ManageCommissionCategory(CommissionCategoryCommon CC)
        {
            string sql = "exec sproc_commission_detail ";
            sql += "@flag ='" + (string.IsNullOrEmpty(CC.CategoryId) ? "i" : "") + "' ";
    
            sql += ", @agent_id=" + dao.FilterString(CC.AgentId);
            sql += ", @comm_category_id=" + dao.FilterString(CC.CategoryId);
            sql += ", @comm_category_name="+dao.FilterString(CC.CategoryName);
            sql += ","+(string.IsNullOrEmpty(CC.CategoryId)?"@created_by":"@updated_by")+"=" + dao.FilterString(CC.ActionUser);
            sql += ","+(string.IsNullOrEmpty(CC.CategoryId)?"@created_ip":"@updated_ip")+"=" + dao.FilterString(CC.IpAddress);
     

            return dao.ParseCommonDbResponse(sql);
        }
        public CommissionCategoryCommon GetCommissionCategoryById(string Id)
        {
            
            string sql = "exec sproc_commission_detail ";
            sql += " @flag='lsbyid'";
            sql += ", @comm_category_id=" + dao.FilterString(Id);
            var dt = dao.ExecuteDataRow(sql);
            CommissionCategoryCommon cc = new CommissionCategoryCommon();
            if(dt!=null)
            {
                cc.CategoryId = dt["category_id"].ToString();
                cc.CategoryName=dt["category_name"].ToString();
            }
            return cc;
        }
        public List<CommissionCategoryDetailCommon> GetCommissionCategoryProductList(string Id)
        {
            string sql = "exec sproc_commission_detail";
            sql += " @flag='cid'";
            sql += ",@comm_category_id=" + dao.FilterString(Id);
            var dt = dao.ExecuteDataTable(sql);
            List<CommissionCategoryDetailCommon> CDC = new List<CommissionCategoryDetailCommon>();
            if(dt!=null)
            {
                foreach(DataRow item in dt.Rows)
                {
                    var common = new CommissionCategoryDetailCommon
                    {
                        CommissionDetailId = item["com_detail_id"].ToString(),
                        CommissionCategoryId = item["com_category_id"].ToString(),
                        ProductId = item["product_id"].ToString(),
                        ProductLabel = item["product_label"].ToString(),
                        CommissionType = item["commission_type"].ToString(),
                        CommissionValue = item["commission_value"].ToString(),
                       CommissionPercentType = item["commission_percent_type"].ToString()
                    };
                    CDC.Add(common);
                }
            }
            return CDC;
        }
        public CommissionCategoryDetailCommon GetCommissioncategoryProductById(string id)
        {
            string sql = "exec sproc_commission_detail";
            sql += " @flag='scp'";
            sql += ",@comm_category_detail_id=" + dao.FilterString(id);
            var dt = dao.ExecuteDataRow(sql);
            CommissionCategoryDetailCommon CDC = new CommissionCategoryDetailCommon();
            if(dt!=null)
            {
                CDC.CommissionDetailId = dt["com_detail_id"].ToString();
                CDC.CommissionCategoryId = dt["com_category_id"].ToString();
                CDC.ProductId = dt["product_id"].ToString();
                CDC.CommissionType = dt["commission_type"].ToString();
                CDC.CommissionValue = dt["commission_value"].ToString();
                CDC.CommissionPercentType = dt["commission_percent_type"].ToString();
            }
            return CDC;
        }
        public CommonDbResponse ManageCommissionCategoryProduct(CommissionCategoryDetailCommon CDC)
        {
            string sql = "exec sproc_commission_detail";
            sql += " @flag='u'";
            sql += ", @commission_type=" + dao.FilterString(CDC.CommissionType);
            sql += ", @commission_value=" + dao.FilterString(CDC.CommissionValue);
            sql += ", @commission_percent_type=" + dao.FilterString(CDC.CommissionPercentType);
            sql += ", @updated_by=" + dao.FilterString(CDC.ActionUser);
            sql += ", @updated_ip=" + dao.FilterString(CDC.IpAddress);
            sql += ", @product_id=" + dao.FilterString(CDC.ProductId);
            sql += ", @comm_category_detail_id=" + dao.FilterString(CDC.CommissionDetailId);
            sql += ", @comm_category_id=" + dao.FilterString(CDC.CommissionCategoryId);
            return dao.ParseCommonDbResponse(sql);
        }
        public List<AssignCommissionCommon> GetAssignedCategoryList(AssignCommissionCommon ACC)
        {
            string sql = "exec sproc_commission_detail";
            sql += " @flag='s'";
            sql += ", @agent_id="+dao.FilterString(ACC.AgentId);
            sql += ", @agent_type="+dao.FilterString(ACC.AgentType);
            var dt = dao.ExecuteDataTable(sql);
            List < AssignCommissionCommon > lst = new List<AssignCommissionCommon>();
            if(dt!=null)
            {
                foreach(DataRow item in dt.Rows)
                {
                    var common = new AssignCommissionCommon
                    {
                        AgentName = item["distributorname"].ToString(),
                        AgentId = item["distributorid"].ToString(),
                        AgentType=item["agent_type"].ToString(),
                        CommissionCategoryId = item["categoryid"].ToString(),
                        CommissionCategoryName = item["name"].ToString()

                    };
                    lst.Add(common);
                }
            }

            return lst;

        }
        public AssignCommissionCommon GetAssignedCategoryById(string id)
        {
            AssignCommissionCommon common = new AssignCommissionCommon();
            string sql = "exec sproc_commission_detail";
            sql += " @flag='sid'";
            sql += ", @distributor_id=" + dao.FilterString(id);
            var dt = dao.ExecuteDataRow(sql);
            if(dt!=null)
            {
                common.CommissionCategoryId = dt["agent_commission_id"].ToString();
                common.AgentName = dt["agent_name"].ToString();
                common.AgentId = dt["agent_id"].ToString();
            }
            return common;
         
        }
        public CommonDbResponse ManageAssignCategory(AssignCommissionCommon ACC)
        {
            string sql = "exec sproc_commission_detail ";
            sql += "@flag ='com_u' ";

            sql += ", @comm_category_id=" + dao.FilterString(ACC.CommissionCategoryId);
            sql += ", @distributor_id=" + dao.FilterString(ACC.AgentId);
            sql += ", @updated_by=" + dao.FilterString(ACC.ActionUser);
           


            return dao.ParseCommonDbResponse(sql);
        }

        public CommonDbResponse block_unblockCategory(CommissionCategoryCommon ccc,string status)
        {
            string sql = "exec sproc_commission_detail ";
            sql += "@flag='d'";
            sql += ",@comm_category_id="+dao.FilterString(ccc.CategoryId);
            sql += ",@is_active=" + dao.FilterString(status);
            sql += ",@updated_by=" + dao.FilterString(ccc.ActionUser);
            return dao.ParseCommonDbResponse(sql);

        }
    }
}
