# Batchify

Batches calls to a particular resource (such as a database or network) so that, rather than making the call multiple times, a single call is made and all callbacks are triggered when it completes.

For example, let's say that we have the following code:

```coffee
  users.findAll (users) ->
    # do something with each user
```

If there are many concurrent requests that need to look up all of the users, each one will take time and resources to service.

With batchify, one request will be used to service all of the concurrent requests:
```coffee
  batchedFindAll = Batchify.wrap(users, 'findAll')

  # Now you use batchedFindAll the same as you would the original function:
  batchedFindAll (users) ->
```

The wrapped function can have parameters too:

```coffee
  batchedFindByState = Batchify.wrap(users, 'findByState')

  batchedFindAll 'active', (users) ->
```

(Batchify uses the parameter values as a hash key, so concurrent calls with different parameters will not conflict)

