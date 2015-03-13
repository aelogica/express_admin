$(function() {
  datatable = $('#<%= plural_table_name %>-datatable').DataTable({
    'columnDefs': [<% count = 0
  for attribute in attributes
    -%><% if attributes.last != attribute %>
     {'name': '<%= attribute.name %>', 'targets': <%= count %>},<% else %>
     {'name': '<%= attribute.name %>', 'targets': <%= count %>}<% end %><% count = count + 1
     end -%>],
    'processing'   : true,
    'serverSide'   : true,
    'ajax'         : $('#<%= plural_table_name %>-datatable').data('source'),
    'pagingType'   : 'full_numbers',
    'drawCallback' : function(){
      if ($('.paginate_button.current').length == 0 && $('.pagination li').length > 4){
        $('.dataTables_empty').hide()
        setTimeout(function(){
          $('.paginate_button.previous').click()
        }, 50);
      }
    },
    'language'     : {
      'emptyTable'   : 'No records found.',
      'info'         : '_START_-_END_ of _TOTAL_ records',
      'infoEmpty'    : '',
      'infoFiltered' : '',
      'lengthMenu'   : 'Show _MENU_ records',
      'search'       : 'Search',
      'zeroRecords'  : 'No records found.',
      'paginate'     : { 'previous' : 'Prev' }
    }
  }).on( 'preXhr.dt',  function (){
    $('#<%= plural_table_name %>-datatable tbody').css('opacity', '0.7')
  }).on( 'draw.dt',  function (){
     $('#<%= plural_table_name %>-datatable tbody').removeAttr('style')
  });

});
