/*
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
//$(function() {
    //$("#aspect_statisticsIRUS_StatisticsIRUS_div_main").html("<div id=\"jisc_container_div\"></div>");
    // <script id="irus-api-script" src="https://irus.jisc.ac.uk/js/irus_pr_widget.js?RID=108"></script>



const div = document.createElement("div")
div.setAttribute("id", "jisc_container_div")
const app = document.getElementById("aspect_statisticsIRUS_StatisticsIRUS_div_main").appendChild(div);

/* var ua = window.navigator.userAgent;
alert(ua)
var msie = ua.indexOf("MSIE ");

if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) // If Internet Explorer, return version number
{
	alert("IEEE");
	console.log("ples");
	document.getElementById("jisc_container_div").innerHTML = "NOT COMPATIBLE";
}
else{
	alert("not IE");
}
 */

const container = document.createElement('div');
container.setAttribute('class', 'jisc_container');
const results = document.createElement('div');
results.setAttribute('class', 'jisc_container');
results.id = "resultsTable" ;
const monthNames = ["January", "February", "March", "April", "May", "June","July", "August", "September", "October", "November", "December"];
const itemTypes = ['Art/Design Item', 'Article', 'Audio', 'Book', 'Book Section', 'Conference or Workshop Item - Other', 'Conference Papers/Posters', 'Conference Proceedings', 'Dataset', 'Exam Paper', 'Image', 'Learning Object',
    'Moving Image', 'Music/Musical Composition', 'Other', 'Patent', 'Performance', 'Preprint', 'Report', 'Show/Exhibition', 'Text', 'Thesis or Dissertation', 'Unknown', 'Website', 'Working Paper'];

//Get Repository Identifier parameter from URL in script
var url_string = location.href; //document.getElementById("irus-api-script").src;
var url_script = new URL(url_string);
var param = 30; //url_script.searchParams.get("RID");
var showTable = (url_script.searchParams.get("headerTable") == 'true');
var userStartDate = url_script.searchParams.get("startDate");
var userEndDate = url_script.searchParams.get("endDate");
var onlySummaryTotals = url_script.searchParams.get("summaryTotals")!=null ? url_script.searchParams.get("summaryTotals").toLowerCase() : "show";


var proxyUrl = 'https://cors-anywhere.herokuapp.com/',
    targetUrl = 'https://irus.jisc.ac.uk/api/sushilite/v1_7/GetReport/PR1/?RequestorID=Jisc&RepositoryIdentifier='+param+'&BeginDate=2017-01&EndDate=2017-12&ItemDataType=&Granularity=Monthly'

const newDiv = document.createElement('div');
const divTitle = document.createElement('div');
divTitle.id = "headTitle";
var irusTitle = document.createElement("h2");
var atitle = document.createElement("a");
atitle.id = "hiperlink"
atitle.href = "https://irus.jisc.ac.uk/";
atitle.innerHTML = "IRUS COUNTER R4 Conformant Download Statistics";
irusTitle.id = "irustitle";
irusTitle.appendChild(atitle);
divTitle.appendChild(irusTitle);

app.appendChild(divTitle);
app.appendChild(container);
app.appendChild(results);

function resetTable() {
    document.getElementById('jisc_submit_button').style.visibility = 'hidden';
    var start = new Date(startDate.value);
    var end = new Date(endDate.value);

    if(document.getElementById('monthly').checked){
        granularity = document.getElementById('monthly').value;
    }
    else{
        granularity = document.getElementById('totals').value;
    };

    if (start <= end){
        if (document.getElementById("zeroResults") != null){
            document.getElementById("zeroResults").remove();
        }
        if (document.getElementById("mainTable") != null)
            document.getElementById("mainTable").remove();

        if (document.getElementById("headers") != null)
            document.getElementById("headers").remove();

        createTable(startDate.value,endDate.value,granularity,document.getElementById("itemtype").value);
    }else{
        alert("Invalid Date Range");
        document.getElementById('jisc_submit_button').style.visibility = 'visible';

    }
}

//Configuration Panel Date
var configPanelDate = document.createElement("p");

//StartDate
var startDateLabel = document.createElement("label");
startDateLabel.innerHTML = "Date: ";

var startDate = document.createElement("input");
startDate.name = "startDate";
startDate.id = "startDate";
startDate.type = "month";
startDate.max = "2019-01";
startDate.min = "2010-01";
startDate.defaultValue = "2017-01";

