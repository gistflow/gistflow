/*global
  $
  jQuery

jQuery at-username
Autocomplete usernames when typing @
*/
// case insensitive sort

jQuery.fn.extend({
  insertAtCaret: function(myValue){
    return this.each(function(i) {
      if (document.selection) {
        //For browsers like Internet Explorer
        this.focus();
        sel = document.selection.createRange();
        sel.text = myValue;
        this.focus();
      }
      else if (this.selectionStart || this.selectionStart == '0') {
        //For browsers like Firefox and Webkit based
        var startPos = this.selectionStart;
        var endPos = this.selectionEnd;
        var scrollTop = this.scrollTop;
        this.value = this.value.substring(0, startPos)+myValue+this.value.substring(endPos,this.value.length);
        this.focus();
        this.selectionStart = startPos + myValue.length;
        this.selectionEnd = startPos + myValue.length;
        this.scrollTop = scrollTop;
      } else {
        this.value += myValue;
        this.focus();
      }
    })
  }
});

function getCaretPosition(ctrl) {
  var caretPos = 0; // IE Support
  if (document.selection) {
    ctrl.focus();
    var sel = document.selection.createRange();
    sel.moveStart('character', -ctrl.value.length);
    caretPos = sel.text.length;
  }
  // Firefox support
  else if (ctrl.selectionStart || ctrl.selectionStart == '0') caretPos = ctrl.selectionStart;
  return (caretPos);
}

function getPreviousKey(textarea, offset) {
  return (textarea.val().length == 0 || !offset) ? null : textarea.val().substr(offset - 1, offset);
}

