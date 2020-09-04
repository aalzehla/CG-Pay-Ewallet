using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Role;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.Role
{
    public class RoleRepository : IRoleRepository
    {

        RepositoryDao dao;
        public RoleRepository()
        {
            dao = new RepositoryDao();
        }

        public List<RoleCommon> GetRoles()
        {
            var list = new List<RoleCommon>();
            string sql = "sproc_role_management @flag='s'";
            var dbres = dao.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    var rm = new RoleCommon
                    {
                        sno = dr["role_id"].ToString(),
                        RoleName = dr["role_name"].ToString(),
                        RoleType = dr["role_type"].ToString(),
                        CreatedBy = dr["created_by"].ToString(),
                        CreateDate = dr["created_local_date"].ToString(),
                      
                    };
                    list.Add(rm);
                }
            }
            return list;
        }
        public CommonDbResponse Manage(RoleCommon setup)
        {
            string sql = "sproc_role_management @flag='i', @name =" + dao.FilterString(setup.RoleName) + ",@role_type =" + dao.FilterString(setup.RoleType) + ",@user =" + dao.FilterString(setup.CreatedBy); 
            return dao.ParseCommonDbResponse(sql);
        }
        public List<Tuple<string, string,string,bool>> GetRoleList(string RoleId)
        {
            var list = new List<Tuple<string, string, string, bool>>();
            string sql = "sproc_role_management @flag = 'getMenuList',@role_id=" + dao.FilterString(RoleId); 
            var dbres = dao.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach(DataRow dr in dbres.Rows)
                {
                    var tpl =  new Tuple<string, string, string, bool>(dr["Value"].ToString(), dr["MenuName"].ToString(), dr["Parent"].ToString(), dr["Status"].ToString().ToUpper() == "Y" ? true : false);
                    list.Add(tpl);
                }
            }
            return list;
        }

        public CommonDbResponse AssignRoles(string RoleId, string RoleList, string user)
        {
            string sql = "sproc_role_management @flag ='assignMenu',@role_id =" + dao.FilterString(RoleId)+",@roles  ="+dao.FilterString(RoleList) + ",@user =" + dao.FilterString(user);
            return dao.ParseCommonDbResponse(sql);
        }

        public List<Tuple<string, string, string, bool>> GetFunctionList(string RoleId)
        {
            var lst = new List<Tuple<string, string, string, bool>>();
            string sql = "sproc_role_management @flag = 'getfunctions',@role_id=" + dao.FilterString(RoleId);
            var dbres = dao.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    var tpl = new Tuple<string, string, string, bool>(dr["Value"].ToString(), dr["FunctionName"].ToString(), dr["Parent"].ToString(), dr["Status"].ToString().ToUpper() == "Y" ? true : false);
                    lst.Add(tpl);
                }
            }
            return lst;
        }
        public CommonDbResponse AssignFunctions(string Roleid, string FunctionList, string user)
        {
            string sql = "sproc_role_management @flag ='assignfunctions',@role_id =" + dao.FilterString(Roleid) + ",@functions  =" + dao.FilterString(FunctionList) + ",@user =" + dao.FilterString(user);
            return dao.ParseCommonDbResponse(sql);
        }


    }
}
