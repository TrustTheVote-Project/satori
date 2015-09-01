(function() {
  'use strict';

  var globals = typeof window === 'undefined' ? global : window;
  if (typeof globals.require === 'function') return;

  var modules = {};
  var cache = {};
  var has = ({}).hasOwnProperty;

  var aliases = {};

  var endsWith = function(str, suffix) {
    return str.indexOf(suffix, str.length - suffix.length) !== -1;
  };

  var unalias = function(alias, loaderPath) {
    var start = 0;
    if (loaderPath) {
      if (loaderPath.indexOf('components/' === 0)) {
        start = 'components/'.length;
      }
      if (loaderPath.indexOf('/', start) > 0) {
        loaderPath = loaderPath.substring(start, loaderPath.indexOf('/', start));
      }
    }
    var result = aliases[alias + '/index.js'] || aliases[loaderPath + '/deps/' + alias + '/index.js'];
    if (result) {
      return 'components/' + result.substring(0, result.length - '.js'.length);
    }
    return alias;
  };

  var expand = (function() {
    var reg = /^\.\.?(\/|$)/;
    return function(root, name) {
      var results = [], parts, part;
      parts = (reg.test(name) ? root + '/' + name : name).split('/');
      for (var i = 0, length = parts.length; i < length; i++) {
        part = parts[i];
        if (part === '..') {
          results.pop();
        } else if (part !== '.' && part !== '') {
          results.push(part);
        }
      }
      return results.join('/');
    };
  })();
  var dirname = function(path) {
    return path.split('/').slice(0, -1).join('/');
  };

  var localRequire = function(path) {
    return function(name) {
      var absolute = expand(dirname(path), name);
      return globals.require(absolute, path);
    };
  };

  var initModule = function(name, definition) {
    var module = {id: name, exports: {}};
    cache[name] = module;
    definition(module.exports, localRequire(name), module);
    return module.exports;
  };

  var require = function(name, loaderPath) {
    var path = expand(name, '.');
    if (loaderPath == null) loaderPath = '/';
    path = unalias(name, loaderPath);

    if (has.call(cache, path)) return cache[path].exports;
    if (has.call(modules, path)) return initModule(path, modules[path]);

    var dirIndex = expand(path, './index');
    if (has.call(cache, dirIndex)) return cache[dirIndex].exports;
    if (has.call(modules, dirIndex)) return initModule(dirIndex, modules[dirIndex]);

    throw new Error('Cannot find module "' + name + '" from '+ '"' + loaderPath + '"');
  };

  require.alias = function(from, to) {
    aliases[to] = from;
  };

  require.register = require.define = function(bundle, fn) {
    if (typeof bundle === 'object') {
      for (var key in bundle) {
        if (has.call(bundle, key)) {
          modules[key] = bundle[key];
        }
      }
    } else {
      modules[bundle] = fn;
    }
  };

  require.list = function() {
    var result = [];
    for (var item in modules) {
      if (has.call(modules, item)) {
        result.push(item);
      }
    }
    return result;
  };

  require.brunch = true;
  globals.require = require;
})();
require.register("buttons", function(exports, require, module) {
this.bindShowHideButtons = function(scope) {
  return $("button[data-target][data-toggle=collapse][data-show-label]", scope).each(function(i, e) {
    var btn, section;
    btn = $(e);
    section = $(btn.data('target'));
    section.on("show.bs.collapse", function(ev) {
      return btn.text(btn.data('hide-label') || 'Hide');
    });
    return section.on("hide.bs.collapse", function(ev) {
      return btn.text(btn.data('show-label') || 'Show');
    });
  });
};

$(function() {
  return bindShowHideButtons();
});
});

