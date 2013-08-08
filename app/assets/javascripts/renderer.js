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

  drawRing: function(scope, points, minPoint) {
    var scaledPoints = _(points).map(function(point) {
      var centered = [point[0] - minPoint[0], minPoint[1] - point[1]]
      return [centered[0] / 40, centered[1] / 40]
    });

    with(scope) {
      var pathFromArray = new Path({
        segments: scaledPoints,
        selected: false,
        closed: true
      });

      pathFromArray.strokeColor = 'black';
    }
  },

  drawHood: function(scope, geometry, minPoint) {
    var rings = geometry["coordinates"];
    minPoint = minPoint || this.getMinPointFromGeom(geometry);

    _(rings).each(function(ring) {
      this.drawRing(scope, ring[0], minPoint);
    }, this);
  },

  drawHoods: function(hoods, id) {
    var scope = paper.setup(id);
    var geometries = _(hoods).map(function(hood) { return hood.geometry });
    var minPoint = this.getMinPointForAll(geometries);

    _(geometries).each(function(geometry) {
      this.drawHood(scope, geometry, minPoint);
    }, this);

    window.onresize = function() {
      var width = $("#"+id).width();
      var height = $("#"+id).height();
      console.log("resizing", id, width, height);
      if(width) {
        scope.view.viewSize = [width, height];
        scope.view.draw();
      }
    }

    scope.view.draw();
  }
};
