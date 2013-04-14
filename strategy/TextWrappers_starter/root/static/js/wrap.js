$('button').on('click', function() {

  var text = $('textarea').val();
  var col  = $('#col').val();
  var algorithm = $('#algorithm').val();

  var params = { text: text, columns: col, algorithm: algorithm};
  $.get('/textwrap/wrap', params, function(text) {
    text = text.replace(/\n/g, "<br />");
    $('p.result').html( text );
  });
});