;require.register("component/election_data_section", function(exports, require, module) {
var Buttons, DataStore, ElectionDataTable, ElectionStatus, ErrorRow, LockDataButton, PropertyRow, Row, StatusLine, Table, UploadEventLogsButton, UploadRow, UploadVoterDataButton, actLoadData, actLockData, actUnlockData;

UploadRow = require('component/upload_row');

ErrorRow = require('component/error_row');

PropertyRow = require('component/property_row');

actLoadData = Reflux.createAction();

actLockData = Reflux.createAction();

actUnlockData = Reflux.createAction();

DataStore = Reflux.createStore({
  init: function() {
    this.data = {};
    this.listenTo(actLoadData, this.onLoadData);
    this.listenTo(actLockData, this.onLockData);
    return this.listenTo(actUnlockData, this.onUnlockData);
  },
  getInitialState: function() {
    return this.data;
  },
  onLoadData: function() {
    return $.getJSON(gon.data_url, (function(_this) {
      return function(data) {
        _this.data = data;
        return _this.trigger(_this.data);
      };
    })(this));
  },
  onLockData: function() {
    this.data.locked = true;
    this.trigger(this.data);
    return $.post(gon.lock_data_url, {}, ((function(_this) {
      return function(data) {
        _this.data = data;
        return _this.trigger(_this.data);
      };
    })(this)), 'json');
  },
  onUnlockData: function() {
    this.data.locked = false;
    this.trigger(this.data);
    return $.post(gon.unlock_data_url, {}, ((function(_this) {
      return function(data) {
        _this.data = data;
        return _this.trigger(_this.data);
      };
    })(this)), 'json');
  }
});

this.ElectionDataSection = React.createClass({
  mixins: [Reflux.connect(DataStore, "data")],
  getInitialState: function() {
    return {
      collapse: true
    };
  },
  onToggle: function(e) {
    e.preventDefault();
    return this.setState({
      collapse: !this.state.collapse
    });
  },
  render: function() {
    var buttonLabel, data, noDemog, noVTL, sectionClass, status;
    sectionClass = ['row', 'section', this.state.collapse ? 'collapse' : null].join(' ');
    buttonLabel = this.state.collapse ? 'Show' : 'Hide';
    data = this.state.data;
    noDemog = !data.has_demog;
    noVTL = !data.has_vtl;
    if (noDemog && noVTL) {
      status = 'none';
    } else if (noDemog || noVTL) {
      status = 'partial';
    } else if (data.locked) {
      status = 'complete';
    } else {
      status = 'available';
    }
    return React.createElement("div", null, React.createElement("div", {
      "className": 'row section-row'
    }, React.createElement("div", {
      "className": 'col-xs-10'
    }, React.createElement("h4", null, "Election Data (", React.createElement("em", {
      "className": 'smaller'
    }, status), ")")), React.createElement("div", {
      "className": 'col-xs-2 text-right'
    }, React.createElement("button", {
      "className": 'btn btn-xs btn-default',
      "type": 'button',
      "onClick": this.onToggle
    }, buttonLabel))), React.createElement("div", {
      "className": sectionClass
    }, React.createElement("div", {
      "className": 'col-xs-12'
    }, React.createElement(ElectionDataTable, {
      "data": this.state.data
    }))));
  }
});

ElectionDataTable = React.createClass({
  componentDidMount: function() {
    actLoadData();
    return setInterval(((function(_this) {
      return function() {
        return actLoadData();
      };
    })(this)), 5000);
  },
  render: function() {
    return React.createElement("div", null, React.createElement("div", {
      "className": 'row'
    }, React.createElement("div", {
      "className": 'col-xs-12'
    }, React.createElement(StatusLine, {
      "data": this.props.data
    }), React.createElement(Buttons, {
      "data": this.props.data
    }))), React.createElement("div", {
      "className": 'row'
    }, React.createElement("div", {
      "className": 'col-xs-12 no-pad'
    }, React.createElement(Table, {
      "data": this.props.data
    }))));
  }
});

StatusLine = React.createClass({
  render: function() {
    var data, noDemog, noVTL;
    data = this.props.data;
    noDemog = !data.has_demog;
    noVTL = !data.has_vtl;
    if (data.locked) {
      return React.createElement("p", null, "Complete data");
    } else {
      if (noDemog && noVTL) {
        return React.createElement("p", null, "No data is available currently");
      } else if (noDemog) {
        return React.createElement("p", null, "Voter administration log data details are below. Voter demographic data is not available currently.");
      } else if (noVTL) {
        return React.createElement("p", null, "Voter demographic data details are below. Voter administration log data is not available currently.");
      } else {
        return null;
      }
    }
  }
});

Buttons = React.createClass({
  render: function() {
    var data, lockDisabled, noDemog, noVTL, uploadDemogButton, uploadVTLButton;
    data = this.props.data;
    if (data.locked) {
      return React.createElement("p", {
        "className": 'text-right'
      }, React.createElement("span", null, "\u00a0"), React.createElement("a", {
        "onClick": actUnlockData,
        "data-confirm": 'Are you sure to unlock?',
        "className": 'btn btn-default'
      }, "Unlock Data"));
    } else {
      noDemog = !data.has_demog;
      noVTL = !data.has_vtl;
      lockDisabled = noDemog || noVTL;
      if (noVTL) {
        uploadVTLButton = React.createElement("span", null, React.createElement("a", {
          "href": gon.new_vtl_url,
          "className": 'btn btn-default'
        }, "Upload Voter Administration Log Data"), React.createElement("span", null, "\u00a0"));
      }
      if (noDemog) {
        uploadDemogButton = React.createElement("span", null, React.createElement("a", {
          "href": gon.new_demog_url,
          "className": 'btn btn-default'
        }, "Upload Voter Demographic Data"), React.createElement("span", null, "\u00a0"));
      }
      return React.createElement("p", {
        "className": 'text-right'
      }, uploadVTLButton, uploadDemogButton, React.createElement("a", {
        "onClick": actLockData,
        "disabled": lockDisabled,
        "data-confirm": 'Are you sure to lock?',
        "className": 'btn btn-default'
      }, "Lock Data"));
    }
  }
});

Table = React.createClass({
  render: function() {
    var data, errors, rows, uploads;
    data = this.props.data;
    rows = (data.rows || []).map(function(r) {
      return React.createElement(Row, {
        "key": r.id,
        "row": r,
        "locked": data.locked
      });
    });
    uploads = (data.uploads || []).map(function(u) {
      return React.createElement(UploadRow, {
        "key": u.id,
        "cols": 2.,
        "upload": u
      });
    });
    errors = (data.errors || []).map(function(e) {
      return React.createElement(ErrorRow, {
        "key": e.id,
        "error": e
      });
    });
    return React.createElement("table", {
      "className": 'table table-striped'
    }, React.createElement("tbody", null, rows, uploads, errors));
  }
});

Row = React.createClass({
  render: function() {
    var customRows, dataType, deleteBtn, l, locked;
    l = this.props.row;
    locked = this.props.locked;
    if (l.type === 'vtl') {
      dataType = 'Voter Administration';
      customRows = [
        React.createElement(PropertyRow, {
          "key": 'ee',
          "label": "Earliest Event",
          "value": l.earliest_event_at
        }), React.createElement(PropertyRow, {
          "key": 'le',
          "label": "Latest Event",
          "value": l.latest_event_at
        }), React.createElement(PropertyRow, {
          "key": 'te',
          "label": "Total Events",
          "value": l.events_count
        })
      ];
    } else {
      dataType = 'Voter Demographics';
      customRows = [
        React.createElement(PropertyRow, {
          "key": 'tr',
          "label": "Total Records",
          "value": l.records_count
        })
      ];
    }
    if (locked) {
      deleteBtn = null;
    } else {
      deleteBtn = React.createElement("a", {
        "href": l.url,
        "data-method": 'delete',
        "data-confirm": 'Delete this data file?',
        "className": 'btn btn-xs btn-danger'
      }, "Delete");
    }
    return React.createElement("tr", null, React.createElement("td", {
      "className": 'col-sm-12'
    }, React.createElement(PropertyRow, {
      "label": "Data Type",
      "value": dataType
    }), React.createElement(PropertyRow, {
      "label": "Uploaded at",
      "value": l.uploaded_at
    }), React.createElement(PropertyRow, {
      "label": "Uplaoded by",
      "value": l.uploaded_by
    }), React.createElement(PropertyRow, {
      "label": "Origin",
      "value": l.origin
    }), React.createElement(PropertyRow, {
      "label": "Filename",
      "value": l.filename
    }), customRows), React.createElement("td", {
      "className": 'text-right'
    }, deleteBtn));
  }
});

this.ElectionStatusSection = React.createClass({
  mixins: [Reflux.connect(DataStore, "data")],
  getInitialState: function() {
    return {
      collapse: false
    };
  },
  onToggle: function(e) {
    e.preventDefault();
    return this.setState({
      collapse: !this.state.collapse
    });
  },
  render: function() {
    var buttonLabel, data, sectionClass;
    sectionClass = ['row', 'section', this.state.collapse ? 'collapse' : null].join(' ');
    buttonLabel = this.state.collapse ? 'Show' : 'Hide';
    data = this.state.data;
    return React.createElement("div", null, React.createElement("div", {
      "className": 'row section-row'
    }, React.createElement("div", {
      "className": 'col-xs-10'
    }, React.createElement("h4", null, "Status")), React.createElement("div", {
      "className": 'col-xs-2 text-right'
    }, React.createElement("button", {
      "className": 'btn btn-xs btn-default',
      "type": 'button',
      "onClick": this.onToggle
    }, buttonLabel))), React.createElement("div", {
      "className": sectionClass
    }, React.createElement("div", {
      "className": 'col-xs-12'
    }, React.createElement(ElectionStatus, {
      "data": this.state.data
    }))));
  }
});

ElectionStatus = React.createClass({
  render: function() {
    var data, hasDemog, hasVTL, lockDisabled, locked, name, reportingState;
    data = this.props.data;
    hasDemog = data.has_demog;
    hasVTL = data.has_vtl;
    locked = data.locked;
    name = gon.election_name;
    reportingState = 'complete';
    if (locked) {
      if (reportingState === 'submitted') {
        return React.createElement("p", null, "Reporting for election ", name, " is available based on completed data.", React.createElement("br", null), "EAVS reporting is complete and has been submitted by your group administrator.");
      } else if (reportingState === 'complete') {
        return React.createElement("p", null, "Reporting for election ", name, " is available based on completed data.", React.createElement("br", null), gon.complete_message);
      } else {
        return React.createElement("p", null, "Reporting for election ", name, " is available based on completed data.", React.createElement("br", null), "EAVS reporting is not complete yet -- please check the individual reports below for status.");
      }
    } else {
      lockDisabled = !hasDemog || !hasVTL;
      if (!hasDemog && !hasVTL) {
        return React.createElement("div", null, React.createElement("p", null, "Reporting for election ", name, " is currently unavailable because it lacks\nraw data, for both administrative events and voter demographics."), React.createElement("p", null, React.createElement(UploadEventLogsButton, null), React.createElement(UploadVoterDataButton, null), React.createElement(LockDataButton, {
          "onClick": actLockData,
          "disabled": lockDisabled
        })));
      } else if (hasDemog && !hasVTL) {
        return React.createElement("div", null, React.createElement("p", null, "Reporting for election ", name, " is currently only partially available\nbecause it lacks raw data on administrative events."), React.createElement("p", null, React.createElement(UploadEventLogsButton, null)));
      } else if (!hasDemog && hasVTL) {
        return React.createElement("div", null, React.createElement("p", null, "Reporting for election ", name, " is currently only partially available\nbecause it lacks raw data on voter demographics."), React.createElement("p", null, React.createElement(UploadVoterDataButton, null)));
      } else {
        return React.createElement("div", null, React.createElement("p", null, "Reporting for election ", name, " is available based on current raw data.\nYou can choose among the reports below to determine whether you are\nsatisfied with your current reports, and you can run metrics reports to\nhelp determine whether you have a satisfactory set of raw data.\nIf not, you can open the two panes below to either augment existing data,\nor delete previously uploaded data, and then replace it. If your data is\ncomplete, you can lock your data sets to finalize your reports."), React.createElement("p", null, React.createElement(LockDataButton, {
          "onClick": actLockData,
          "disabled": lockDisabled
        })));
      }
    }
  }
});

UploadEventLogsButton = React.createClass({
  render: function() {
    return React.createElement("span", null, "\u00a0", React.createElement("a", {
      "href": gon.new_vtl_url,
      "className": 'btn btn-default'
    }, "Upload Event Logs"));
  }
});

UploadVoterDataButton = React.createClass({
  render: function() {
    return React.createElement("span", null, "\u00a0", React.createElement("a", {
      "href": gon.new_demog_url,
      "className": 'btn btn-default'
    }, "Upload Voter Data"));
  }
});

LockDataButton = React.createClass({
  render: function() {
    return React.createElement("span", null, "\u00a0", React.createElement("a", {
      "onClick": this.props.onClick,
      "disabled": this.props.disabled,
      "data-confirm": 'Are you sure to lock?',
      "className": 'btn btn-default'
    }, "Lock Data"));
  }
});

});

