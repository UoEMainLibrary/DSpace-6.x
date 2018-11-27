/*
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
     $(document).ready(function(){
         var protocol = $(location).attr('protocol');
        var hostname = $(location).attr('hostname');
        var pathname = $(location).attr('pathname');
         var url = protocol + "//" + hostname + "/bitstream" + pathname + "/license_url?sequence=2&isAllowed=y";
         var cclink;
        $.get(url, function (response) {
            $("#cc-item-link").attr("href", response);
        });
     });