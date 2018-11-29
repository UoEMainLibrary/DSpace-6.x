/*
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */

 // Note - this script is no longer used and should be deleted at some stage. Robin 1/3/16.

     $(document).ready(function(){
        /*var protocol = $(location).attr('protocol');
        var hostname = $(location).attr('hostname');
        var pathname = $(location).attr('pathname');
        var url = protocol + "//" + hostname + "/bitstream" + pathname + "/license_url?sequence=2&isAllowed=y";
        var cclink;*/

        $.get($("#cc-item-link").attr("href"), function (response) {
            $("#cc-item-link").attr("href", response);
        });

        var delay = 2700000;   // 45 minutes in milliseconds
        var loginurl = protocol + "//" + hostname + "/login";

        // refresh to login screen after 45 minutes
        setTimeout(function(){ window.location = loginurl; }, delay);

        $('.page-header').each(function() {
            $(this).insertBefore($(this).parent().find('.file-heading'));
        });

     });