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

  drawHood: function(scope, hood, minPoint, scale) {
    var rings = hood.geometry.coordinates;
    minPoint = minPoint || this.getMinPointFromGeom(hood.geometry);

    return _(rings).map(function(ring) {
      var path = this.drawRing(scope, ring[0], minPoint, scale);
      path.data = hood;
      return path
    }, this);
  },

  drawHoods: function(hoods, id, scale) {
    var scope = paper.setup(id);
    var geometries = _(hoods).map(function(hood) { return hood.geometry });
    var minPoint = this.getMinPointForAll(geometries);
    scale = scale || 1/40;

    _(hoods).each(function(hood) {
      hood.paths = this.drawHood(scope, hood, minPoint, scale);
    }, this);

    this._handleMouseEvents(scope, id);

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
  },

  _handleMouseEvents: function(scope, id) {
    var tool = new scope.Tool();
    var selection = null;
    var loading = false;

    tool.onMouseMove = function(event) {
      if (event.item) {
        if(selection && selection != event.item) selection.fillColor = 'black';
        selection = event.item;
        selection.fillColor = 'green';
        if (!loading) $("#" + id).css("cursor", "pointer");
      } else {
        if(selection) selection.fillColor = 'black';
        $("#" + id).css("cursor", "default");
        selection = null;
      }
    };

    tool.onMouseUp = function(event) {
      var slug = event.item.data.slug;
      loading = true;
      $("canvas").css("cursor", "wait");

      var destination = "/hoods/" + slug;
      if (window.location.href.match(/only_media=true/i)) {
        destination += "?only_media=true";
      }

      window.location.href = destination;
    };
  }
};
