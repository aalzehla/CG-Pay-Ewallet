using cgpay.wallet.application.Library;
using cgpay.wallet.business.BulkUpload;
using cgpay.wallet.shared.Models.BulkUpload;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Areas.Client.Controllers
{
    public class BulkUploadController : Controller
    {

        IBulkUploadBusiness _upload;

        public BulkUploadController(IBulkUploadBusiness upload)
        {
            _upload = upload;
        }
        // GET: Client/BulkUpload
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult BulkUpload(HttpPostedFileBase bulk_upload)
        {
           
            string AgentId = Session["AgentId"].ToString(),
            ActionUser = Session["UserName"].ToString();
            //ApplicationUtilities.GetIP();
            var UploadFilePath = "";
            if (bulk_upload != null)
            {
                var allowedExtensions = new[] { ".csv" };
                var fileName = Path.GetFileName(bulk_upload.FileName);
                String timeStamp = DateTime.Now.ToString();
                var ext = Path.GetExtension(bulk_upload.FileName);
                if (bulk_upload.ContentLength > 5 * 1024 * 1024)//1 MB
                {
                    TempData["msg"] =  "file must be less than 5MB";
                    return RedirectToAction("Index");
                }
                if (allowedExtensions.Contains(ext.ToLower()))
                {
                    string ftpusername = ApplicationUtilities.GetAppConfigValue("ftpusername");
                    string ftppassword = ApplicationUtilities.GetAppConfigValue("ftppassword");
                    string ftpurl = ApplicationUtilities.GetAppConfigValue("ftpurl");
                    string uploadfilelocation = ApplicationUtilities.GetAppConfigValue("uploadfilelocation");

                    string datet = DateTime.Now.ToString().Replace('/', '_').Replace(':', '_').Replace(' ','_');
                    string myfilename = "bulkupload_" + datet + ext;
                    string FileLocation = uploadfilelocation +myfilename;//webconfig file location for db
                    UploadFilePath = Path.Combine(Server.MapPath("~/Content/userupload/bulkupload"), myfilename);
                    //UploadFilePath = Path.Combine(Server.MapPath(FileLocation), myfilename);
                    bulk_upload.SaveAs(UploadFilePath);

                    var client = new WebClient();
                    client.Credentials = new NetworkCredential(ftpusername, ftppassword);//web config username and password ftp
                    client.UploadFile(ftpurl + myfilename, WebRequestMethods.Ftp.UploadFile, UploadFilePath);//web config ftp url

                    var log = _upload.LogFile(myfilename, FileLocation, ActionUser);
                    var resp = _upload.BulkUpload(myfilename, FileLocation, ActionUser, AgentId);
                    //shared.Models.ResponseCode.Success
                    if (resp.Code == 0)
                    {
                        string ProcessId = resp.Extra1;
                        string FileName = resp.Extra2;

                        return RedirectToAction("GetErrorDataList", new { ProcessId = ProcessId, FileName = FileName });



                    }
                    else
                    {
                        TempData["msg"] = resp.Message;
                        return RedirectToAction("Index");
                    }
                }
                else
                {
                    TempData["msg"] = "File Must be .csv";
                    return RedirectToAction("Index");
                }
            }
            
                TempData["msg"] = "File is required";
                
           
            //ViewBag.data = ErrorList;
            //TempData["msg"] = "successfully uploaded";
            return RedirectToAction("Index" );
           
        }

        public ActionResult GetErrorDataList(string ProcessId, string FileName)
        {
            string ActionUser = Session["UserName"].ToString();
            ViewBag.Filename = FileName;
            ViewBag.ProcessId = ProcessId;

            var ErrorList = _upload.GetUploadedDataList(ProcessId, ActionUser, "Bulk_Mobile_TopUp");
            return View(ErrorList);
        }

        public ActionResult GetErrorDetail(string ProcessId)
        {
            //List<BulkUploadCommon> ErrorList = new List<BulkUploadCommon>();
            string ActionUser = Session["UserName"].ToString();

            var ErrorList = _upload.GetUploadedDataDetailList(ProcessId, ActionUser, "Bulk_Mobile_TopUp");
            return View(ErrorList);
        }

        public ActionResult BulkTopUp(string Filename, string ProcessId)
        {
            string ActionUser = Session["UserName"].ToString();
            string AgentId = Session["AgentId"].ToString();
            ViewBag.ProcessId = ProcessId;
            var respList = _upload.BulkTopUp(AgentId, ActionUser, Filename);



            return View(respList);

        }

        public ActionResult ClearBulkData()
        {
            string ActionUser = Session["UserName"].ToString();
            var respList = _upload.ClearUploadedData( ActionUser, "Bulk_Mobile_TopUp");

            if (respList.Code == 0)
            {
                TempData["msg"] = "All data cleared";
            }

            return RedirectToAction("Index");
        }

        public ActionResult BulkTopUpReceiptList(string ProcessId)
        {
            ViewBag.ProcessId = ProcessId;
            var respList = _upload.GetBulkTopUpReceiptList(ProcessId);
            return View(respList);
        }
    }
}