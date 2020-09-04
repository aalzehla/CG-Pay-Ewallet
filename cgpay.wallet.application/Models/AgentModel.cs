using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models
{
    public class AgentModel:Common
    {
        public string AgentType { get; set; }//for Agent ,distributor ,subAgent
        public string AgentID { get; set; }
        public string AgentOperationType { get; set; }
        public string AgentName { get; set; }
        public string AgentPhoneNumber { get; set; }
        public string AgentEmail { get; set; }
        public string AgentWebUrl { get; set; }
        public string AgentRegistrationNumber { get; set; }
        public string AgentPanNo { get; set; }
        public DateTime AgentContractDate { get; set; }
        public string AgentAddress { get; set; }
        public string AgentLatitude { get; set; }
        public string AgentLongitude { get; set; }
        public float AgentCreditLimit { get; set; }
        public float AgentBalance { get; set; }
        public float AgentLogo { get; set; }
        public float AgentRegistrationCertificate { get; set; }
        public float AgentPanCertificate { get; set; }
        //items needed to be added for indivisual document


        //User Information
        public string UserId { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public string ConfirmPassword { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string DOB_AD { get; set; }
        public string DOB_BS { get; set; }
        public string Gender { get; set; }
        public string Occupation { get; set; }
        public string Nationality { get; set; }
        public string PermanentCountry { get; set; }
        public string PermanentProvince { get; set; }
        public string PermanentDistrict { get; set; }
        public string PermanentVDC_Muncipality { get; set; }
        public string PermanentWardNo { get; set; }
        //public string PermanentTole { get; set; }
        public string TemporaryCountry { get; set; }
        public string TemporaryProvince { get; set; }
        public string TemporaryDistrict { get; set; }
        public string TemporaryVDC_Muncipality { get; set; }
        public string TemporaryWardNo { get; set; }
        //public string TemporaryTole { get; set; }

        //Contact Person Detail
        public string ContactPersonName { get; set; }
        public string ContactPersonAddress { get; set; }

        public string ContactPersonNumber { get; set; }
        public string ContactPersonIDtype { get; set; }
        public string ContactPersonIDNumber { get; set; }
        public string ContactPersonIDIssueDate { get; set; }
        public string ContactPersonIDExpiryDate { get; set; }
        public string ContactPersonIDIssueDistrict { get; set; }
    }
}