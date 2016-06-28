
/**
Broadcast updates to client when the model changes
 */

(function() {
  'use strict';
  var Place, onRemove, onSave;

  Place = require('./place.model');

  exports.register = function(socket) {
    Place.schema.post('save', function(doc) {
      return onSave(socket, doc);
    });
    return Place.schema.post('remove', function(doc) {
      return onRemove(socket, doc);
    });
  };

  onSave = function(socket, doc, cb) {
    return socket.emit('place:save', doc);
  };

  onRemove = function(socket, doc, cb) {
    return socket.emit('place:remove', doc);
  };

}).call(this);

//# sourceMappingURL=place.socket.js.map