//EndDate
var endDateLabel = document.createElement("label");
endDateLabel.innerHTML = "  to  ";
endDateLabel.paddingLeft = 1000 ;
var endDate = document.createElement("input");
endDate.name = "endDate";
endDate.id = "endDate";
endDate.type = "month";
endDate.max = "2019-01";
endDate.min = "2010-01";
endDate.defaultValue = "2017-12";

//SubmitButton
var submitButton = document.createElement("button");
submitButton.innerHTML = "Submit";
submitButton.onclick = resetTable;
submitButton.id = "jisc_submit_button";

configPanelDate.appendChild(startDateLabel);
configPanelDate.appendChild(startDate);
configPanelDate.appendChild(endDateLabel);
configPanelDate.appendChild(endDate);


//Configuration Panel DataType
var dataType = document.createElement("label");
dataType.innerHTML = "Type: ";
dataType.style.marginLeft = "7px";

//Create Type Dropdown
var typeDrop = document.createElement("select")
typeDrop.id = "itemtype";
var newOption = new Option();
newOption.text = "All";
newOption.value = "";
typeDrop.options.add(newOption);
for (var i = 0; i < itemTypes.length; i++) {
    var newOption = new Option();
    newOption.text = itemTypes[i]
    newOption.value = itemTypes[i]
    typeDrop.options.add(newOption);
}
//Append Item type to the same line as Dates
configPanelDate.appendChild(dataType);
configPanelDate.appendChild(typeDrop);

//Create Granularity
var configPanelGran = document.createElement("p");
var granLabel = document.createElement("label");
granLabel.innerHTML = "Granularity: ";
var monthlyLabel = document.createElement("label");
monthlyLabel.innerHTML = "Monthly"
var totalsLabel = document.createElement("label");
totalsLabel.innerHTML = "Totals"
var radioInput = document.createElement('input');
radioInput.type = "radio";
radioInput.value = "Monthly";
radioInput.name = "granularity"
radioInput.id = "monthly";
radioInput.checked = true;
var radioInput2 = document.createElement('input');
radioInput2.type = "radio";
radioInput2.value = "Totals";
radioInput2.name = "granularity"
radioInput2.id = "totals";

//Create Summary Totals Checkbox
var configSumTotalsCheckBox = document.createElement("p");

var sumTotalsLabelTitle = document.createElement("label");
sumTotalsLabelTitle.innerHTML = "Summary Totals: "

var sumTotalsLabel = document.createElement("label");
sumTotalsLabel.innerHTML = "Show"
var smTotalsCheckBox1 = document.createElement('input');
smTotalsCheckBox1.type = "radio";
smTotalsCheckBox1.value = "Show";
smTotalsCheckBox1.name = "smtotals"
smTotalsCheckBox1.id = "jisc_summaryTotalsID_show"
smTotalsCheckBox1.checked=true;

var sumTotalsLabel2 = document.createElement("label");
sumTotalsLabel2.innerHTML = "Hide"
var smTotalsCheckBox2 = document.createElement('input');
smTotalsCheckBox2.type = "radio";
smTotalsCheckBox2.value = "hide";
smTotalsCheckBox2.name = "smtotals"
smTotalsCheckBox2.id = "jisc_summaryTotalsID_hide"

var sumTotalsLabel3 = document.createElement("label");
sumTotalsLabel3.innerHTML = "Only"
var smTotalsCheckBox3 = document.createElement('input');
smTotalsCheckBox3.type = "radio";
smTotalsCheckBox3.value = "Only";
smTotalsCheckBox3.name = "smtotals"
smTotalsCheckBox3.id = "jisc_summaryTotalsID_only"

if (onlySummaryTotals =="hide") {
    smTotalsCheckBox2.checked = true;
}

if (onlySummaryTotals =="only") {
    smTotalsCheckBox3.checked = true;
}

//Create Header Table Checkbox
var headerTableCheckBox = document.createElement("p");

var headerTableLabelTitle = document.createElement("label");
headerTableLabelTitle.innerHTML = "Header Table: "

var headerTableLabel = document.createElement("label");
headerTableLabel.innerHTML = "Show"
var headerTableCheckBox1 = document.createElement('input');
headerTableCheckBox1.type = "radio";
headerTableCheckBox1.value = true;
headerTableCheckBox1.name = "headerTableCheck"
headerTableCheckBox1.id = "jisc_headerTableCheckBox_show"

