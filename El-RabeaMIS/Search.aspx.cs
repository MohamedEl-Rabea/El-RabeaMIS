using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace El_RabeaMIS
{
    public partial class Search : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                foreach (DateTime date in LoadClass.GetDistinctDates())
                {
                    ListItem itemYear = new ListItem();
                    itemYear.Text = date.Year.ToString();
                    itemYear.Value = date.Year.ToString();
                    if (!SelectYear.Items.Contains(itemYear))
                    {
                        SelectYear.Items.Add(itemYear);
                    }
                    // select just the current year months
                    if (date.Year == DateTime.Now.Year)
                    {
                        ListItem itemMonth = new ListItem();
                        itemMonth.Text = date.Month.ToString();
                        itemMonth.Value = date.Month.ToString();
                        if (!SelectMonth.Items.Contains(itemMonth))
                        {
                            SelectMonth.Items.Add(itemMonth);
                        }
                    }
                }
                ((Button)((Site)Master).BtnSearchLoads).BackColor = System.Drawing.Color.White;
                ((Button)((Site)Master).BtnSearchLoads).ForeColor = System.Drawing.Color.Black;
                GridViewDayLoads.DataSource = LoadClass.GetAllLoads(new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day));
                GridViewDayLoads.DataBind();
            }
        }

        protected void ImageButtonBackToAddSupplier_Click(object sender, ImageClickEventArgs e)
        {
            PanelLoads.Visible = true;
        }

        [System.Web.Services.WebMethod]
        public static string DeleteItem(int ItemID)
        {
            LoadClass load = new LoadClass();
            load.ID = ItemID.ToString();
            string msg;
            if (!load.Delete_Load(out msg))
            {
                return msg;
            }
            return "Done";
        }
    }
}