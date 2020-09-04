using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.Role
{
    public class RoleCommon:Common
    {
        public string sno { get; set; }
        [Display(Name ="Role Name")]
        [Required(ErrorMessage ="Role Name is Required !!!")]
        public string RoleName { get; set; }
        [Display(Name ="Description")]
        public string RoleType { get; set; }
        public int Id { get; set; }
        public string RoleStatus { get; set; }
      
        public bool IsActive { get; set; }

    }
    public class RoleDetails
    {
        public string Sno { get; set; }
        public string menuGroup { get; set; }
        public string menuName { get; set; }
        public string parentFunctionId { get; set; }
        public string ParentGroup { get; set; }
        public string functionId { get; set; }
        public string functionName { get; set; }
        public int RoleId { get; set; }
        public string AddEdit { get; set; }
        public string DeleteId { get; set; }
        public string ViewId { get; set; }
        public string BreadCum { get; set; }
        public string hasChecked { get; set; }
        public string groupPosition { get; set; }
    }

}
