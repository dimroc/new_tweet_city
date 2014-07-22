angular.module('hoodFrequencyApp').
  factory('hoodRenderer', function() {
    var HoodRenderer = {
      getMinPointFromPoints: function(points) {
        var x = _.min(points, function(point) { return point[0]; })[0];
        var y = _.min(points, function(point) { return -point[1]; })[1];
        return [x, y];
      },

      getMinPointFromGeom: function(geometry) {
        var rings = geometry["coordinates"];
        var minx = 99999999;
        var miny = 0;

        _(rings).each(function(ring) {
          var newMin = this.getMinPointFromPoints(ring[0]);

          if(minx > newMin[0]) minx = newMin[0];
          if(miny < newMin[1]) miny = newMin[1];
        }, this);

        return [minx, miny];
      },

      getMinPointForAll: function(geometries) {
        var minPoints = _(geometries).map(function(g) { return this.getMinPointFromGeom(g); }, this);
        return this.getMinPointFromPoints(minPoints);
      },

      drawRing: function(scope, points, minPoint, scale) {
        var scaledPoints = _(points).map(function(point) {
          var centered = [point[0] - minPoint[0], minPoint[1] - point[1]]
          return [centered[0] * scale, centered[1] * scale]
        });

        with(scope) {
          var pathFromArray = new Path({
            segments: scaledPoints,
            selected: false,
            closed: true
          });

          return pathFromArray;
        }
      },

      drawHood: function(scope, hood, minPoint, scale) {
        var rings = hood.geometry.coordinates;
        minPoint = minPoint || this.getMinPointFromGeom(hood.geometry);

        return _(rings).map(function(ring) {
          var path = this.drawRing(scope, ring[0], minPoint, scale);
          path.data = hood;
          return path
        }, this);
      },

      colorHood: function(hood) {
        _(hood.paths).each(function(path) {
          var color = new paper.Color(0, 0, 1, hood.normalizedFrequency);
          path.fillColor = color;
          path.strokeColor = 'black';
        });
      },

      drawHoods: function(ngscope, hoods, canvas, scale) {
        paper.clear();
        var scope = paper.setup(canvas);
        var geometries = _(hoods).map(function(hood) { return hood.geometry });
        var minPoint = this.getMinPointForAll(geometries);
        scale = scale || 1/38;

        _(hoods).each(function(hood) {
          hood.paths = this.drawHood(scope, hood, minPoint, scale);
        }, this);

        _(hoods).each(function(hood) {
          this.colorHood(hood);
        }, this);

        this._handleMouseEvents(scope, ngscope);
        scope.view.draw();
      },

      _handleMouseEvents: function(paperScope, ngscope) {
        var tool = new paperScope.Tool();
        var selection = null;
        var loading = false;

        tool.onMouseMove = function(event) {
          if (event.item) {
            if(selection != event.item) { ngscope.$emit("hood.selected", event.item.data); }
            selection = event.item;
          } else {
            if(selection) ngscope.$emit("hood.deselected");
            selection = null;
          }
        };
      }
    };

    return function (ngscope, hoods, canvas) {
      HoodRenderer.drawHoods(ngscope, hoods, canvas);
    };
  });

