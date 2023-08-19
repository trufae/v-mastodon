# http mastodon

This is an experimental implementation of the mastodon api for V
but this thing uses the plain http connections instead of the
websockets. Turns out, this is how node and python modules work.

But to me it seems more correct to use the websocket api, not
just because http is not designed to have persistent connections,
despite it does. but also because v have no support for this.

But i have a patch and i wont doubt to use it

// https://docs.joinmastodon.org/methods/streaming/#events
// https://mastodonpy.readthedocs.io/en/stable/
// https://martinheinz.dev/blog/86
