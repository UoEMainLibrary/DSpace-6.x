
/*

16/07/2020

Hard-coded jQuery accessibility modifications
These elements are too deeply buried in Java/XSLT hell to be done another way.

*/

$(function() {

    if ($("#aspect_artifactbrowser_ConfigurableBrowse_field_year").length) {
        $("#aspect_artifactbrowser_ConfigurableBrowse_field_year").attr("aria-label", "Choose Year dropdown");

    }

    if ($(".alphabet-select").length) {
        $(".alphabet-select").attr("aria-label", "Select by letter");

    }


});