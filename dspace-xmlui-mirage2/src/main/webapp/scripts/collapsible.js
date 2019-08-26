/*
 * Collapsible javascript script for
 * sidebar navigation
 */
jQuery("#ds-options div.ds-option-set, #dspace-options div.ds-option-set").not("#aspect_viewArtifacts_Navigation_list_browse,#aspect_discovery_Navigation_list_discovery,#ds-search-option").addClass("gu-hide");

jQuery("#ds-options h3,#dspace-options h3").click(function(){

    jQuery(this).next("div.ds-option-set:first").toggleClass("gu-hide");

});

(function($, undefined){
    $(function(){
        $('#aspect_discovery_Navigation_list_discovery ul li h2').click(function(event){
            var elem = $(this).next();
            if (elem.is('ul')){
                event.preventDefault();
                $('#menu ul:visible').not(elem).slideUp();
                elem.slideToggle();
            }
        });
    });
})(jQuery);

(function() {
    $('.btn-primary, .list-group-item.active').click(document.getElementById('list-group-item.ds-option').display = 'block')
    }
);