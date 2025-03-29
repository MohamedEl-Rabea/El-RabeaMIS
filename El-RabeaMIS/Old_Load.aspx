<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Old_Load.aspx.cs" Inherits="El_RabeaMIS.Old_Load" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="Script/jquery-2.1.4.js"></script>
    <script src="Script/jquery-ui.js"></script>
    <link href="CSS/jquery-ui.css" rel="stylesheet" />
    <script>
        $(document).ready(function () {

            var SearchOption = '';
            var searchTd = 3;// the td in which we compare our typedtext with its text default = 3 matches o carnumber td
            $('#RdBtLstSearchOption').click(function () {
                SearchOption = $(this).find('input:checked').val();
                if (SearchOption == "ClientName") {
                    searchTd = 2;
                    $('#txtSearch').val('').attr('placeholder', 'اسم العميل للبحث . . . . .');
                }
                else {
                    searchTd = 3;
                    $('#txtSearch').val('').attr('placeholder', 'رقم السيارة للبحث . . . . .');
                }
            });

            // allow search on gridview
            var MyGridRows = $('#GridViewDayLoads tr:has(td)');
            $('#txtSearch').keyup(function () {
                var TypedValue = $(this).val().toLowerCase();
                if (TypedValue == '') {
                    MyGridRows.show();
                }
                else {
                    $('#GridViewDayLoads tr:has(td)').each(function () {
                        var TdValue = $(this).find('td:eq('+searchTd+')').text().toLowerCase();
                        if (TdValue.indexOf(TypedValue) > -1) {
                            $(this).show();
                        }
                        else {
                            $(this).hide();
                        }
                    });
                }
            });
        });

        function GetDate() {
            var CurrentDate = new Date();
            var Day = CurrentDate.getDate();
            var Month = CurrentDate.getMonth() + 1;
            var Year = CurrentDate.getFullYear();

            document.getElementById('txtDate').value = Day + ' / ' + Month + ' / ' + Year;
            return false;
        }

        function GetTime(control_ID) {
            var CurrentDate = new Date();
            var hours = CurrentDate.getHours() < 10 ? '0' + CurrentDate.getHours() : CurrentDate.getHours();
            var minutes = CurrentDate.getMinutes() < 10 ? '0' + CurrentDate.getMinutes() : CurrentDate.getMinutes();
            if (hours > 12) {
                document.getElementById(control_ID).value = hours - 12 + ':' + minutes + ' م';
            }
            else {
                document.getElementById(control_ID).value = hours + ':' + minutes + ' ص';
            }
            return false;
        }

        function PrintDivContent(divId) {
            var printContent = document.getElementById(divId);
            var WinPrint = window.open('', '', 'height=auto,width=auto,resizable=1,scrollbars=1,toolbar=1,sta­tus=0');
            WinPrint.document.write('<html><head><title></title>');
            WinPrint.document.write('<link rel="stylesheet" href="CSS/Prices_List_Style_Sheet_1.css" type="text/css" />');
            WinPrint.document.write('</head><body >');
            WinPrint.document.write(printContent.innerHTML);
            WinPrint.document.write('</body></html>');
            WinPrint.document.close();
            function show() {
                if (WinPrint.document.readyState === "complete") {
                    WinPrint.focus();
                    WinPrint.print();
                    WinPrint.close();
                } else {
                    setTimeout(show, 100);
                }
            };
            show();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="placeHolderContentDiv" runat="server">
    <asp:Panel runat="server" ID="PanelLoads">
        <section class="Search_Section">
            <asp:RadioButtonList ID="RdBtLstSearchOption" ClientIDMode="Static" runat="server" RepeatDirection="Horizontal" CssClass="SearchOptions">
                <asp:ListItem Text="رقم السيارة" Value="CarNumber" Selected="True" />
                <asp:ListItem Text="اسم العميل" Value="ClientName" />
            </asp:RadioButtonList>
            <table class="Search_table">
                <tr>
                    <td class="Image_td">
                        <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                            Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClientClick="return false" />
                    </td>
                    <td class="Search_td">
                        <asp:TextBox ID="txtSearch" runat="server" ClientIDMode="Static" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                            placeholder="رقم السيارة للبحث . . . . ."></asp:TextBox>
                    </td>
                </tr>
            </table>
        </section>
        <asp:GridView runat="server" ID="GridViewDayLoads" ClientIDMode="Static" AutoGenerateColumns="False" CssClass="GridStyle">
            <Columns>
                <asp:BoundField DataField="ID" HeaderText="م" />
                <asp:BoundField DataField="LoadDate" HeaderText="التاريخ" DataFormatString="{0:d}" />
                <asp:BoundField DataField="ClientName" HeaderText="اسم العميل" />
                <asp:BoundField DataField="CarNumber" HeaderText="رقم السيارة" />
                <asp:BoundField DataField="LoadType" HeaderText="نوع الحمولة" />
                <asp:BoundField DataField="FilledLoad" HeaderText="الوزن القائم" />
                <asp:BoundField DataField="EmptyLoad" HeaderText="الوزن الفارغ" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="LnkSelect" Text="اختر" runat="server" PostBackUrl='<%# "New_Load.aspx?ID=" + Eval("ID") %>' CausesValidation="false" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle CssClass="headerStyle" />
            <EmptyDataRowStyle CssClass="EmptyStyle" />
            <RowStyle CssClass="Row_Style" />
            <AlternatingRowStyle CssClass="AlternatRowStyle" />
        </asp:GridView>
    </asp:Panel>
</asp:Content>
