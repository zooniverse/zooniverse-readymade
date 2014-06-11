// Generated by CoffeeScript 1.7.1
(function() {
  var APIInfoContainer, Controller, currentProject,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Controller = require('zooniverse/controllers/base-controller');

  currentProject = require('zooniverse-readymade/current-project');

  APIInfoContainer = (function(_super) {
    __extends(APIInfoContainer, _super);

    APIInfoContainer.prototype.tagName = 'span';

    APIInfoContainer.prototype.className = 'readymade-api-info-container';

    APIInfoContainer.prototype.href = '';

    APIInfoContainer.prototype.events = {
      click: 'refresh'
    };

    function APIInfoContainer() {
      APIInfoContainer.__super__.constructor.apply(this, arguments);
      this.refresh();
    }

    APIInfoContainer.prototype.refresh = function() {
      var projectInfo;
      projectInfo = currentProject.api.get(this.href);
      return projectInfo.then((function(_this) {
        return function(info) {
          var container, _i, _len, _ref, _results;
          _ref = _this.el.find('[data-readymade-info-key]');
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            container = _ref[_i];
            _results.push(container.innerHTML = info[container.getAttribute('data-readymade-info-key')]);
          }
          return _results;
        };
      })(this));
    };

    return APIInfoContainer;

  })(Controller);

  module.exports = APIInfoContainer;

}).call(this);