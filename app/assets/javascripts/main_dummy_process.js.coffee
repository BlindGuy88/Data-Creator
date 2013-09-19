# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
#  codemirror.createdirective("test")
  $("[ui-select2]").select2();

class codemirror
  @createdirective: (name)->
    $("[code_mirror]").each ->
      window.myCodeMirror = CodeMirror.fromTextArea(mytextarea,
        {mode:"text/x-csharp",theme:"ambiance", lineNumbers:true, tabSize:2})
    alert("creating code editor")