var headerTableLabel2 = document.createElement("label");
headerTableLabel2.innerHTML = "Hide"
var headerTableCheckBox2 = document.createElement('input');
headerTableCheckBox2.type = "radio";
headerTableCheckBox2.value = false;
headerTableCheckBox2.name = "headerTableCheck"
headerTableCheckBox2.id = "jisc_headerTableCheckBox_hide"

if (!showTable){
    headerTableCheckBox2.checked = true
}else{
    headerTableCheckBox1.checked = true
}

headerTableLabel.appendChild(headerTableCheckBox1)
headerTableLabel2.appendChild(headerTableCheckBox2)

monthlyLabel.appendChild(radioInput);
totalsLabel.appendChild(radioInput2);
sumTotalsLabel.appendChild(smTotalsCheckBox1);
sumTotalsLabel2.appendChild(smTotalsCheckBox2);
sumTotalsLabel3.appendChild(smTotalsCheckBox3);


configPanelGran.appendChild(granLabel);
configPanelGran.appendChild(monthlyLabel);
configPanelGran.appendChild(totalsLabel);
configSumTotalsCheckBox.appendChild(sumTotalsLabelTitle);
configSumTotalsCheckBox.appendChild(sumTotalsLabel);
configSumTotalsCheckBox.appendChild(sumTotalsLabel2);
configSumTotalsCheckBox.appendChild(sumTotalsLabel3);

headerTableCheckBox.appendChild(headerTableLabelTitle)
headerTableCheckBox.appendChild(headerTableLabel)
headerTableCheckBox.appendChild(headerTableLabel2)


//SubmitButton
var configPanelSubmit = document.createElement("p");
configPanelSubmit.appendChild(submitButton);

//Append Everything to headers div
newDiv.appendChild(configPanelDate);
newDiv.appendChild(configPanelGran);
newDiv.appendChild(configSumTotalsCheckBox);
newDiv.appendChild(headerTableCheckBox);
newDiv.appendChild(configPanelSubmit);

newDiv.id = "jisc_div_form";

var loading = document.createElement("div");
loading.classList.add("loader");
loading.id = "jiscloader";
document.body.appendChild(loading);


