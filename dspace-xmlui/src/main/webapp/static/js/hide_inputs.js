/*

Hard-coded way to
 * hide citation on page 1
 * hide all the input elements on page 2 except the first two.
 * change header content on page 2 to "REF Information"

*/

var input_append = "#aspect_submission_StepTransformer_field_";

var inputs_omitted = ["refterms_technicalException", "refterms_technicalExceptionExplanation", "refterms_version",
"refterms_dateDeposit_year", "refterms_dateFCD_year", "refterms_panel", "refterms_depositException",
"refterms_depositExceptionExplanation", "rioxxterms_publicationdate_year", "refterms_dateFCA_month",
"refterms_dateEmbargoEnd_month", "refterms_dateFreeToRead_month", "refterms_dateFreeToDownload_month",
"refterms_dateToSearch_month", "refterms_accessException", "refterms_accessExceptionExplanation",
"refterms_exceptionFreeText", "dc_identifier_citation"];


for(var i = 0; i < inputs_omitted.length; i++)  {
    if($(input_append + inputs_omitted[i]).length) {
        $(input_append + inputs_omitted[i]).parents('div.ds-form-item.row').hide();

        if(inputs_omitted[i] != "dc_identifier_citation" && $(".ds-div-head.page-header.first-page-header").text().indexOf("Item submission") > -1)  {
            $(".ds-div-head.page-header.first-page-header").text("REF Information");

        }

    }
}