// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
// require turbolinks
//= require jquery.metadata
//= require jquery.tablesorter
// require_tree .
//= require ./uikit/uikit
// require_tree ./uikit/components


$(function(){
    // For projects/index.html.erb
    $('#sortable_table').tablesorter();


    // For exporters/show.html.erb
    $('#sortable_table_exporter').tablesorter({
        headers: {
            0: {sorter: false}
        }
    });


    // For labels/index.html.erb
    $('.label_sort tbody').sortable({
        handle: ".label_sort_handle",
        update: function(event, ui) {
            $(this).find("input[type=hidden][id*=order]").each(function(i){
                $(this).val(i);
            });
        }
    });
});