# Mastodon for V

This module provides an easy interface to interact with the Mastodon REST API

It's under development, so don't use it until the API is considered stable
and most features are implemented. Right now can be considered a Proof-Of-Concept.

## Author

Feel free to contact me [@pancake@infosec.exchange](https://infosec.exchange/@pancake)

## Usage

Create a file named `auth.key` and put your auth key inside

```
$ v run main.v
```

## API Usage

```v
import mastodon

key := $embed_file('auth.key').to_string().trim_space()
m := mastodon.new(mastodon.Config{
	token: key
	instance: 'c.im'
})
m.post('hello world')
```

## Streaming API

```v
m.streaming('user', fn (text string) {
	stream := json.decode(mastodon.Stream, text) or { return }
	payload := json.decode(mastodon.StreamPayload, stream.payload) or { return }
	content := remove_html_tags(payload.status.content)
	println('>>>>>>> ' + content)
}) or { println('error streaming' + err.msg()) }
```
