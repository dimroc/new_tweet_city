NTC.Renderer = {
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

      pathFromArray.strokeColor = 'white';
      pathFromArray.fillColor = 'black';
      return pathFromArray;
    }
  },

  drawHood: function(scope, geometry, minPoint, scale) {
    var rings = geometry["coordinates"];
    minPoint = minPoint || this.getMinPointFromGeom(geometry);

    return _(rings).map(function(ring) {
      return this.drawRing(scope, ring[0], minPoint, scale);
    }, this);
  },

  drawHoods: function(hoods, id, scale) {
    var scope = paper.setup(id);
    var geometries = _(hoods).map(function(hood) { return hood.geometry });
    var minPoint = this.getMinPointForAll(geometries);
    scale = scale || 1/40;

    _(hoods).each(function(hood) {
      hood.paths = this.drawHood(scope, hood.geometry, minPoint, scale);
    }, this);

    window.onresize = function() {
      var width = $("#"+id).width();
      var height = $("#"+id).height();

      if(width) {
        scope.view.viewSize = [width, height];
        scope.view.draw();
      }
    }

    scope.view.onFrame = function(event) {
      _(scope.project.layers[0]._children).each(function(path) {
        if(path.fillColor.blue != 0)
          path.fillColor.blue -= 0.005;
      });
    };
    scope.view.draw();
  }
};
