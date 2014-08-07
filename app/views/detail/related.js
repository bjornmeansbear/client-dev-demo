(function() {
  var React, button, div, ul, _ref;

  React = require('react');

  _ref = require('reactionary'), div = _ref.div, button = _ref.button, ul = _ref.ul;

  module.exports = React.createClass({
    getInitialState: function() {
      return {
        pg: 0,
        pgSize: 5
      };
    },
    propTypes: {
      collection: React.PropTypes.object.isRequired
    },
    handleUnitClick: function(e) {
      var unit;
      unit = e.target.value;
      if (e.preventDefault) {
        e.preventDefault();
      }
      return this.setState({
        unit: unit
      });
    },
    loadMetricRuler: function() {
      var item, ruler_img;
      if (!this.state.loadedMetric) {
        item = this.props.model;
        ruler_img = new Image();
        ruler_img.src = item.rulerPath.cm[this.props.imgSize];
        console.log('prefetch metric ruler ' + ruler_img.src);
        return this.setState({
          loadedMetric: true
        });
      }
    },
    render: function() {
      var closeButton, header, pager_txt, pages, relatedColorItems, relatedColorsList;
      pages = Math.ceil(this.props.collection.length / 5);
      if (pages > 1) {
        pager_txt = (this.state.pg + 1) + ' / ' + pages;
      } else {
        pager_txt = '';
      }
      closeButton = button({
        key: 'close',
        className: 'close plain',
        type: 'button'
      }, 'X');
      header = div({
        className: 'colors-header'
      }, pager_txt, closeButton);
      relatedColorItems = [];
      relatedColorsList = ul({
        className: 'list-inline list'
      });
      return div({
        id: 'related-colors',
        className: 'hidden-xs'
      }, header);
    }
  });

}).call(this);
