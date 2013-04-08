//= require jquery
//= require jquery_ujs
//= require underscore
//= require layout
//= require cache
//= require codemirror

$(document).ready(function(){
  var myCodeMirror = CodeMirror.fromTextArea($('textarea#content')[0], {
    tabSize: 2,
    mode: 'gfm',
    lineNumbers: false,
    theme: 'default'
  })
})