function createTable(beginDate,endDate,granularity,itemType){
    loading.style.display="block";

    var targetUrl = 'https://irus.jisc.ac.uk/api/sushilite/v1_7/GetReport/PR1/?RequestorID=Jisc&RepositoryIdentifier='+param+'&BeginDate='+beginDate+'&EndDate='+endDate+'&ItemDataType='+itemType+'&Granularity='+granularity;
    fetch(proxyUrl + targetUrl)
        .then(blob => blob.json())
.then(data => {

        var requestor = data['ReportResponse']['Requestor']['ID']
        var periodicity = "Periodicity : "+data['ReportResponse']['ReportDefinition']['Filters']['ReportAttribute'][0]["Value"]

        var node = document.createElement("table");
    node.id="headers";
    var tblBody = document.createElement("tbody");
    //node.style.visibility = "hidden";
    //node.onclick = function () { this.style.visibility = "hidden"}

    //Headers
    for (var j = 0; j <= Object.keys(data['ReportResponse']['Report']['Report']).length-3; j++) {
        var row = document.createElement("tr");
        var key = document.createElement("td");
        var value = document.createElement("td");
        var cellText2 = document.createTextNode(Object.keys(data['ReportResponse']['Report']['Report'])[j].replace("@", ""));
        var cellText5 = document.createTextNode(data['ReportResponse']['Report']['Report'][Object.keys(data['ReportResponse']['Report']['Report'])[j]]);
        if(cellText2.nodeValue !="Version"){
            key.appendChild(cellText2);
            value.appendChild(cellText5);
            row.appendChild(key);
            row.appendChild(value);
            tblBody.appendChild(row);
        }
    }

    //Get Data Status
    var req = document.createElement("tr");
    req.appendChild(document.createElement("td")).appendChild(document.createTextNode("Data Status"));
    if (data['ReportResponse']['Exception'] != null){
        req.appendChild(document.createElement("td")).appendChild(document.createTextNode(data['ReportResponse']['Exception'][0]['Data']));
    }
    else {
        req.appendChild(document.createElement("td")).appendChild(document.createTextNode("Valid"));
    };

    tblBody.appendChild(req);

    if (headerTableCheckBox1.checked){
        node.appendChild(tblBody);
        //Append headers
        container.append(node);
    }

    container.append(newDiv);

    //Results Dates
    if (data['ReportResponse']['Report']['Report']['Customer']['ReportItems'] != null){
        var itemPlatform = data['ReportResponse']['Report']['Report']['Customer']['ReportItems'][0]['ItemPlatform'];
        var resultsTable = document.createElement("table");
        resultsTable.id = "mainTable";
        var resultsBody = document.createElement("tbody");
        var firstrow = document.createElement("tr");
        var td = document.createElement("th");
        if (document.getElementById("itemtype").value == ""){
            var firstrowText = document.createTextNode(itemPlatform+" - All");
        }
        else{
            var firstrowText = document.createTextNode(itemPlatform+" - "+document.getElementById("itemtype").value);
        }

        var dates = document.createElement("tr");
        var b = document.createElement("td");
        b.appendChild(document.createTextNode(""));
        dates.appendChild(b);
        for (var j = 0; j <= Object.keys(data['ReportResponse']['Report']['Report']['Customer']['ReportItems'][0]['ItemPerformance']).length-1; j++) {
            if (document.getElementById('monthly').checked){
                var begin = data['ReportResponse']['Report']['Report']['Customer']['ReportItems'][0]['ItemPerformance'][j]['Period']['Begin'];
                var month = monthNames[parseInt(begin.split("-")[1]-1)] +" "+ begin.split("-")[0];
                var b = document.createElement("td");
                b.appendChild(document.createTextNode(month));
            }else{
                var begin = data['ReportResponse']['Report']['Report']['Customer']['ReportItems'][0]['ItemPerformance'][j]['Period']['Begin'];
                var end = data['ReportResponse']['Report']['Report']['Customer']['ReportItems'][0]['ItemPerformance'][j]['Period']['End'];
                var monthBegin = monthNames[parseInt(begin.split("-")[1]-1)] +" "+ begin.split("-")[0];
                var monthEnd = monthNames[parseInt(end.split("-")[1]-1)] +" "+ end.split("-")[0];
                var b = document.createElement("td");
                b.appendChild(document.createTextNode(monthBegin+" - "+monthEnd));
            }
            dates.appendChild(b);

        }

        firstrow.appendChild(firstrowText);
        td.appendChild(firstrow);
        resultsBody.appendChild(td);
        td.colSpan = j+1
        resultsBody.appendChild(dates);
    };


    //Results Counts
    if (data['ReportResponse']['Report']['Report']['Customer']['ReportItems'] != null){
        var itemTypes = data['ReportResponse']['Report']['Report']['Customer']['ReportItems'].length
        for (var j = 0; j <= Object.keys(data['ReportResponse']['Report']['Report']['Customer']['ReportItems']).length-1; j++) {
            var counts = document.createElement("tr");
            if (data['ReportResponse']['Report']['Report']['Customer']['ReportItems'] != null){
                var nr2 = document.createElement("td");
                nr2.appendChild(document.createTextNode(data['ReportResponse']['Report']['Report']['Customer']['ReportItems'][j]['ItemDataType']));
                counts.appendChild(nr2)
                for (var i = 0; i <= data['ReportResponse']['Report']['Report']['Customer']['ReportItems'][j]["ItemPerformance"].length-1; i++) {
                    var count = data['ReportResponse']['Report']['Report']['Customer']['ReportItems'][j]["ItemPerformance"][i]['Instance']['Count'] ;
                    var nr = document.createElement("td");
                    nr.appendChild(document.createTextNode(parseInt(count).toLocaleString()));
                    counts.appendChild(nr);
                }
                resultsBody.appendChild(counts);

            };

        };

        resultsTable.appendChild(resultsBody);
        results.append(resultsTable);

        //Create Summary Totals
        if ( ! document.getElementById("jisc_summaryTotalsID_hide").checked){
            var tableCountCol = document.getElementById("mainTable");
            var sumTotalHeader = document.createElement("td");
            sumTotalHeader.appendChild(document.createTextNode("Summary Totals"))
            var summaryTotals = document.createElement("tr")
            summaryTotals.appendChild(sumTotalHeader);

            for (j = 1; j < tableCountCol.rows[0].cells.length; j++){

                var sumVal = 0;

                for(var i = 1; i < tableCountCol.rows.length; i++)
                {
                    sumVal = sumVal + parseInt(tableCountCol.rows[i].cells[j].innerHTML.replace(",",""));

                }
                var nr = document.createElement("td");
                nr.appendChild(document.createTextNode(parseInt(sumVal).toLocaleString()));
                summaryTotals.appendChild(nr);
            }

            resultsBody.insertBefore(summaryTotals, resultsBody.children[2]);

            if(document.getElementById("jisc_summaryTotalsID_only").checked){
                for (j = tableCountCol.rows.length-1; j >= 2; j--){
                    document.getElementById("mainTable").deleteRow(j);
                }
            }
        }

    }
    else{
        var noResults = document.createElement("p")
        if (document.getElementById("itemtype").value != ""){
            noResults.innerHTML = "NO RESULTS FOUND FOR: "+document.getElementById("itemtype").value
        }
        else{
            noResults.innerHTML = "NO RESULTS FOUND";
        }
        noResults.id="zeroResults";
        noResults.align="center";
        results.append(noResults);

    }

    document.getElementById('jisc_submit_button').style.visibility = 'visible';
    loading.style.display="none";
    return data;
})
.catch(e => {
        console.log(e);
    return e;
});
};

