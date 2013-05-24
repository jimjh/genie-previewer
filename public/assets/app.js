// Generated by CoffeeScript 1.4.0

/*
verify.js
http://github.com/jimjh/genie-game
===
Copyright (c) 2012-2013 Jiunn Haur Lim, Carnegie Mellon University
*/


(function() {
  var Problem, genie, init_pagination, init_scroll,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  genie = (typeof exports !== "undefined" && exports !== null) && this || (this.genie = {});

  Problem = (function() {

    function Problem(form, answer) {
      this.answer = answer;
      this.submit = __bind(this.submit, this);

      this.form = $(form);
      if (this.answer != null) {
        this.preload();
      }
    }

    Problem.prototype.preload = function() {
      var cell, i, input, j, row, _ref, _results;
      switch ($.type(this.answer)) {
        case 'string':
        case 'number':
          this.form.find("input[name='answer']:not([type='radio'])").val(this.answer);
          return this.form.find("input[name='answer'][type='radio'][value='" + this.answer + "']").attr('checked', 'checked');
        default:
          _ref = this.answer;
          _results = [];
          for (i in _ref) {
            row = _ref[i];
            _results.push((function() {
              var _results1;
              _results1 = [];
              for (j in row) {
                cell = row[j];
                input = this.form.find("input[name='answer[" + i + "][" + j + "]']");
                if ((input != null) && (cell != null)) {
                  _results1.push(input.val(cell));
                } else {
                  _results1.push(void 0);
                }
              }
              return _results1;
            }).call(this));
          }
          return _results;
      }
    };

    Problem.prototype.observe = function() {
      var _this = this;
      return this.form.submit(function(e) {
        _this.submit();
        return false;
      });
    };

    Problem.prototype.submit = function() {
      var _this = this;
      return $.ajax({
        type: 'POST',
        url: this.form.attr('action'),
        data: this.form.serialize(),
        success: function(answer) {
          return (_this.update(_this.form))(answer.results);
        }
      });
    };

    Problem.prototype.update = function(form) {
      var _this = this;
      return function(results) {
        var cell, field, i, input, j, row;
        switch (results) {
          case true:
            field = _this.extract(form);
            field.removeClass('error');
            field.addClass('success');
            break;
          case false:
            field = _this.extract(form);
            field.removeClass('success');
            field.addClass('error');
            break;
          default:
            for (i in results) {
              row = results[i];
              for (j in row) {
                cell = row[j];
                input = form.find("input[name='answer[" + i + "][" + j + "]']");
                (_this.update(input))(cell);
              }
            }
        }
        return null;
      };
    };

    Problem.prototype.extract = function(form) {
      var field;
      field = form.find('input[name="answer"]');
      if (field.length === 0) {
        return form;
      } else {
        return field;
      }
    };

    return Problem;

  })();

  init_scroll = function() {
    var problems, w, y;
    problems = $('.lesson-problems');
    y = problems.offset().top;
    w = problems.outerWidth();
    $(window).scroll(function() {
      if (window.scrollY >= y - 99) {
        problems.addClass('sticky');
        return problems.css('width', w);
      } else {
        problems.removeClass('sticky');
        problems.css('width', 'auto');
        return w = problems.outerWidth();
      }
    });
    return null;
  };

  init_pagination = function() {
    var ctrls, nums, problems;
    problems = $('.lesson-problems');
    nums = problems.find('.pagination a[data-page]');
    ctrls = problems.find('.pagination a[data-page-nav]');
    return nums.click(function() {
      problems.find('.problem-wrapper:not(.hide)').addClass('hide');
      problems.find('#problem_' + $(this).data('page')).parent().removeClass('hide');
      problems.find('.pagination li.current a[data-page]').parent().removeClass('current');
      $(this).parent('li').addClass('current');
      return false;
    });
  };

  this.genie.init_problems = function() {
    init_scroll();
    return init_pagination();
  };

  this.genie.init_lesson = function(options) {
    var a, answers, form, pos, problem, _i, _j, _len, _len1, _ref, _ref1;
    answers = [];
    _ref = options.answers;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      a = _ref[_i];
      answers[a.position] = a.content;
    }
    _ref1 = options.forms;
    for (pos = _j = 0, _len1 = _ref1.length; _j < _len1; pos = ++_j) {
      form = _ref1[pos];
      problem = new Problem(form, answers[pos]);
      problem.observe();
    }
    this.genie.init_problems;
    return null;
  };

  this.genie.launch = function() {
    return $.ajaxSetup({
      beforeSend: function(xhr) {
        var token;
        token = $('meta[name="csrf-token"]').attr('content');
        return xhr.setRequestHeader('X-CSRF-Token', token);
      }
    });
  };

  $(this.genie.launch);

}).call(this);