$(document).ready(function() {

  var xhrUsernamesList = [];

  var caseInsensitiveSort = function(a, b) {
    var ret = 0;
    a = a.toLowerCase();
    b = b.toLowerCase();
    if (a > b) { ret = 1; }
    if (a < b) { ret = -1; }
    return ret;
  };

  // get usernames (settings.usernameClass) from a container element, removing duplicates
  // returns an array of strings, sorted alphabetically (case insensitive)

  var getUsernameList = function(container, usernameSelector, url) {
    var users = [];

    // get XHR usernames

    if (xhrUsernamesList.length > 0) {
      for (var i = 0; i < xhrUsernamesList.length; i++) {
        if (xhrUsernamesList[i].url === url) {
          users = users.concat(xhrUsernamesList[i].usernames);
          break;
        }
      }
    }

    // search usernames

    if (container) {
      var users_links = container.find(usernameSelector);

      for (var i = 0; i < users_links.length; i++) {
        var curr_user = users_links.eq(i).text();
        var duplicate = false;

        for (var j = 0; j < users.length; j++) {
          if (curr_user === users[j]) {
            duplicate = true;
          }
        }

        if (!duplicate) {
          users.push(curr_user);
        }
      }
    }

    return users.sort(caseInsensitiveSort);
  };

  // search usernames
  // takes a list of usernames and a search term; returns a new list of usernames matching the search term

  var searchUsernameList = function(usernames, search_term) {
    var results = [];

    for (var i = 0; i < usernames.length; i++) {
      var username = usernames[i].toLowerCase();
      search_term = search_term.toLowerCase();
      var result = username.search(search_term);
      if (result >= 0) { // no match returns -1
        results.push(usernames[i]);
      }
    }
    return results;
  };

  // create username autocomplete dropdown
  // takes an array of usernames and creates a username automcompletion HTML element
  // only returns first numResults results

  var createUsernameAutocomplete = function(textarea, container, users, numResults) {
    var username_list = $('<ul id="at-username-autocomplete"></ul>');
        
    username_list.css({
      top: textarea.offset().top + textarea.outerHeight() - 1,
      left: textarea.offset().left
    });

    for (var i = 0; i < users.length; i++) {
      if (i === numResults) {
        break;
      }
      username_list.append($('<li>' + users[i] + '</li>'));
    }

    username_list.find('li:first-child').addClass('active');

    username_list.find('li').click(function() {
      textarea.val(textarea.val().substring(0, textarea.data('ac_start') + 1) + $(this).text() + ' ');
      removeUsernameAutocomplete(container);
      return false;
    });

    return username_list;
  };

  // remove autocomplete dropdown from container

  var removeUsernameAutocomplete = function(container) {
    $('#at-username-autocomplete').remove();
    container.find('textarea').removeClass('autocomplete_active').removeData('ac_start').scrollTop(9999); // scrollTop to fix Firefox bug
    return true;
  };

  // the main bit

  $.fn.atUsername = function(userSettings) {

    // settings

    var settings = {
      containerSelector: '.at-username-container',
      usernameSelector: '.username',
      numResults: 5,
      xhrUsernames: null,
      xhrOnFocus: true
    };

    if (userSettings !== undefined) {
      jQuery.extend(settings, userSettings);
    }

    // load in XHR usernames if not already done

    var loaded = false;

    if (settings.xhrUsernames) {

      var fnLoadXhrUsernames = function() {
        for (var i = 0; i < xhrUsernamesList.length; i++) {
          if (xhrUsernamesList[i].url === settings.xhrUsernames) {
            loaded = true;
          }
        }

        if (!loaded) {
          loaded = true;
          $.get(settings.xhrUsernames, function(data) {
            if (data.usernames) {
              xhrUsernamesList.push({
                url: settings.xhrUsernames,
                usernames: data.usernames
              });
            }
          });
        }
      } // fnLoadXhrUsernames()

      this.on('focus', fnLoadXhrUsernames); // bind to textarea
      if (!settings.xhrOnFocus) {
        fnLoadXhrUsernames();
      }
    }

    this.on('keydown', function(e) {
      var textarea = $(this);      
      var textarea_wrapper = textarea.parent();
      var username_list;
      var ddl;
      
      var usernames_container = $('div' + settings.containerSelector);
      
      if (e.which === 16) { // shift
        return;

      } else if (e.which === 50 && e.shiftKey) { // @
        textarea.addClass('autocomplete_active');

        if (!textarea.data('ac_start')) {
          textarea.data('ac_start', textarea.val().length);
        }
        
        var users = getUsernameList(usernames_container, settings.usernameSelector, settings.xhrUsernames);

        if (users.length === 0) {
          return true;
        }

        /// ----- calculating autocomplete offset -----

        var offset = getCaretPosition(this);
        var last_key = getPreviousKey(textarea, offset);

        if(last_key != null && last_key.match(/\W/) == null) {
          return true;
        }

        var div = '<div id="post_content_dup" class="wordwrap invisible"></div>';
        
        textarea.after(div);

        var $dup_div = $('div#post_content_dup');
        
        var cssToCopy = [
      		'fontFamily',
      		'fontSize',
      		'width',
          'lineHeight'
      	];
        	
        var i = cssToCopy.length;
        while (i--) {
					$dup_div.css(cssToCopy[i], textarea.css(cssToCopy[i]));
				}
        				                
        $dup_div.text(textarea.val());

        var span = '<span class="ins_str">@</span>';
        $dup_div.html($dup_div.text().substr(0, offset) + span + $dup_div.text().substr(offset, $dup_div.text().length));

        $dup_div.html(function(index, old) {
          return old.replace(/\n/g, '<br />')
        });
      
        var $span = $dup_div.find('span.ins_str');

        if ($span.length > 0) {
          var span_offset = $span.offset(),
              dup_div_offset = $dup_div.offset(),
              char_x = span_offset.left - dup_div_offset.left,
              char_y = span_offset.top - dup_div_offset.top;
        }    
        
        $dup_div.remove();
        
        /// ----- END calculating autocomplete offset -----
        
        username_list = createUsernameAutocomplete(textarea, usernames_container, users, settings.numResults);

        if(char_x >= 0 && char_y >= 0) {
          username_list.css({
            top: textarea.offset().top + char_y + 22,
            left: textarea.offset().left + char_x + 22
          });
        }  
        
        ddl = $('#at-username-autocomplete');

        if (ddl.length > 0) {
          ddl.replaceWith(username_list);
        } else {
          $('body').append(username_list);
        }

      } else if (e.which === 38 || e.which === 40 || e.which === 13 || e.which === 32) { // up, down, enter, space
        ddl = $('#at-username-autocomplete');

        if (ddl.length === 0) {
          return;
        }

        var active;

        switch (e.which) {
        case 38: // up
          active = ddl.find('li.active');
          if (active.length > 0) {
            active.removeClass('active').prev().addClass('active');
          } else {
            ddl.find('li:last-child').addClass('active');
          }
          return false;

        case 40: // down
          active = ddl.find('li.active');
          if (active.length > 0) {
            active.removeClass('active').next().addClass('active');
          } else {
            ddl.find('li:first-child').addClass('active');
          }
          return false;

        case 13: // enter
        case 32: // space
          active = ddl.find('li.active');
          if (active.length > 0) {
            textarea.insertAtCaret(active.text());
          }
          removeUsernameAutocomplete(textarea_wrapper);
          return false;
        }

      } else { // any other key
        removeUsernameAutocomplete(textarea_wrapper);
      }

    });
  };

});