const Http = new  XMLHttpRequest();
const dataAvailabilityUrl = 'https://irus.jisc.ac.uk/api/sushilite/v1_7/Status/?RepositoryIdentifier='+param;
Http.open("GET", proxyUrl+dataAvailabilityUrl, true);
Http.responseType = 'text';
Http.onload = function () {
    if (Http.readyState === Http.DONE) {
        if (Http.status === 200) {

            if (userStartDate != null && userEndDate !=null){
                createTable(userStartDate,userEndDate,"Monthly","");
                startDate.defaultValue = userStartDate;
                endDate.defaultValue = userEndDate;
            }
            else if (userStartDate == null && userEndDate !=null){ //startDate not provided
                var userStartDateNew = new Date(userEndDate)
                userStartDateNew.setMonth(userStartDateNew.getMonth() - 11)
                var correctMonth = (parseInt(userStartDateNew.getMonth())+1).toString()
                if (correctMonth.length >1){
                    var userStartDateNew = userStartDateNew.getFullYear() +"-"+correctMonth
                    createTable(userStartDateNew,userEndDate,"Monthly","");
                }else{
                    var userStartDateNew = userStartDateNew.getFullYear() +"-0"+correctMonth
                    createTable(userStartDateNew,userEndDate,"Monthly","");
                }

                startDate.defaultValue = userStartDateNew;
                endDate.defaultValue = userEndDate;

            }
            else if (userStartDate != null && userEndDate == null){ //endDate not provided
                var userEndDateNew = new Date(userStartDate);
                userEndDateNew.setMonth(userEndDateNew.getMonth() + 11);
                var correctMonth = (parseInt(userEndDateNew.getMonth())+1).toString()
                if (correctMonth.length >1){
                    var userEndDateNew = userEndDateNew.getFullYear() +"-"+correctMonth
                    createTable(userStartDate,userEndDateNew,"Monthly","");
                }else{
                    var userEndDateNew = userEndDateNew.getFullYear() +"-0"+correctMonth
                    createTable(userStartDate,userEndDateNew,"Monthly","");
                }


                startDate.defaultValue = userStartDate;
                endDate.defaultValue = userEndDateNew;

            }
            else{
                var latest = JSON.parse(Http.responseText)['Status'][0]['Latest_End_Date'] ;
                var earliest = new Date(JSON.parse(Http.responseText)['Status'][0]['Latest_End_Date']);
                earliest.setMonth(earliest.getMonth() - 10);

                if (earliest.getMonth().toString().length >1){
                    var earliest = earliest.getFullYear() +"-"+earliest.getMonth()
                    createTable(earliest,latest,"Monthly","");
                    startDate.defaultValue = earliest;
                }else{
                    var earliest = earliest.getFullYear() +"-0"+earliest.getMonth()
                    createTable(earliest,latest,"Monthly","");
                }


                startDate.defaultValue = earliest;
                endDate.defaultValue = latest;
            }

        }
    }
};

Http.send(null);

//});