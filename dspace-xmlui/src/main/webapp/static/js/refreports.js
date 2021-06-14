/*
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
$(function() {
    $("#aspect_administrative_refreport_FindRefItemForm_field_startDate").datepicker({dateFormat: 'yy-mm-dd'});
    $("#aspect_administrative_refreport_FindRefItemForm_field_stopDate").datepicker({dateFormat: 'yy-mm-dd'});

    $( "#aspect_administrative_refreport_FindRefItemForm_field_startDate" ).datepicker();
    $( "#aspect_administrative_refreport_FindRefItemForm_field_stopDate" ).datepicker();
});
