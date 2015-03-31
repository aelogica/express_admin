$(function() {
  datatable = $('#agents-datatable').DataTable({
    'columnDefs': [
     {'name': 'last_name', 'targets': 0},
     {'name': 'first_name', 'targets': 1}],
    'processing'   : true,
    'serverSide'   : true,
    'ajax'         : $('#agents-datatable').data('source'),
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
    $('#agents-datatable tbody').css('opacity', '0.7')
  }).on( 'draw.dt',  function (){
     $('#agents-datatable tbody').removeAttr('style')
  });

});
