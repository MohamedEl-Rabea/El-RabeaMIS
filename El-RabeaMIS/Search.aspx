<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Search.aspx.cs" Inherits="El_RabeaMIS.Search" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="Script/jquery-2.1.4.js"></script>
    <script src="Script/jquery-ui.js"></script>
    <link href="CSS/jquery-ui.css" rel="stylesheet" />
    <script>
        $(document).ready(function () {

            var SearchOption = 'CarNumber';
            var searchTd = 3;// the td in which we compare our typedtext with its text default = 3 matches o carnumber td
            $('#RdBtLstSearchOption').click(function () {
                SearchOption = $(this).find('input:checked').val();
                if (SearchOption == "ClientName") {
                    searchTd = 2;
                    $('#txtSearch').val('').attr('placeholder', 'اسم العميل للبحث . . . . .');
                }
                else if (SearchOption == "CarNumber"){
                    searchTd = 3;
                    $('#txtSearch').val('').attr('placeholder', 'رقم السيارة للبحث . . . . .');
                }
                else if (SearchOption == "DriverName") {
                    searchTd = 4;
                    $('#txtSearch').val('').attr('placeholder', 'اسم السائق للبحث . . . . .');
                }
            });

            var YearList = $('#SelectYear');
            var MonthList = $('#SelectMonth');
            var DayList = $('#SelectDay');

            $(document).ajaxStart(function () {
                $("#wait").css("display", "block");
            });
            $(document).ajaxComplete(function () {
                $("#wait").css("display", "none");
            });

            $.fn.exists = function () {
                return this.length > 0;
            }

            // gridview search feature
            $('#txtSearch').keyup(function () {
                var SelectedYear = YearList.find('option:selected').val();
                var SelectedMonth = MonthList.find('option:selected').val();
                var SelectedDay = DayList.find('option:selected').val();
                var TypedValue = $(this).val().toLowerCase();
                var SelectedFullDate;

                // to search on rows based on the selected date
                if (SelectedYear != "-1") {
                    SelectedFullDate = SelectedYear;
                    if (SelectedMonth != "-1") {
                        SelectedFullDate = SelectedMonth.length < 2 ? '0' + SelectedMonth + '/' + SelectedYear : SelectedMonth + '/' + SelectedYear;
                        if (SelectedDay != "-1") {
                            SelectedFullDate = SelectedDay.length < 2 ? '0' + SelectedDay + "/" + SelectedFullDate : SelectedDay + "/" + SelectedFullDate;
                        }
                    }
                }

                if (TypedValue == '') {
                    $('#GridViewDayLoads tr:has(td)').each(function () {
                        if ($(this).find('td:eq(1)').text().indexOf(SelectedFullDate) > -1) {
                            $(this).show();
                        }
                    });
                }
                else {
                    $('#GridViewDayLoads tr:has(td)').each(function () {
                        if ($(this).find('td:eq(1)').text().indexOf(SelectedFullDate) > -1) {
                            var TdValue = $(this).find('td:eq(' + searchTd + ')').text().toLowerCase();
                            if (TdValue.indexOf(TypedValue) > -1) {
                                $(this).show();
                            }
                            else {
                                $(this).hide();
                            }
                        }
                    });
                }
            });

            // select the current date
            var CurrentDate = new Date();
            var Month = CurrentDate.getMonth() + 1;
            var Year = CurrentDate.getFullYear();
            YearList.val(Year);
            MonthList.val(Month);

            if (MonthList.val() == "" || !MonthList.val()) {
                MonthList.val('-1');
            }

            // initialize the day list && // assign event handler to the click event of the delete image
            DayList.empty();
            DayList.append('<option value=' + "-1" + '>' + "اختر اليوم" + '</option>');
            var MyGridRows = $('#GridViewDayLoads tr:has(td)');
            MyGridRows.each(function () {
                var CurrentRow = $(this);
                //populate the days list
                var LoadDate = $(this).find('td:eq(1)').text();
                var day = LoadDate.substr(0, 2);
                day = day.indexOf("0", 0) == 0 ? day.substr(1, 1) : day;//exclude left hand side ZERO. ex: 06 => 6
                if (DayList.find('option[value="' + day + '"]').length == 0) {//check if that day exists before in the day_list.
                    DayList.append('<option value=' + day + '>' + day + '</option>');
                }
                // assign the delete event handler
                CurrentRow.find('#ImageButtonDelete').click(function () {
                    var ItemID = CurrentRow.find('td:eq(0)').text();
                    if (DeleteItem(ItemID)) {
                        CurrentRow.fadeOut('slow');
                    }
                    return false;
                });
            });

            YearList.change(function () {
                var SelectedYear = $(this).find('option:selected').val();
                var SearchValue = $('#txtSearch').val();
                MonthList.empty();
                MonthList.append('<option value=' + "-1" + '>' + "اختر الشهر" + '</option>');
                DayList.empty();
                DayList.append('<option value=' + "-1" + '>' + "اختر اليوم" + '</option>');
                DayList.attr('disabled', true);
                if (SelectedYear != "-1") {
                    MonthList.attr('disabled', false);
                    $.ajax({
                        url: 'GetLoadsDatsService.asmx/GetData',
                        method: 'post',
                        data: { Year: SelectedYear },
                        dataType: 'json',
                        success: function (data) {
                            var LinkElement = MyGridRows.last().find('td:eq(10)').html();
                            var ImgElement = MyGridRows.find('td:eq(11)').html();
                            var Startndex = LinkElement.indexOf('$ctl') + 4;
                            var EndIndex = LinkElement.indexOf('$Lnk');
                            var LastCTLID = LinkElement.substr(Startndex, EndIndex - Startndex);
                            var StartItemIndex = LinkElement.indexOf('?ID=') + 4;// because it returns the indexof -> ? we add 4
                            var EndItemIndex = LinkElement.lastIndexOf('",') > 0 ? LinkElement.lastIndexOf('",') : LinkElement.lastIndexOf('&quot;');
                            var LastItemID = LinkElement.substr(StartItemIndex, EndItemIndex - StartItemIndex);
                            var MyGridBody = $('#GridViewDayLoads tbody');
                            $('#GridViewDayLoads tr:has(td)').remove();
                            $(data).each(function (index, item) {
                                var Loaddate = new Date(parseInt(item.LoadDate.substr(6)));
                                var month = (Loaddate.getMonth() + 1); // cache the month value for multiple usage
                                var FormattedDate = (Loaddate.getDate() < 10 ? '0' + Loaddate.getDate() : Loaddate.getDate()) + "/" + (month < 10 ? '0' + month : month)
                                    + "/" + Loaddate.getFullYear();
                                // build monthes list
                                if (MonthList.find('option[value="' + month + '"]').length == 0) {
                                    MonthList.append('<option value="' + month + '">' + month + '</option>');
                                }
                                var NewCTLID = parseInt(LastCTLID) + 1;
                                LinkElement = LinkElement.replace('$ctl' + LastCTLID, '$ctl' + NewCTLID);
                                LinkElement = LinkElement.replace('?ID=' + LastItemID, '?ID=' + item.ID);
                                LastItemID = item.ID;
                                LastCTLID = NewCTLID;
                                var TailoredRowHTML = $('<tr></tr>');
                                TailoredRowHTML.append('<td>' + item.ID + '</td><td>' + FormattedDate + '</td><td>' + item.ClientName + '</td><td>' + item.CarNumber + '</td><td>' + item.DriverName + '</td>');
                                TailoredRowHTML.append('<td>' + item.LoadType + '</td><td>' + item.LoadCount + '</td><td>' + item.FilledLoad + '</td><td>' + item.EmptyLoad +
                                    '</td><td>' + (parseInt(item.FilledLoad) - parseInt(item.EmptyLoad)) + '</td>');
                                TailoredRowHTML.append('<td>' + LinkElement + '</td>');
                                TailoredRowHTML.append('<td>' + ImgElement + '</td>');
                                var ClassName = index % 2 == 0 ? "Row_Style" : "AlternatRowStyle";
                                TailoredRowHTML.addClass(ClassName);
                                $(TailoredRowHTML).find('#ImageButtonDelete').click(function () {
                                    if (DeleteItem(item.ID)) {
                                        TailoredRowHTML.fadeOut('slow');
                                    }
                                    return false;
                                });
                                if (SearchOption == "CarNumber") {
                                    if (item.CarNumber.indexOf(SearchValue) == -1) {
                                        $(TailoredRowHTML).css('display', 'none');
                                    }
                                }
                                else if (SearchOption == "DriverName") {
                                    if (item.DriverName.indexOf(SearchValue) == -1) {
                                        $(TailoredRowHTML).css('display', 'none');
                                    }
                                }
                                else {
                                    if (item.ClientName.indexOf(SearchValue) == -1) {
                                        $(TailoredRowHTML).css('display', 'none');
                                    }
                                }
                                MyGridBody.append(TailoredRowHTML);
                            });
                        },
                        error: function (Err) {
                            alert(Err.responseText);
                        }
                    })
                }
                else {
                    MonthList.attr('disabled', true);
                }
            });

            MonthList.change(function () {
                DayList.empty();
                DayList.append('<option value=' + "-1" + '>' + "اختر اليوم" + '</option>');
                var SelectedMonth = $(this).find('option:selected').val();
                var SelectedYear = YearList.find('option:selected').val();
                var SearchValue = $('#txtSearch').val();
                var SelectedYearRows = $('#GridViewDayLoads tr:has(td)');
                if (SelectedMonth != "-1") {
                    DayList.attr('disabled', false);
                    // make ajax call rather than using current DOM tree
                    $.ajax({
                        url: 'GetLoadsDatsService.asmx/GetDataByMonth',
                        method: 'post',
                        data: { Year: SelectedYear, Month: SelectedMonth },
                        dataType: 'json',
                        success: function (data) {
                            var LinkElement = SelectedYearRows.last().find('td:eq(10)').html();
                            console.log("Link Element: ", LinkElement);
                            var ImgElement = SelectedYearRows.find('td:eq(11)').html();
                            var Startndex = LinkElement.indexOf('$ctl') + 4;
                            var EndIndex = LinkElement.indexOf('$Lnk');
                            var LastCTLID = LinkElement.substr(Startndex, EndIndex - Startndex);
                            var StartItemIndex = LinkElement.indexOf('?ID=') + 4;
                            var EndItemIndex = LinkElement.lastIndexOf('",') > 0 ? LinkElement.lastIndexOf('",') : LinkElement.lastIndexOf('&quot;');
                            var LastItemID = LinkElement.substr(StartItemIndex, EndItemIndex - StartItemIndex);
                            var MyGridBody = $('#GridViewDayLoads tbody');
                            SelectedYearRows.remove();
                            $(data).each(function (index, item) {
                                var Loaddate = new Date(parseInt(item.LoadDate.substr(6)));
                                var day = Loaddate.getDate(); // cache the day value for multiple usage
                                var FormattedDate = (day < 10 ? '0' + day : day) + "/" + (Loaddate.getMonth() + 1 < 10 ? '0' + (Loaddate.getMonth() + 1) :
                                    Loaddate.getMonth() + 1) + "/" + Loaddate.getFullYear();
                                // build days list
                                if (DayList.find('option[value="' + day + '"]').length == 0) {
                                    DayList.append('<option value="' + day + '">' + day + '</option>');
                                }
                                var NewCTLID = parseInt(LastCTLID) + 1;
                                LinkElement = LinkElement.replace('$ctl' + LastCTLID, '$ctl' + NewCTLID);
                                LinkElement = LinkElement.replace('?ID=' + LastItemID, '?ID=' + item.ID);
                                LastItemID = item.ID;
                                LastCTLID = NewCTLID;
                                var TailoredRowHTML = $('<tr></tr>');
                                TailoredRowHTML.append('<td>' + item.ID + '</td><td>' + FormattedDate + '</td><td>' + item.ClientName + '</td><td>' + item.CarNumber + '</td><td>' + item.DriverName + '</td>');
                                TailoredRowHTML.append('<td>' + item.LoadType + '</td><td>' + item.LoadCount + '</td><td>' + item.FilledLoad + '</td><td>' + item.EmptyLoad +
                                    '</td><td>' + (parseInt(item.FilledLoad) - parseInt(item.EmptyLoad)) + '</td>');
                                TailoredRowHTML.append('<td>' + LinkElement + '</td>');
                                TailoredRowHTML.append('<td>' + ImgElement + '</td>');
                                var ClassName = index % 2 == 0 ? "Row_Style" : "AlternatRowStyle";
                                TailoredRowHTML.addClass(ClassName);
                                $(TailoredRowHTML).find('#ImageButtonDelete').click(function () {
                                    if (DeleteItem(item.ID)) {
                                        TailoredRowHTML.fadeOut('slow');
                                    }
                                    return false;
                                });
                                if (SearchOption == "CarNumber") {
                                    if (item.CarNumber.indexOf(SearchValue) == -1) {
                                        $(TailoredRowHTML).css('display', 'none');
                                    }
                                }
                                else if (SearchOption == "DriverName") {
                                    if (item.DriverName.indexOf(SearchValue) == -1) {
                                        $(TailoredRowHTML).css('display', 'none');
                                    }
                                }
                                else if (SearchOption == "ClientName") {
                                    if (item.ClientName.indexOf(SearchValue) == -1) {
                                        $(TailoredRowHTML).css('display', 'none');
                                    }
                                }
                                MyGridBody.append(TailoredRowHTML);
                            });
                        },
                        error: function (Err) {
                            alert(Err.responseText);
                        }
                    })
                }
                else {
                    DayList.attr('disabled', true);
                }
            });

            DayList.change(function () {
                var SelectedDay = $(this).find('option:selected').val();
                var SelectedMonth = MonthList.find('option:selected').val();
                var SelectedMonthRows = $('#GridViewDayLoads tr:has(td)');
                if (SelectedDay != -1) {
                    SelectedMonthRows.each(function () {
                        var LoadDate = $(this).find('td:eq(1)').text();
                        var TdValue = $(this).find('td:eq(' + searchTd + ')').text().toLowerCase();
                        var SearchValue = $('#txtSearch').val();
                        var day = LoadDate.substr(0, 2);
                        day = day.indexOf("0", 0) == 0 ? day.substr(1, 1) : day;// exclude left hand side ZERO. ex: 06 => 6

                        if (day == SelectedDay && TdValue.indexOf(SearchValue) > -1) {
                            $(this).show();
                        }
                        else {
                            $(this).hide();
                        }
                    });
                }
            });

            function DeleteItem(ItemID) {
                if (confirm('سيتم مسح هذا العنصر نهائيا ....هل تريد المتابعه؟')) {
                    $.ajax({
                        url: 'Search.aspx/DeleteItem',
                        method: 'post',
                        data: '{ ItemID:' + JSON.stringify(ItemID) + '}',
                        contentType: 'application/json;charset:utf-8',
                        dataType: 'json',
                        success: function (data) {
                            if (data.d != "Done") {
                                alert(data.d);
                            }
                        },
                        error: function (Err) {
                            alert(ItemID);
                            alert(Err.responseText);
                        }
                    });
                    return true;
                }
                else {
                    return false;
                }
            }
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
            WinPrint.document.write('<link rel="stylesheet" href="CSS/Prices_List_Style_Sheet.css" type="text/css" />');
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
                <asp:ListItem Text="اسم السائق" Value="DriverName" />
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
        <table style="width: 600px; margin-bottom: 15px;">
            <tr>
                <td>
                    <asp:Label ID="Label1" Text="الملف الخاص لسنة: " runat="server" CssClass="Labels" />
                </td>
                <td>
                    <asp:DropDownList runat="server" ID="SelectYear" ClientIDMode="Static" CssClass="DateChoicesList">
                        <asp:ListItem Text="اختر السنة" Value="-1" />
                    </asp:DropDownList>
                </td>
                <td>
                    <asp:Label ID="Label28" Text="شهر: " runat="server" CssClass="Labels" />
                </td>
                <td>
                    <asp:DropDownList runat="server" ID="SelectMonth" ClientIDMode="Static" CssClass="DateChoicesList">
                        <asp:ListItem Text="اختر الشهر" Value="-1" />
                    </asp:DropDownList>
                </td>
                <td>
                    <asp:Label ID="Label30" Text="يوم: " runat="server" CssClass="Labels" />
                </td>
                <td>
                    <asp:DropDownList runat="server" ID="SelectDay" ClientIDMode="Static" CssClass="DateChoicesList">
                        <asp:ListItem Text="اختر اليوم" Value="-1" />
                    </asp:DropDownList>
                </td>
            </tr>
        </table>
        <asp:GridView runat="server" ID="GridViewDayLoads" ClientIDMode="Static" AutoGenerateColumns="False" CssClass="GridStyle">
            <Columns>
                <asp:BoundField DataField="ID" HeaderText="م" />
                <asp:BoundField DataField="LoadDate" HeaderText="التاريخ" DataFormatString="{0:d}" />
                <asp:BoundField DataField="ClientName" HeaderText="اسم العميل" />
                <asp:BoundField DataField="CarNumber" HeaderText="رقم السيارة" />
                <asp:BoundField DataField="DriverName" HeaderText="اسم السائق" />
                <asp:BoundField DataField="LoadType" HeaderText="نوع الحمولة" />
                <asp:BoundField DataField="LoadCount" HeaderText="العدد" />
                <asp:BoundField DataField="FilledLoad" HeaderText="الوزن القائم" />
                <asp:BoundField DataField="EmptyLoad" HeaderText="الوزن الفارغ" />
                <asp:TemplateField HeaderText="الوزن الصافى">
                    <ItemTemplate>
                        <asp:Label ID="lblNetLoad" Text='<%# Convert.ToInt32(Eval("FilledLoad")) - Convert.ToInt32(Eval("EmptyLoad")) %>' runat="server" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="LnkSelect" ClientIDMode="Static" Text="اختر" runat="server" OnClientClick="$('form').attr('target', 'blank')" PostBackUrl='<%# "~/New_Load.aspx?ID=" + Eval("ID")%>' CausesValidation="false" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:ImageButton ImageUrl="~/Images/Delete.png" ClientIDMode="Static" runat="server" ID="ImageButtonDelete" Width="16" Height="16" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle CssClass="headerStyle" />
            <EmptyDataRowStyle CssClass="EmptyStyle" />
            <RowStyle CssClass="Row_Style" />
            <AlternatingRowStyle CssClass="AlternatRowStyle" />
        </asp:GridView>
    </asp:Panel>
    <div id="wait" style="display: none; width: 90px; height: 100px; position: absolute; top: 50%; left: 45%;">
        <img src="Images/loading.gif" width="64" height="64" />
    </div>
</asp:Content>