require.register("component/elections_list", function(exports, require, module) {
var ElectionRow, ElectionsStore, SelectorStore, Table, TypeSelector, actChangeSelector;

actChangeSelector = Reflux.createAction();

SelectorStore = Reflux.createStore({
  init: function() {
    this.data = 'progress';
    return this.listenTo(actChangeSelector, this.onChangeSelector);
  },
  getInitialState: function() {
    return this.data;
  },
  onChangeSelector: function(v) {
    this.data = v;
    return this.trigger(this.data);
  }
});

ElectionsStore = Reflux.createStore({
  init: function() {
    this.elections = [];
    this.allElections = gon.elections;
    return this.listenTo(SelectorStore, this.onSelectorChange, this.onSelectorChange);
  },
  getInitialState: function() {
    return this.elections;
  },
  onSelectorChange: function(v) {
    if (v === 'all') {
      this.elections = this.allElections;
    } else {
      this.elections = _.select(this.allElections, function(e) {
        return !e.locked;
      });
    }
    return this.trigger(this.elections);
  }
});

this.ElectionsList = React.createClass({
  mixins: [Reflux.connect(ElectionsStore, "elections")],
  render: function() {
    return React.createElement("div", {
      "className": 'row'
    }, React.createElement("div", {
      "className": 'col-sm-12'
    }, React.createElement(TypeSelector, null), React.createElement(Table, {
      "elections": this.state.elections
    })));
  }
});

TypeSelector = React.createClass({
  mixins: [Reflux.connect(SelectorStore, "selector")],
  handleChange: function(e) {
    return actChangeSelector(e.target.value);
  },
  render: function() {
    return React.createElement("div", {
      "className": 'row'
    }, React.createElement("div", {
      "className": 'col-sm-4'
    }, React.createElement("div", {
      "className": 'form-group'
    }, React.createElement("select", {
      "className": 'form-control',
      "value": this.state.selector,
      "onChange": this.handleChange
    }, React.createElement("option", {
      "value": 'progress'
    }, "Show Reporting In-Progress"), React.createElement("option", {
      "value": 'all'
    }, "Show All Elections")))));
  }
});

Table = React.createClass({
  render: function() {
    var e, nodes;
    e = this.props.elections;
    if (e.length === 0) {
      nodes = React.createElement("tr", null, React.createElement("td", null, I18n.t("user_dashboard.show.none")));
    } else {
      nodes = e.map(function(el) {
        return React.createElement(ElectionRow, {
          "key": el.id,
          "election": el
        });
      });
    }
    return React.createElement("div", {
      "className": 'row'
    }, React.createElement("div", {
      "className": 'col-sm-12 no-pad'
    }, React.createElement("table", {
      "className": 'table table-striped'
    }, nodes)));
  }
});

ElectionRow = React.createClass({
  render: function() {
    var e;
    e = this.props.election;
    return React.createElement("tr", null, React.createElement("td", null, "Election Name: ", React.createElement("a", {
      "href": e.url
    }, e.name), React.createElement("br", null), "Election Date: ", e.held_on, React.createElement("br", null), "Start\x2FEnd Dates for Reporting: ", e.voter_start_on, " - ", e.voter_end_on, React.createElement("br", null), "Owner: ", e.owner), React.createElement("td", {
      "className": "text-right"
    }, React.createElement("a", {
      "href": e.url,
      "className": "btn btn-xs btn-info"
    }, "Select")));
  }
});

});

