
/**
Using Rails-like standard naming convention for endpoints.
GET     /things              ->  index
POST    /things              ->  create
GET     /things/:id          ->  show
PUT     /things/:id          ->  update
DELETE  /things/:id          ->  destroy
 */

(function() {
  'use strict';
  var Place, _, handleError;

  _ = require('lodash');

  Place = require('./place.model');

  exports.index = function(req, res) {
    return Place.find(function(err, places) {
      if (err) {
        return handleError(res, err);
      }
      return res.status(200).json(places);
    });
  };

  exports.show = function(req, res) {
    return Place.findById(req.params.id, function(err, place) {
      if (err) {
        return handleError(res, err);
      }
      if (!place) {
        return res.status(404).end();
      }
      return res.json(place);
    });
  };

  exports.create = function(req, res) {
    return Place.create(req.body.data, function(err, place) {
      var base64Data, type;
      console.log(req.body);
      if (err) {
        return handleError(res, err);
      }
      console.log(req.body.image);
      if (req.body.image.type === 'image/jpeg') {
        base64Data = req.body.image.data.replace(/^data:image\/jpeg;base64,/, '');
        type = 'jpg';
      } else {
        base64Data = req.body.image.data.replace(/^data:image\/png;base64,/, '');
        type = 'png';
      }
      require('fs').writeFile('public/images/place/' + place._id + '.' + type, base64Data, 'base64', function(err) {
        return console.log(err);
      });
      return res.status(201).json(place);
    });
  };

  exports.update = function(req, res) {
    if (req.body._id) {
      delete req.body._id;
    }
    return Place.findById(req.params.id, function(err, place) {
      var updated;
      if (err) {
        return handleError(res, err);
      }
      if (!place) {
        return res.status(404).end();
      }
      updated = _.merge(place, req.body);
      return updated.save(function(err) {
        if (err) {
          return handleError(res, err);
        }
        return res.status(200).json(place);
      });
    });
  };

  exports.destroy = function(req, res) {
    return Place.findById(req.params.id, function(err, place) {
      if (err) {
        return handleError(res, err);
      }
      if (!place) {
        return res.status(404).end();
      }
      return Place.remove(function(err) {
        if (err) {
          return handleError(res, err);
        }
        return res.status(204).end();
      });
    });
  };

  handleError = function(res, err) {
    return res.status(500).json(err);
  };

}).call(this);

//# sourceMappingURL=place.controller.js.map
