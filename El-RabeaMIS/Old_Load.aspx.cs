using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace El_RabeaMIS
{
    public partial class Old_Load : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ((Button)((Site)Master).BtnOldLoad).BackColor = System.Drawing.Color.White;
                ((Button)((Site)Master).BtnOldLoad).ForeColor = System.Drawing.Color.Black;
                GridViewDayLoads.DataSource = LoadClass.GetLoadsByDate(DateTime.Now);
                GridViewDayLoads.DataBind();
            }
        }      
    }
}