require.register("component/error_row", function(exports, require, module) {
var ErrorRow;

module.exports = ErrorRow = React.createClass({
  render: function() {
    var file, fileParts, u;
    u = this.props.error;
    file = u.filename;
    if (!file) {
      fileParts = u.url.split('/');
      file = fileParts[fileParts.length - 1];
    }
    return React.createElement("tr", null, React.createElement("td", {
      "className": 'col-sm-12'
    }, React.createElement("p", null, file), React.createElement("div", {
      "className": 'alert alert-danger'
    }, u.error)), React.createElement("td", {
      "className": 'text-center'
    }, React.createElement("a", {
      "href": u.delete_url,
      "data-method": 'delete',
      "data-confirm": 'Delete this failed job?',
      "className": 'btn btn-xs btn-danger'
    }, React.createElement("div", {
      "className": 'glyphicon glyphicon-remove'
    }))));
  }
});

});

require.register("component/property_row", function(exports, require, module) {
var PropertyRow;

module.exports = PropertyRow = React.createClass({
  render: function() {
    return React.createElement("div", {
      "className": 'row'
    }, React.createElement("div", {
      "className": 'col-sm-2'
    }, this.props.label, ":"), React.createElement("div", {
      "className": 'col-sm-10'
    }, this.props.value));
  }
});

});

