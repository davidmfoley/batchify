[![Build Status](https://travis-ci.org/davidmfoley/batchify.svg)](https://travis-ci.org/davidmfoley/batchify)
# Batchify

In some situations, many identical operations can occur in a short period of time, causing performance issues.

Batchify wraps a function so that when it is invoked with identical arguments multiple times while in progress, it will only be invoked once, and all callbacks will be notified when it completes.

```javascript
  users.findAll(function(err, users) {
    # do something with each user
  });
```

If there are many concurrent requests that need to look up all of the users, each one will take time and resources to service.

With batchify, one request will be used to service all of the concurrent requests:
```javascript
  var batchedFindAll = Batchify.wrap(users, 'findAll');

  # Now you use batchedFindAll the same as you would the original function:
  batchedFindAll(function(err, users) { ... });
```

Batchify invokes users.findAll once and triggers all of the subscribing callbacks when it is finished.

The wrapped function can have parameters too.

(Batchify uses the parameter values as a hash key, so concurrent calls with different parameters will not conflict)

