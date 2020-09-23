/*
26/08/2020
Hard-coded jQuery accessibility modifications
These elements are too deeply buried in Java/XSLT hell to be done another way.
*/

$(function() {

    if ($("#aspect_discovery_CommunitySearch_p_search-query").length) {
        $('#aspect_discovery_CommunitySearch_div_community-search').children()[0].remove();

        var label = document.createElement("label");
        label.setAttribute('for', 'aspect_discovery_CommunitySearch_p_search-query');
        label.innerText = 'Search within this community and its collections:';
        $("#aspect_discovery_CommunitySearch_p_search-query").prepend(label);

    }

    if ($("#aspect_discovery_CollectionSearch_p_search-query").length) {
        $('#aspect_discovery_CollectionSearch_div_collection-search').children()[0].remove();

        var label = document.createElement("label");
        label.setAttribute('for', 'aspect_discovery_CollectionSearch_p_search-query');
        label.innerText = 'Search within this collection:';

        $("#aspect_discovery_CollectionSearch_p_search-query").prepend(label);

    }


});