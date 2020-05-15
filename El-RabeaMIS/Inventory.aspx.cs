using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace El_RabeaMIS
{
    public partial class Inventory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtDate.Text = DateTime.Now.ToShortDateString();
                ((Button)((Site)Master).BtnInventoryLoad).BackColor = System.Drawing.Color.White;
                ((Button)((Site)Master).BtnInventoryLoad).ForeColor = System.Drawing.Color.Black;
                GridViewDayLoads.DataSource = LoadClass.GetLoadsByDate(DateTime.Now);
                GridViewDayLoads.DataBind();
            }
        }

        protected void BtnGetInventory_Click(object sender, EventArgs e)
        {
            GridViewDayLoads.DataSource = LoadClass.GetLoadsByDate(Convert.ToDateTime(txtDate.Text));
            GridViewDayLoads.DataBind();
        }
        
        [System.Web.Services.WebMethod]
        public static string UpdatePayStatus(int LoadID)
        {
            LoadClass load = new LoadClass();
            load.ID = LoadID.ToString();
            string msg;
            if (!load.Update_Load_Status(out msg))
            {
                return msg;
            }
            return "Done";
        }

    }
}