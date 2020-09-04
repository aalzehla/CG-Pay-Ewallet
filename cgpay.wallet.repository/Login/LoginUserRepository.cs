using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Login;
using cgpay.wallet.shared.Models.Menus;

namespace cgpay.wallet.repository.Login
{
    public class LoginUserRepository : ILoginUserRepository
    {
        RepositoryDao DAO;
        public LoginUserRepository()
        {
            DAO = new RepositoryDao();
        }
        public LoginResponse Login(LoginCommon request)
        {
            var dt = DAO.ExecuteDataTable("sproc_user_login @flag='login',@user_name=" + DAO.FilterParameter(request.UserName) +
                ",@password=" + DAO.FilterParameter(request.Password) + ",@ip=" + DAO.FilterParameter(request.IpAddress) +
                /*",@rememberMe=" + DAO.FilterParameter(request.RememberMe ? "1" : "0") +*/
                ",@browser_info=" + DAO.FilterParameter(request.BrowserDetail) + ",@session_id=" + DAO.FilterParameter(request.Session));
            LoginResponse resp = new LoginResponse();
            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow rows in dt.Rows)
                {
                    resp.code = rows["code"].ToString();
                    resp.message = rows["message"].ToString();
                    if (resp.code != "0")
                    {
                        break;
                    }
                    resp.UserId = rows["UserId"].ToString();
                    resp.RoleId = rows["RoleId"].ToString();
                    resp.AgentId = rows["AgentId"].ToString();
                    resp.ParentId = rows["ParentId"].ToString();
                    resp.UserName = rows["UserName"].ToString();
                    resp.FullName = rows["FullName"].ToString();
                    resp.UserType = rows["UserType"].ToString();
                    resp.KycStatus = rows["KycStatus"].ToString();
                    resp.FirstTimeLogin = rows["FirstTimeLogin"].ToString();
                    resp.IsPrimaryUser = rows["IsPrimaryUser"].ToString();
                    
                }
            }
            else
            {
                resp.code = "1";
                resp.message = "Login Failed!";
            }
            return resp;
        }
        public CommonDbResponse Signup(LoginCommon customer)
        {
            CommonDbResponse dbresp= DAO.ParseCommonDbResponse("sproc_Agent_Registration @flag='i',@agent_full_name=" + DAO.FilterString(customer.FullName) + ",@agent_email_address=" + DAO.FilterString(customer.Email) +
                ",@agent_mobile_number=" + DAO.FilterString(customer.MobileNo));
            return dbresp;
        }
        public UserMenuFunctions GetMenus(string UserLoginId)
        {
            var func = new UserMenuFunctions();
            string sql = "sproc_get_menu @flag='menu', @user_name = " + DAO.FilterParameter(UserLoginId);
            var dt= DAO.ExecuteDataTable(sql);
            if (dt != null)
                func.menu = DAO.DataTableToListObject<MenuCommon>(dt).ToList();
            else
                func.menu = null;
            return func;
        }
        public List<string> GetApplicationFunction(string RoleId, bool loggedin = false)
        {
            var lst = new List<string>();
            string sql = "sproc_role_management @flag='"+(!loggedin? "getMenuList": "getFunctionListLogIn") +"', @role_id = " + DAO.FilterParameter(RoleId);
            var dbres = DAO.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    lst.Add(dr["LinkUrl"].ToString());
                }
            }
            else
            {
                lst.Add("");
            }
            return lst;
        }
        public Dictionary<string, string> UserList()
        {
            var dict = new Dictionary<string, string>();
            string sql = "select sno value,user_login_id name from AdminTable order by user_login_id ASC";
            var dbres = DAO.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    dict.Add(dr["value"].ToString(), dr["name"].ToString());
                }
            }
            return dict;
        }
        public CommonDbResponse verifycode(LoginCommon verify)
        {
            string sql= "sproc_Agent_Registration";
            sql += " @flag='v'";
            sql += ",@agent_full_name=" + DAO.FilterString(verify.FullName);
            sql += ", @agent_mobile_number="+DAO.FilterString(verify.MobileNo);
            sql += ", @agent_email_address="+DAO.FilterString(verify.Email);
            sql += ", @agent_verification_code="+DAO.FilterString(verify.ActivationCode);
            return DAO.ParseCommonDbResponse(sql);
        }
        public CommonDbResponse setpassword(LoginCommon common)
        {
            string sql = "sproc_Agent_Registration";
            sql += " @flag='s'";
            sql += ",@agent_full_name=" + DAO.FilterString(common.FullName);
            sql += ", @agent_mobile_number=" + DAO.FilterString(common.MobileNo);
            sql += ", @agent_email_address=" + DAO.FilterString(common.Email);
            sql += ", @agent_new_password=" + DAO.FilterString(common.Password);
            sql += ", @agent_confirm_password=" + DAO.FilterString(common.ConfirmPassword);
            return DAO.ParseCommonDbResponse(sql);
        }
        public CommonDbResponse checkusername(LoginCommon common)
        {
            string sql = "exec [sproc_user_detail] ";
                sql+= " @flag='fpv'";
                sql+=", @user_name="+DAO.FilterString(common.UserName);
            return DAO.ParseCommonDbResponse(sql);
        }
        public CommonDbResponse Checkverifycode(LoginCommon common)
        {
            string sql = "exec [sproc_user_detail] ";
            sql += " @flag='fp'";
            sql += ", @user_name=" + DAO.FilterString(common.UserName); 
            sql += ", @verification_code=" + DAO.FilterString(common.ActivationCode); 
            return DAO.ParseCommonDbResponse(sql);

        }
         public CommonDbResponse changepassword(LoginCommon common)
        {
            string sql = "exec [sproc_user_detail] ";
            sql += " @flag='fcp'";
            sql += ", @user_name=" + DAO.FilterString(common.UserName);
            sql += ", @new_password=" + DAO.FilterString(common.Password);
            sql += ", @verification_code=" + DAO.FilterString(common.ActivationCode);
            
            return DAO.ParseCommonDbResponse(sql);
        }

        public void updateSessionId(string user_name,string session)
        {
            string sql = "exec [sproc_user_detail] ";
            sql += " @flag='usi'";
            sql += ", @user_name=" + DAO.FilterString(user_name);
            sql += ", @session=" + DAO.FilterString(session);
            DAO.ParseCommonDbResponse(sql);
        }

        public DataRow getSessionId(string user_name)
        {
            string sql = "exec [sproc_user_detail] ";
            sql += " @flag='gsi'";
            sql += ", @user_name=" + DAO.FilterString(user_name);
            return DAO.ExecuteDataRow(sql);
        }
    }
}
