using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;
namespace El_RabeaMIS
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        public Control BtnNewLoad
        {
            get 
            {
                return this.btnNewLoad;
            }
        }

        public Control BtnOldLoad
        {
            get
            {
                return this.btnOldLoad;
            }
        }

        public Control BtnInventoryLoad
        {
            get
            {
                return this.BtnInventory;
            }
        }

        public Control BtnSearchLoads
        {
            get
            {
                return this.BtnSearch;
            }
        }

        protected void btnNewLoad_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/New_Load.aspx");
        }

        protected void btnOldLoad_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Old_Load.aspx");
        }

        protected void BtnDelete_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Delete_Load.aspx");
        }

        protected void BtnInventory_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Inventory.aspx");
        }

        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Search.aspx");
        }
    }
}