require.register("component/upload_row", function(exports, require, module) {
var UploadRow;

module.exports = UploadRow = React.createClass({
  render: function() {
    var file, fileParts, icon, span, state, u;
    u = this.props.upload;
    file = u.filename;
    if (!file) {
      fileParts = u.url.split('/');
      file = fileParts[fileParts.length - 1];
    }
    icon = false;
    if (u.state === 'pending') {
      icon = 'glyphicon glyphicon-hourglass';
    } else if (u.state === 'processing') {
      icon = 'glyphicon glyphicon-refresh';
    }
    if (icon) {
      state = React.createElement("span", {
        "className": icon
      });
    } else {
      state = u.state;
    }
    span = this.props.cols - 1;
    return React.createElement("tr", null, React.createElement("td", {
      "colSpan": span,
      "className": 'col-sm-12'
    }, file), React.createElement("td", {
      "className": 'text-center'
    }, state));
  }
});

});

require.register("file_upload", function(exports, require, module) {
$("#js-form").on("submit", function(e) {
  e.preventDefault();
  return alert("Please pick the XML file");
});

$("#file_upload input:file").each(function(i, elem) {
  var fileInput, progressBar, statusBar, statusLabel;
  fileInput = $(elem);
  statusBar = $("#js-status-bar");
  progressBar = $(".progress-bar", statusBar);
  statusLabel = $(".status", statusBar);
  statusBar.hide();
  statusBar.removeClass('hide');
  return fileInput.fileupload({
    type: "PUT",
    autoUpload: true,
    acceptFileTypes: /\.xml$/i,
    paramName: 'file',
    multipart: false,
    formData: {
      'x-amz-meta-original-filename': '${filename}'
    },
    start: function() {
      progressBar.css({
        width: '10%'
      });
      statusLabel.html("Uploading&hellip;");
      return statusBar.show();
    },
    progress: function(e, data) {
      var p;
      p = Math.max(10, parseInt(data.loaded / data.total * 100, 10));
      progressBar.css({
        width: p + "%"
      });
      progressBar.attr({
        'aria-valuenow': p
      });
      return progressBar.text(p + "%");
    },
    fail: function() {
      fileInput.show();
      return statusLabel.html("Failed to upload. Please retry.");
    },
    done: function() {
      progressBar.css({
        width: '100%'
      });
      progressBar.attr({
        'aria-valuenow': 100
      });
      statusLabel.html("Uploaded. Initiating parsing&hellip;");
      return $("#js-form")[0].submit();
    }
  });
});
});

;require.register("reports", function(exports, require, module) {
$(function() {
  var dt;
  dt = $('table.dataTable').dataTable({
    paging: false,
    scrollY: 600,
    scrollX: true,
    info: false,
    ordering: false,
    searching: false,
    bSortCellsTop: true
  });
  return new $.fn.dataTable.FixedColumns(dt);
});
});

;
//# sourceMappingURL=app.js.map