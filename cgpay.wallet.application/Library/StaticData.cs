using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.application.CustomHelpers;
using cgpay.wallet.shared.Models;

namespace cgpay.wallet.application.Library
{
    public static class StaticData
    {
        public static string GetUser()
        {
            var user = ReadSession("UserName", "");
            if (null == user)
            {
                HttpContext.Current.Response.Redirect("/Home");
            }

            if (ReadSession("ForcedPwdChange", "").ToUpper() == "Y")
            {
                HttpContext.Current.Response.Redirect("/ChangeUserPassword");
            }
            return user;
        }

        public static string ReadSession(string key, string defVal)
        {
            try
            {
                var User = HttpContext.Current.Session[key] == null ? defVal : HttpContext.Current.Session[key].ToString();
                return User;

            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public static HtmlHelper GetHtmlHelper(this Controller controller)
        {
            var viewContext = new ViewContext(controller.ControllerContext, new FakeView(), controller.ViewData, controller.TempData, TextWriter.Null);
            return new HtmlHelper(viewContext, new ViewPage());
        }
        public static string GetActions(string ControlText, string Id, Controller cont, string controlRoleUrl = "", string ControlUrl = "", string ExtraId1 = "", string ExtraId2 = "", string ExtraId3 = "", string ExtraId4 = "", string ExtraId5 = "", bool DisableAddEdit = false)
        {
            var link = "";
            link += "<div class=\"list-icons\">";
            link += "<div class=\"dropdown\">";
            link += "<a href=\"#\" class=\"list-icons-item\" data-toggle=\"dropdown\">";
            link += "<i class=\"icon-menu9\"></i>";
            link += "</a>";

            link += "<div class=\"dropdown-menu dropdown-menu-right\">";

            ExtraId1 = ExtraId1 ?? "";
            ExtraId2 = ExtraId2 ?? "";
            ExtraId3 = ExtraId3 ?? "";
            ExtraId1 = ExtraId1.Trim();
            ExtraId2 = ExtraId2.Trim();
            ExtraId3 = ExtraId3.Trim();
            var h = GetHtmlHelper(cont);


            if (ControlText == "User")
            {
                link += h.NHyperLink("Detail", new { @class = "dropdown-item", @data_val = Id }, "/Admin/User/ViewDetail", "/Admin/User/ViewDetail?UserId=" + Id, true, "icon-file-eye2").ToHtmlString();
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id }, "/Admin/User/ManageUser", "/Admin/User/ManageUser?UserId=" + Id, true, "icon-pen").ToHtmlString();
                if (ExtraId2.ToUpper() != ExtraId3.ToUpper())
                {
                    link += h.NHyperLink("Change Password", new { @class = "dropdown-item", @data_val = Id, onclick = "changePassword('" + Id + "')" }, "/Admin/User/ChangeUserPassword", "#", true, "icon-key").ToHtmlString();
                    link += h.NHyperLink("Assign Role", new { @class = "dropdown-item", @data_val = Id, onclick = "assignRole('" + Id + "','" + ExtraId4 + "')" }, "/Admin/User/AssignRole", "#", true, "icon-pencil").ToHtmlString();
                    if (ExtraId1.ToLower() == "n" || ExtraId1.ToLower() == "no")
                        link += h.NHyperLink("Unblock", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/User/UnBlockUser", "#", true, "icon-unlocked2").ToHtmlString();
                    else if (ExtraId1.ToLower() == "y" || ExtraId1.ToLower() == "yes")
                        link += h.NHyperLink("Block", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/User/BlockUser", "#", true, "icon-lock2").ToHtmlString();
                    link += h.NHyperLink("Delete", new { @class = "dropdown-item", @data_val = Id }, "/Admin/User/DeleteUser", "#", true, "icon-trash").ToHtmlString();
                }

            }
            else if (ControlText == "SearchUser")
            {
                link += h.NHyperLink("Detail", new { @class = "dropdown-item", @data_val = Id }, "/Admin/User/ViewSearchUserDetail", "/Admin/User/ViewSearchUserDetail?UserId=" + Id, true, "icon-file-eye2").ToHtmlString();
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id }, "/Admin/User/EditSearchUser", "/Admin/User/EditSearchUser?UserId=" + Id, true, "icon-pen").ToHtmlString();
                if (ExtraId2.ToUpper() != ExtraId3.ToUpper() && ExtraId4.ToUpper() != "Y")
                {
                    //link += h.NHyperLink("Change Password", new { @class = "dropdown-item", @data_val = Id, onclick = "changePassword('" + Id + "')" }, "/Admin/User/ChangeUserPassword", "#", true, "icon-key").ToHtmlString();
                    if (ExtraId1.ToLower() == "n" || ExtraId1.ToLower() == "no")
                        link += h.NHyperLink("Unblock", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId3 }, "/Admin/User/UnBlockSearchUser", "#", true, "icon-unlocked2").ToHtmlString();
                    else if (ExtraId1.ToLower() == "y" || ExtraId1.ToLower() == "yes")
                        link += h.NHyperLink("Block", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId3 }, "/Admin/User/BlockSearchUser", "#", true, "icon-lock2").ToHtmlString();
                    //link += h.NHyperLink("Delete", new { @class = "dropdown-item", @data_val = Id }, "/Admin/User/DeleteUser", "#", true, "icon-trash").ToHtmlString();
                }

            }
            else if (ControlText == "TransactionLimit")
            {
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id }, "/Admin/TransactionLimit/ManageTransaction", "/Admin/TransactionLimit/ManageTransaction?transactionId=" + Id, true, "icon-pen").ToHtmlString();
            }
            else if (ControlText == "APILog")
            {
                link += h.NHyperLink("Detail", new { @class = "dropdown-item", @data_val = Id }, "/Admin/Log/ApiRequestLog", "/Admin/Log/ApiRequestLog?ApiRequestLog=" + Id, true, "icon-file-eye2").ToHtmlString();
            }

            else if (ControlText == "AgentManagement")
            {
                link += h.NHyperLink("Detail", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/AgentManagement/ViewAgentDetail", "/Admin/AgentManagement/ViewAgentDetail?agentId=" + Id + "&User_Name=" + ExtraId1, true, "icon-file-eye2").ToHtmlString();
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/AgentManagement/ManageAgent", "/Admin/AgentManagement/ManageAgent?agentId=" + Id + "&User_Name=" + ExtraId1, true, "icon-pen").ToHtmlString();
                link += h.NHyperLink("Credit Limit", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1, onclick = "showpopupmodel('" + Id + "')" }, "/Admin/AgentManagement/ExtendCreditLimit", "#", true, "icon-coins").ToHtmlString();
                if (ExtraId2.ToLower() == "y" || ExtraId2.ToLower() == "yes")
                {
                    link += h.NHyperLink("Block", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/AgentManagement/DisableAgent", "#", true, "icon-lock2").ToHtmlString();
                    link += h.NHyperLink("View Agent Users", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId3 }, "/Admin/AgentManagement/ViewAgentUser", "/Admin/AgentManagement/ViewAgentUser?AgentId=" + Id + "&ParentId=" + ExtraId3, true, "icon-users").ToHtmlString();
                }
                else if (ExtraId2.ToLower() == "n" || ExtraId2.ToLower() == "no")
                {
                    link += h.NHyperLink("Unblock", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/AgentManagement/EnableAgent", "#", true, "icon-unlocked2").ToHtmlString();
                }
                link += h.NHyperLink("View Wallet Users", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/CustomerManagement/Index", "/Admin/CustomerManagement/Index?ParentId=" + Id, true, "icon-users2").ToHtmlString();
                link += h.NHyperLink("View Sub-Agents", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/SubAgentManagement/Index", "/Admin/SubAgentManagement/Index?agentId=" + Id + "&UserName=" + ExtraId1, true, "icon-users4").ToHtmlString();


            }
            else if (ControlText == "ViewAgentUser")
            {
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/AgentManagement/ManageAgentUser", "/Admin/AgentManagement/ManageAgentUser?UserId=" + Id + "&AgentId=" + ExtraId1 + "&ParentId=" + ExtraId3, true, "icon-pen").ToHtmlString();
                //link += h.NHyperLink("Cards", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/Card/Index", "/Admin/Card/Index?UserId=" + Id + "&AgentId=" + ExtraId1 + "&ParentId=" + ExtraId3, true, "icon-credit-card").ToHtmlString();
                link += h.NHyperLink("Change Primary User", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1, onclick = "assignRole('" + Id + "','" + ExtraId1 + "','" + ExtraId4 + "')" }, "/Admin/AgentManagement/AssignRole", "#", true, "icon-pencil").ToHtmlString();
                //link += h.NHyperLink("Change Primary User", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/AgentManagement/AssignRole", "/Admin/AgentManagement/AssignRole?UserId=" + Id + "&AgentId=" + ExtraId1 + "&ParentId=" + ExtraId3, true, "icon-pencil").ToHtmlString();
                link += h.NHyperLink("Change Password", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/AgentManagement/ResetPassword", "#", true, "icon-key").ToHtmlString();
                if (ExtraId4.Trim().ToLower() != "y")
                {
                    if (ExtraId2.ToLower() == "y" || ExtraId2.ToLower() == "yes")
                        link += h.NHyperLink("Block", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/AgentManagement/BlockUser", "#", true, "icon-lock2").ToHtmlString();
                    else if (ExtraId2.ToLower() == "n" || ExtraId2.ToLower() == "no")
                        link += h.NHyperLink("Unblock", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/AgentManagement/UnBlockUser", "#", true, "icon-unlocked2").ToHtmlString();
                }
            }
            else if (ControlText == "SubAgentManagement")
            {
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/SubAgentManagement/ManagesubAgent", "/Admin/SubAgentManagement/ManagesubAgent?agentId=" + Id + "&UserName=" + ExtraId1, true, "icon-pen").ToHtmlString();
                link += h.NHyperLink("Credit Limit", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1, onclick = "showpopupmodel('" + Id + "')" }, "/Admin/SubAgentManagement/ExtendCreditLimit", "#", true, "icon-coins").ToHtmlString();
                link += h.NHyperLink("View Wallet Users", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/CustomerManagement/Index", "/Admin/CustomerManagement/Index?ParentId=" + Id, true, "icon-users2").ToHtmlString();

                if (ExtraId2.ToLower() == "y" || ExtraId2.ToLower() == "yes")
                    link += h.NHyperLink("Block", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/subAgentManagement/DisableSubAgent", "#", true, "icon-lock2").ToHtmlString();
                else if (ExtraId2.ToLower() == "n" || ExtraId2.ToLower() == "no")
                    link += h.NHyperLink("Unblock", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/subAgentManagement/EnableSubAgent", "#", true, "icon-unlocked2").ToHtmlString();

            }
            else if (ControlText == "DistributorManagement")
            {
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/DistributorManagement/ManageDistributor", "/Admin/DistributorManagement/ManageDistributor?agentid=" + Id + "&UserName=" + ExtraId1, true, "icon-pen").ToHtmlString();
                link += h.NHyperLink("Extend Credit Limit", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1, onclick = "showpopupmodel('" + Id + "')" }, "/Admin/DistributorManagement/ExtendCreditLimit", "#", true, "icon-coins").ToHtmlString();
                link += h.NHyperLink("View Distributor Users", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/DistributorManagement/ViewDistributorUser", "/Admin/DistributorManagement/ViewDistributorUser?DistId=" + Id, true, "icon-users").ToHtmlString();
                link += h.NHyperLink("View Wallet Users", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/CustomerManagement/Index", "/Admin/CustomerManagement/Index?ParentId=" + Id, true, "icon-users2").ToHtmlString();
                link += h.NHyperLink("View Sub-Distributor", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/SubDistributorManagement/Index", "/Admin/SubDistributorManagement/Index?ParentId=" + Id, true, "icon-users4").ToHtmlString();
                link += h.NHyperLink("View Agent List ", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/AgentManagement/Index", "/Admin/AgentManagement/Index?parent_id=" + Id, true, "icon-users4").ToHtmlString();
                /*
                if (ExtraId2.ToLower() == "y" || ExtraId2.ToLower() == "yes")
                    link += h.NHyperLink("Block Distributor/User", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/DistributorManagement/DisableDistributor", "#", true, "icon-lock2").ToHtmlString();
                else if (ExtraId2.ToLower() == "n" || ExtraId2.ToLower() == "no")
                    link += h.NHyperLink("Unblock Distributor/User", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/DistributorManagement/EnableDistributor", "#", true, "icon-unlocked2").ToHtmlString();
                //link += h.NHyperLink("View Sub-Distributor", new { @class = "dropdown-item", @data_val = Id }, "/Admin/subdistributor/Index", "/Admin/subdistributor/index?DistId=" + Id, true, "icon-pen").ToHtmlString();
              */

            }
            else if (ControlText == "DistributorManagementUser")
            {
                if (!DisableAddEdit)
                    link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/DistributorManagement/ManageDistributorUsers", "/Admin/DistributorManagement/ManageDistributorUsers?UserId=" + Id + "&distid=" + ExtraId1, true, "icon-pen").ToHtmlString();
                //link += h.NHyperLink("Cards", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/Card/Index", "/Admin/Card/Index?UserId=" + Id + "&AgentId=" + ExtraId1, true, "icon-credit-card").ToHtmlString();
                if (!DisableAddEdit)
                    link += h.NHyperLink("Assign Role", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/DistributorManagement/AssignRole", "/Admin/DistributorManagement/AssignRole?UserId=" + Id + "&distid=" + ExtraId1, true, "icon-pencil").ToHtmlString();
                if (!DisableAddEdit)
                {
                    if (ExtraId2.ToLower() == "y" || ExtraId2.ToLower() == "yes")
                        link += h.NHyperLink("Block", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/DistributorManagement/BlockUser", "#", true, "icon-lock2").ToHtmlString();
                    else if (ExtraId2.ToLower() == "n" || ExtraId2.ToLower() == "no")
                        link += h.NHyperLink("Unblock", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/DistributorManagement/UnBlockUser", "#", true, "icon-unlocked2").ToHtmlString();
                }
            }
            else if (ControlText == "SubDistributorManagement")
            {
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/SubDistributorManagement/ManageSubDistributor", "/Admin/SubDistributorManagement/ManageSubDistributor?agent_id=" + Id, true, "icon-pencil").ToHtmlString();
                link += h.NHyperLink("Extend Credit Limit", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1, onclick = "showpopupmodel('" + Id + "')" }, "/Admin/SubDistributorManagement/ExtendCreditLimit", "#", true, "icon-coins").ToHtmlString();
                link += h.NHyperLink("View Sub-Distributor Users", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/SubDistributorManagement/ViewSubDistributorUser", "/Admin/SubDistributorManagement/ViewSubDistributorUser?DistId=" + Id, true, "icon-users").ToHtmlString();
                link += h.NHyperLink("View Wallet Users", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/CustomerManagement/Index", "/Admin/CustomerManagement/Index?ParentId=" + Id, true, "icon-users2").ToHtmlString();
                link += h.NHyperLink("View Agent List ", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/AgentManagement/Index", "/Admin/AgentManagement/Index?parent_id=" + Id, true, "icon-users4").ToHtmlString();
                /*
                if (ExtraId2.ToLower() == "y" || ExtraId2.ToLower() == "yes")
                    link += h.NHyperLink("Block Distributor/User", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/DistributorManagement/DisableDistributor", "#", true, "icon-lock2").ToHtmlString();
                else if (ExtraId2.ToLower() == "n" || ExtraId2.ToLower() == "no")
                    link += h.NHyperLink("Unblock Distributor/User", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/DistributorManagement/EnableDistributor", "#", true, "icon-unlocked2").ToHtmlString();
                //link += h.NHyperLink("View Sub-Distributor", new { @class = "dropdown-item", @data_val = Id }, "/Admin/subdistributor/Index", "/Admin/subdistributor/index?DistId=" + Id, true, "icon-pen").ToHtmlString();
              */

            }
            else if (ControlText == "SubDistributorManagementUser")
            {
                if (!DisableAddEdit)
                    link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/SubDistributorManagement/ManageSubDistributorUsers", "/Admin/SubDistributorManagement/ManageSubDistributorUsers?UserId=" + Id + "&distid=" + ExtraId1, true, "icon-pen").ToHtmlString();
                //link += h.NHyperLink("Cards", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/Card/Index", "/Admin/Card/Index?UserId=" + Id + "&AgentId=" + ExtraId1, true, "icon-credit-card").ToHtmlString();
                if (!DisableAddEdit)
                    link += h.NHyperLink("Assign Role", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/SubDistributorManagement/AssignRole", "/Admin/SubDistributorManagement/AssignRole?UserId=" + Id + "&distid=" + ExtraId1, true, "icon-pencil").ToHtmlString();
                if (!DisableAddEdit)
                {
                    if (ExtraId2.ToLower() == "y" || ExtraId2.ToLower() == "yes")
                        link += h.NHyperLink("Block", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/SubDistributorManagement/BlockUser", "#", true, "icon-lock2").ToHtmlString();
                    else if (ExtraId2.ToLower() == "n" || ExtraId2.ToLower() == "no")
                        link += h.NHyperLink("Unblock", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/SubDistributorManagement/UnBlockUser", "#", true, "icon-unlocked2").ToHtmlString();
                }
            }
            else if (ControlText == "Distributor")
            {
                // link += h.NHyperLink("Manage Distributor", new { @class = "dropdown-item", @data_val = Id }, "/Admin/Distributor/Manage", "/Admin/Distributor/Manage?DistId=" + Id, true, " icon-pencil").ToHtmlString();
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/Distributor/Manage", "/Admin/Distributor/Manage?DistId=" + Id + "&UserName=" + ExtraId1, true, "icon-pen").ToHtmlString();
                link += h.NHyperLink("View Distributor Users", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/Distributor/ViewDistributorUser", "/Admin/Distributor/ViewDistributorUser?DistId=" + Id, true, "icon-users").ToHtmlString();
                link += h.NHyperLink("View Agent Users", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/Agent/Index", "/Admin/Agent/Index?ParentId=" + Id, true, "icon-users4").ToHtmlString();
                link += h.NHyperLink("View Sub-Distributor", new { @class = "dropdown-item", @data_val = Id }, "/Admin/subdistributor/Index", "/Admin/subdistributor/index?DistId=" + Id, true, "icon-users2").ToHtmlString();

            }
            else if (ControlText == "ViewDistributorUser")
            {
                if (!DisableAddEdit)
                    link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/Distributor/ManageDistributorUsers", "/Admin/Distributor/ManageDistributorUsers?UserId=" + Id + "&distid=" + ExtraId1, true, "icon-pen").ToHtmlString();
                link += h.NHyperLink("Cards", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/Card/Index", "/Admin/Card/Index?UserId=" + Id + "&AgentId=" + ExtraId1, true, "icon-credit-card").ToHtmlString();
                if (!DisableAddEdit)
                    link += h.NHyperLink("Assign Role", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/Distributor/AssignRole", "/Admin/Distributor/AssignRole?UserId=" + Id + "&distid=" + ExtraId1, true, "icon-pencil").ToHtmlString();
                if (!DisableAddEdit)
                {
                    if (ExtraId2.ToLower() == "y" || ExtraId2.ToLower() == "yes")
                        link += h.NHyperLink("Block", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/Distributor/BlockUser", "#", true, "icon-lock2").ToHtmlString();
                    else if (ExtraId2.ToLower() == "n" || ExtraId2.ToLower() == "no")
                        link += h.NHyperLink("Unblockd", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/Distributor/UnBlockUser", "#", true, "icon-unlocked2").ToHtmlString();
                }
            }
            else if (ControlText == "Agent")
            {
                // link += h.NHyperLink("Manage Distributor", new { @class = "dropdown-item", @data_val = Id }, "/Admin/Distributor/Manage", "/Admin/Distributor/Manage?DistId=" + Id, true, " icon-pencil").ToHtmlString();
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/Agent/Manage", "/Admin/Agent/Manage?AgentId=" + Id + "&UserName=" + ExtraId1 + "&ParentId=" + ExtraId2, true, "icon-pen").ToHtmlString();
                link += h.NHyperLink("View Agent User", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/Agent/ViewAgentUser", "/Admin/Agent/ViewAgentUser?AgentId=" + Id + "&ParentId=" + ExtraId2, true, "icon-user2").ToHtmlString();
                link += h.NHyperLink("View Sub-Agent", new { @class = "dropdown-item", @data_val = Id }, "/Admin/subAgent/Index", "/Admin/subAgent/index?AgentId=" + Id + "&ParentId=" + ExtraId2, true, "icon-users4").ToHtmlString();

            }

            else if (ControlText == "Agent_Management")
            {
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id }, "/Admin/Distributor/Manage_Agent", "/Admin/Distributor/Manage_Agent?AgentId=" + Id, true, " icon-pen").ToHtmlString();
                link += h.NHyperLink("View Agent User", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/Distributor/View_Agent_User", "/Admin/Distributor/View_Agent_User?AgentId=" + Id, true, "icon-users").ToHtmlString();

            }
            else if (ControlText == "AdminCommissionReport")
            {
                link += h.NHyperLink("Detail", new { @class = "dropdown-item", @data_val = Id }, "/Admin/AdminCommission/ViewReportDetailList", "/Admin/AdminCommission/ViewReportDetailList?ProductId=" + Id + "&CurrentDate=" + ExtraId1, true, " icon-eye4").ToHtmlString();

            }
            else if (ControlText == "View_Agent_User")
            {
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/Distributor/AgentUser", "/Admin/Distributor/AgentUser?userId=" + Id + "&agentId=" + ExtraId1, true, "icon-pen").ToHtmlString();
                link += h.NHyperLink("Assign Role", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/Distributor/AssignAgentRole", "/Admin/Distributor/AssignRole?userId=" + Id + "&agentId=" + ExtraId1, true, "icon-pencil").ToHtmlString();
            }

            else if (ControlText == "Subdistributor")
            {
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id }, "/Admin/subdistributor/Manage", "/Admin/subdistributor/Manage?agentid=" + Id, true, "icon-pen").ToHtmlString();
                link += h.NHyperLink("View users", new { @class = "dropdown-item", @data_val = Id }, "/Admin/subdistributor/ViewUser", "/Admin/subdistributor/ViewUser?agentid=" + Id, true, "icon-users").ToHtmlString();
            }
            else if (ControlText == "subdistributoruser")
            {
                if (!DisableAddEdit)
                {
                    link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id }, "/Admin/subdistributor/Manage", "/Admin/subdistributor/addusers?agentid=" + Id + "&userid=" + ExtraId1, true, "icon-pen").ToHtmlString();

                    if (ExtraId2.ToLower() == "n")
                        link += h.NHyperLink("Unblock", new { @class = "dropdown-item", @data_val1 = Id, @data_val = ExtraId1 }, "/Admin/User/UnBlockUser", "#", true, "icon-unlocked2").ToHtmlString();
                    else
                        link += h.NHyperLink("Block", new { @class = "dropdown-item", @data_val1 = Id, @data_val = ExtraId1 }, "/Admin/User/BlockUser", "#", true, "icon-lock2").ToHtmlString();
                }
            }

            else if (ControlText == "KYC")
            {
                link += h.NHyperLink("Detail", new { @class = "dropdown-item", @data_val = Id }, "/Admin/KYC/Details", "/Admin/KYC/Details?AgentId=" + Id, true, "icon-file-eye2").ToHtmlString();
                if (ExtraId1.ToUpper() != "APPROVED")
                    link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id }, "/Admin/KYC/EditDetails", "/Admin/KYC/EditDetails?AgentId=" + Id, true, "icon-pen").ToHtmlString();
            }
            else if (ControlText == "Services")
            {
                link += h.NHyperLink("Detail", new { @class = "dropdown-item", @data_val = Id }, "/Admin/Services/ServicesDetail", "/Admin/Services/ServicesDetail?id=" + Id, true, "icon-file-eye2").ToHtmlString();
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id }, "/Admin/Services/manageservices", "/Admin/Services/manageservices?id=" + Id, true, "icon-pen").ToHtmlString();
            }
            else if (ControlText == "Gateway")
            {
                link += h.NHyperLink("Detail", new { @class = "dropdown-item", @data_val = Id }, "/Admin/Gateway/GatewayDetail", "/Admin/Gateway/GatewayDetail?GatewayID=" + Id, true, "icon-file-eye2").ToHtmlString();
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id }, "/Admin/Gateway/ManageGateway", "/Admin/Gateway/ManageGateway?GatewayID=" + Id, true, "icon-pen").ToHtmlString();
                link += h.NHyperLink("Product List", new { @class = "dropdown-item", @data_val = Id }, "/Admin/Gateway/GatewayProductList", "/Admin/Gateway/GatewayProductList?GatewayID=" + Id + "&name=" + ExtraId2, true, "icon-list").ToHtmlString();

                link += h.NHyperLink("Gateway Balance", new { @class = "dropdown-item", @data_val = Id, onclick = "showpopupmodel('" + Id + "')" }, "/Admin/Gateway/ManageGatewayBalance", "#", true, "icon-list").ToHtmlString();
            }
            else if (ControlText == "CommissionCategory")
            {
                link += h.NHyperLink("Product List", new { @class = "dropdown-item", @data_val = Id }, "/Admin/Commission/CommissionProductList", "/Admin/Commission/CommissionProductList?categoryid=" + Id, true, "icon-list").ToHtmlString();
                if (ExtraId1 != "1")
                    link += h.NHyperLink("Unblock", new { @class = "dropdown-item", @data_val = Id }, "/Admin/Commission/EnableCommissionCategory", "#", true, "icon-unlocked2").ToHtmlString();
                else
                    link += h.NHyperLink("Block", new { @class = "dropdown-item", @data_val = Id }, "/Admin/Commission/DisableCommissionCategory", "#", true, "icon-lock2").ToHtmlString();

                //link += h.NHyperLink("Enable", new { @class = "dropdown-item", @data_val = Id }, "/Admin/Commission/DisableCommissionCategory", "/Admin/Commission/EnableCommissionCategory?ID=" + Id, true, "icon-unlocked2").ToHtmlString();


            }

            else if (ControlText == "AgentCommissionCategory")
            {
                link += h.NHyperLink("Product List", new { @class = "dropdown-item", @data_val = Id }, "/Admin/AgentCommission/AgentCommissionProductList", "/Admin/AgentCommission/AgentCommissionProductList?categoryid=" + Id, true, "icon-list").ToHtmlString();
                if (ExtraId1 != "1")
                    link += h.NHyperLink("Unblock", new { @class = "dropdown-item", @data_val = Id }, "/Admin/AgentCommission/EnableCommissionCategory", "#", true, "icon-unlocked2").ToHtmlString();
                else
                    link += h.NHyperLink("Block", new { @class = "dropdown-item", @data_val = Id }, "/Admin/AgentCommission/DisableCommissionCategory", "#", true, "icon-lock2").ToHtmlString();


            }
            else if (ControlText == "ClientCommissionCategory")
            {
                link += h.NHyperLink("Product List", new { @class = "dropdown-item", @data_val = Id }, "/Client/ClientCommission/CommissionProductList", "/Client/ClientCommission/CommissionProductList?categoryid=" + Id, true, "icon-list").ToHtmlString();
                if (ExtraId1 != "1")
                    link += h.NHyperLink("Unblock", new { @class = "dropdown-item", @data_val = Id }, "/Client/ClientCommission/EnableCommissionCategory", "#", true, "icon-unlocked2").ToHtmlString();
                else
                    link += h.NHyperLink("Block", new { @class = "dropdown-item", @data_val = Id }, "/Client/ClientCommission/DisableCommissionCategory", "#", true, "icon-lock2").ToHtmlString();

                //link += h.NHyperLink("Enable", new { @class = "dropdown-item", @data_val = Id }, "/Admin/Commission/DisableCommissionCategory", "/Admin/Commission/EnableCommissionCategory?ID=" + Id, true, "icon-unlocked2").ToHtmlString();


            }
            else if (ControlText == "Bank")
            {
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id }, "/Admin/Bank/AddBank", "/Admin/Bank/AddBank?BankID=" + Id, true, "icon-pen").ToHtmlString();
            }
            else if (ControlText == "Role")
            {
                var enc = Base64Decode_URL(Id.ToString());
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = enc }, controlRoleUrl, ControlUrl, true, "icon-pen").ToHtmlString();
                link += h.NHyperLink("Role", new { @class = "dropdown-item", @data_val = enc }, "/Admin/Role/Role", "/Admin/Role/Role?" + enc, true, "icon-pencil").ToHtmlString();
            }
            else if (ControlText == "TransactionReport")
            {
                link += h.NHyperLink("Detail", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/DynamicReport/TransactionReportDetail", "/Admin/DynamicReport/TransactionReportDetail?ID=" + Id + "&TxnId=" + ExtraId1, true, "icon-file-eye2").ToHtmlString();
            }
            else if (ControlText == "PendingTransaction")
            {
                link += h.NHyperLink("Detail", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/DynamicReport/PendingTransactionDetail", "/Admin/DynamicReport/PendingTransactionDetail?ID=" + Id + "&TxnId=" + ExtraId1, true, "icon-file-eye2").ToHtmlString();
            }
            else if (ControlText == "ReportList")
            {
                link += h.NHyperLink("Detail", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/Balance/ReportDetail", "/Admin/Balance/ReportDetail?Id=" + Id + "&ExtraId1=" + ExtraId1, true, "icon-file-eye2").ToHtmlString();
            }
            else if (ControlText == "AgentReportList")
            {
                link += h.NHyperLink("Detail", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/Balance/AgentReportDetail", "/Admin/Balance/AgentReportDetail?Id=" + Id + "&ExtraId1=" + ExtraId1, true, "icon-file-eye2").ToHtmlString();
            }
            else if (ControlText == "UserCard")
            {
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id }, "/Admin/Card/CardUpdate", "/Admin/Card/CardUpdate?UserId=" + Id + "&AgentId=" + ExtraId3 + "&CardNo=" + ExtraId1 + "&CardType=" + ExtraId4, true, "icon-pen").ToHtmlString();
                if (ExtraId2.ToLower() == "y" || ExtraId2.ToLower() == "yes")
                    link += h.NHyperLink("Block", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId3, @data_val2 = ExtraId1 }, "/Admin/Card/CardDisable", "#", true, "icon-lock2").ToHtmlString();
                if (ExtraId2.ToLower() == "n" || ExtraId2.ToLower() == "no")
                    link += h.NHyperLink("Unblock", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId3, @data_val2 = ExtraId1 }, "/Admin/Card/CardEnable", "#", true, "icon-unlocked2").ToHtmlString();
            }
            else if (ControlText == "CardApproval")
            {
                link += h.NHyperLink("Details", new { @class = "dropdown-item", @data_val = Id }, "/Admin/Card/CardApprovalDetail", "/Admin/Card/CardApprovalDetail?reqid=" + Id, true, "icon-file-eye2").ToHtmlString();
            }
            else if (ControlText == "StaticDataType")
            {
                link += h.NHyperLink("Static Data", new { @class = "dropdown-item", @data_val = Id }, "/Admin/staticdata/StaticDataList", "/Admin/staticdata/StaticDataList?SdatatypeID=" + Id, true, "icon-list").ToHtmlString();

            }
            else if (ControlText == "StaticDataList")
            {
                link += h.NHyperLink("Detail", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/StaticData/StaticDataDetail", "/Admin/StaticData/StaticDataDetail?sdatatypeId=" + ExtraId1 + "&sdataid=" + Id, true, "icon-file-eye2").ToHtmlString();
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/StaticData/ManageStaticData", "/Admin/StaticData/ManageStaticData?sdatatypeId=" + ExtraId1 + "&sdataid=" + Id, true, "icon-list").ToHtmlString();
                if (ExtraId2.ToLower() == "n" || ExtraId2.ToLower() == "no")
                {
                    link += h.NHyperLink("Unblock", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/StaticData/DisableSData", "#", true, "icon-unlocked2").ToHtmlString();
                }
                else if (ExtraId2.ToLower() == "y" || ExtraId2.ToLower() == "yes")
                {
                    link += h.NHyperLink("Block", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1, @data_val2 = ExtraId2 }, "/Admin/StaticData/EnableSData", "#", true, "icon-lock2").ToHtmlString();
                }
            }
            else if (ControlText == "StaticData")
            {
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id }, "/Admin/staticdata/ManageStaticData", "/Admin/staticdata/ManageStaticData?SdataId=" + Id + "&sdatatypeId=" + ExtraId1, true, "icon-pen").ToHtmlString();
                if (ExtraId2 == "Y")
                    link += h.NHyperLink("Unblock", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/staticdata/EnableSData", "#", true, "icon-unlocked2").ToHtmlString();
                else
                    link += h.NHyperLink("Block", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/staticdata/DisableSData", "#", true, "icon-lock2").ToHtmlString();

            }
            else if (ControlText == "CustomerManagement")
            {
                link += h.NHyperLink("Cards", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId2 }, "/Admin/Card/Index", "/Admin/Card/Index?AgentId=" + Id + "&UserId=" + ExtraId2, true, "icon-credit-card").ToHtmlString();
                if (ExtraId1.ToLower() == "y" || ExtraId1.ToLower() == "yes")
                {
                    link += h.NHyperLink("Add Balance", new { @class = "dropdown-item", @data_val = Id, onclick = "showAddBalance('" + Id + "')" }, "/Admin/CustomerManagement/AddBalance", "#", true, "icon-cash4").ToHtmlString();
                    link += h.NHyperLink("Block", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1, @data_val2 = ExtraId2 }, "/Admin/CustomerManagement/UserStatusChange", "#", true, "icon-lock2").ToHtmlString();
                    link += h.NHyperLink("Change Password", new { @class = "dropdown-item", @data_val = Id, @data_val2 = ExtraId2 }, "/Admin/CustomerManagement/ResetPassword", "#", true, "icon-key").ToHtmlString();

                }
                if (ExtraId1.ToLower() == "n" || ExtraId1.ToLower() == "no")
                    link += h.NHyperLink("Activate User", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1, @data_val2 = ExtraId2 }, "/Admin/CustomerManagement/UserStatusChange", "#", true, "icon-unlocked2").ToHtmlString();
            }
            else if (ControlText == "MerchantManagement")
            {
                link += h.NHyperLink("Detail", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/MerchantManagement/MerchantDetail", "/Admin/MerchantManagement/MerchantDetail?merchantId=" + Id, true, "icon-file-eye2").ToHtmlString();
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/MerchantManagement/ManageMerchant", "/Admin/MerchantManagement/ManageMerchant?merchantId=" + Id, true, "icon-pen").ToHtmlString();
                if (ExtraId1.ToLower() == "y" || ExtraId1.ToLower() == "yes")
                {
                    link += h.NHyperLink("Merchant Users", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/MerchantManagement/ViewMerchantUser", "/Admin/MerchantManagement/ViewMerchantUser?merchantId=" + Id, true, "icon-users2").ToHtmlString();
                    link += h.NHyperLink("Block", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/MerchantManagement/DisableMerchant", "#", true, "icon-lock2").ToHtmlString();
                }
                else if (ExtraId1.ToLower() == "n" || ExtraId1.ToLower() == "no")
                {
                    link += h.NHyperLink("Unblock", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/MerchantManagement/EnableMerchant", "#", true, "icon-unlocked2").ToHtmlString();
                }
            }
            else if (ControlText == "Merchantuser")
            {
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/MerchantManagement/ManageMerchantUsers", "/Admin/MerchantManagement/ManageMerchantUsers?UserId=" + Id + "&merchantid=" + ExtraId1, true, "icon-pen").ToHtmlString();
                //link += h.NHyperLink("User Detail", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Admin/MerchantManagement/MerchantuserDetail", "/Admin/MerchantManagement/MerchantuserDetail?UserId=" + Id + "&merchantid=" + ExtraId1, true, "icon-file-eye2").ToHtmlString();
                link += h.NHyperLink("Change Password", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1, @data_val2 = ExtraId2 }, "/Admin/MerchantManagement/ResetPassword", "#", true, "icon-key").ToHtmlString();
                if (ExtraId3.ToLower() != "y")
                {
                    if (ExtraId2.ToLower() == "y" || ExtraId2.ToLower() == "yes")
                        link += h.NHyperLink("Block", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1, @data_val2 = ExtraId2 }, "/Admin/MerchantManagement/BlockUser", "#", true, "icon-lock2").ToHtmlString();
                    else if (ExtraId2.ToLower() == "n" || ExtraId2.ToLower() == "no")
                        link += h.NHyperLink("Unblock", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1, @data_val2 = ExtraId2 }, "/Admin/MerchantManagement/UnBlockUser", "#", true, "icon-unlocked2").ToHtmlString();
                }
            }
            else if (ControlText == "Merchantusers")
            {
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Client/Merchant/ManageMerchantUsers", "/Client/Merchant/ManageMerchantUsers?UserId=" + Id + "&merchantid=" + ExtraId1, true, "icon-pen").ToHtmlString();
                //link += h.NHyperLink("User Detail", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Client/Merchant/MerchantuserDetail", "/Client/Merchant/MerchantuserDetail?UserId=" + Id + "&merchantid=" + ExtraId1, true, "icon-file-eye2").ToHtmlString();
                if (ExtraId2.ToLower() == "y" || ExtraId2.ToLower() == "yes")
                    link += h.NHyperLink("Block", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1, @data_val2 = ExtraId2 }, "/Admin/Merchant/BlockUser", "#", true, "icon-lock2").ToHtmlString();
                else if (ExtraId2.ToLower() == "n" || ExtraId2.ToLower() == "no")
                    link += h.NHyperLink("Unblock", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1, @data_val2 = ExtraId2 }, "/Admin/Merchant/UnBlockUser", "#", true, "icon-unlocked2").ToHtmlString();
            }
            else if (ControlText == "ClientSubAgent")
            {
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Client/SubAgent/ManagesubAgent", "/Client/SubAgent/ManagesubAgent?agentId=" + Id + "&UserName=" + ExtraId1, true, "icon-pen").ToHtmlString();
                link += h.NHyperLink("Credit Limit", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1, onclick = "showpopupmodel('" + Id + "')" }, "/Client/SubAgent/ExtendCreditLimit", "#", true, "icon-coins").ToHtmlString();
                if (ExtraId2.ToLower() == "y" || ExtraId2.ToLower() == "yes")
                    link += h.NHyperLink("Block", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Client/SubAgent/DisableSubAgent", "#", true, "icon-lock2").ToHtmlString();
                else if (ExtraId2.ToLower() == "n" || ExtraId2.ToLower() == "no")
                    link += h.NHyperLink("Unblock", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1 }, "/Client/SubAgent/EnableSubAgent", "#", true, "icon-unlocked2").ToHtmlString();
            }
            else if (ControlText == "ClientUserList")
            {
                if (ExtraId1.ToLower() == "y" || ExtraId1.ToLower() == "yes")
                {
                    link += h.NHyperLink("Block", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1, @data_val2 = ExtraId2 }, "/Client/ClientUser/UserStatusChange", "#", true, "icon-lock2").ToHtmlString();
                }
                if (ExtraId1.ToLower() == "n" || ExtraId1.ToLower() == "no")
                    link += h.NHyperLink("Unblock", new { @class = "dropdown-item", @data_val = Id, @data_val1 = ExtraId1, @data_val2 = ExtraId2 }, "/Client/ClientUser/UserStatusChange", "#", true, "icon-unlocked2").ToHtmlString();
            }

            else if (ControlText == "paymentGatewayTransaction")
            {
                link += h.NHyperLink("Detail", new { @class = "dropdown-item", @data_val = Id }, "/Admin/DynamicReport/PaymentGatewayTransactionDetail", "/Admin/DynamicReport/PaymentGatewayTransactionDetail?txnid="+Id, true, "icon-file-eye2").ToHtmlString();
            }
            else
            {
                link += h.NHyperLink("Edit", new { @class = "dropdown-item", @data_val = Id }, controlRoleUrl, ControlUrl, true, "icon-pen").ToHtmlString();
            }



            link += "</div></div></div>";
            return link;
        }

        public static bool HasRight(string ControllerName, string Action)
        {
            if (GetUser() == "admin")
            {
                return true;
            }
            if (string.IsNullOrWhiteSpace(ControllerName))
                return false;

            var user = ReadSession("UserName", "");
            return cgpay.wallet.application.Library.UserMonitor.GetInstance().HasRight(user, ControllerName, Action);
        }
        private static string SaltKey = "";
        static string salt1 = "&%$%#@#";
        static string salt2 = "@$^#%^";

        public static string Base64Encode(string plainText)
        {
            plainText = plainText + SaltKey;
            var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(plainText);
            return System.Convert.ToBase64String(plainTextBytes);
        }
        public static string Base64Decode(string base64EncodedData)
        {
            try
            {
                var base64EncodedBytes = System.Convert.FromBase64String(base64EncodedData);
                base64EncodedData = System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
                base64EncodedData = base64EncodedData.Replace(SaltKey, "");
            }
            catch (Exception e)
            {
                base64EncodedData = "";
            }

            return base64EncodedData;
        }

        public static string Base64Encode_URL(string plainText)
        {
            var enc = "";
            try
            {
                plainText = salt1 + plainText + salt2;
                var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(plainText);
                enc = System.Convert.ToBase64String(plainTextBytes);
                enc = enc.Replace("=", "000");
            }
            catch (Exception)
            {
                enc = "";
            }

            return enc;
        }
        public static string Base64Decode_URL(string base64EncodedData)
        {
            if (base64EncodedData == "Index" || string.IsNullOrWhiteSpace(base64EncodedData))
            {
                return "";
            }
            try
            {
                base64EncodedData = base64EncodedData.Replace("000", "=");
                var base64EncodedBytes = System.Convert.FromBase64String(base64EncodedData);
                base64EncodedData = System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
                base64EncodedData = base64EncodedData.Replace(salt1, "");
                base64EncodedData = base64EncodedData.Replace(salt2, "");
            }
            catch (Exception e)
            {
                base64EncodedData = "";
            }

            return base64EncodedData;
        }
        public static string GetIdFromQuery()
        {
            string getEnc = "";
            if (HttpContext.Current.Request.QueryString.Count > 0)
            {
                getEnc = HttpContext.Current.Request.QueryString[0];
            }

            return StaticData.Base64Decode_URL(getEnc);
        }
        public static CommonDbResponse GetSessionMessage()
        {
            var resp = HttpContext.Current.Session["Msg"] as cgpay.wallet.shared.Models.CommonDbResponse;
            HttpContext.Current.Session.Remove("Msg");
            return resp;
        }
        public static string MakeXmlByComa(string value)
        {
            string val = "<root>";
            foreach (var item in value.Split(','))
            {
                val += @"<row id=""" + item + "\" />";
            }
            val += "</root>";
            return val;
        }
        public static void SetMessageInSession(CommonDbResponse resp)
        {
            HttpContext.Current.Session["Msg"] = resp;
        }
    }
    public class FakeView : IView
    {
        public void Render(ViewContext viewContext, TextWriter writer)
        {
            throw new NotImplementedException();
        }
    }


}