module mastodon

import net.http
import net.websocket
import json

pub struct Status {
pub:
	content string
}

pub struct PostOptions {
pub:
	content string
	images  []string
}

pub struct StreamPayload {
pub:
	id         string
	created_at string
	status     Status
}

pub struct Message {
pub:
	id           string
	@type        string
	created_at   string
	visibility   string
	language     string
	uri          string
	bookmarked   bool
	content      string
	spoiler_text string
	sensitive    bool
	display_name string
}

pub struct Stream {
pub:
	stream  []string
	event   string
	payload string
}

pub struct Config {
pub:
	instance string = 'mastodon.social'
	token    string
}

pub struct Mastodon {
	config Config
}

pub fn new(config Config) Mastodon {
	return Mastodon{
		config: config
	}
	/*
	{
		config : {
			instance: 'c.im'
			token: 'jeje'
		}
	}
	*/
}

pub type EventCallback = fn (text string)

pub fn (m Mastodon) streaming(kind string, ecb EventCallback) !bool {
	// user | public | local | hashtag | list
	url := 'wss://${m.config.instance}/api/v1/streaming'
	mut ws := websocket.new_client(url)!
	ws.header = http.new_header_from_map({
		http.CommonHeader.authorization: ' Bearer ${m.config.token}'
	})

	ws.on_open(fn [kind] (mut ws websocket.Client) ! {
		msg := '{ "type": "subscribe", "stream": "${kind}:notification" }'
		ws.write_string(msg)!
		println('opened')
	})
	// ws.on_message_ref(fn [ecb] (mut ws websocket.Client, msg &websocket.Message) ! { println('traspaplunskins $msg') ecb(msg.payload.str()) })
	ws.on_message(fn [ecb] (mut ws websocket.Client, msg &websocket.Message) ! {
		text := msg.payload.bytestr()
		ecb(text)
	})
	ws.on_error(fn (mut ws websocket.Client, reason string) ! {
		// report somehow
		println('error: ' + reason)
	})
	ws.on_close(fn (mut ws websocket.Client, a int, b string) ! {
		println('Connection closed.')
	})
	println('Connecting')
	ws.connect()!
	println('Listening')
	ws.listen()!
	// spawn ws.listen()

	return true
}

pub fn (m Mastodon) timeline(name string) ![]Message {
	// names can be 'home'
	mut request := http.Request{
		url: 'https://' + m.config.instance + '/api/v1/timelines/' + name
		header: http.new_header_from_map({
			http.CommonHeader.authorization: 'Bearer ' + m.config.token
		})
		method: .get
	}
	res := request.do()!
	mentions := json.decode([]Message, res.body)!
	dump(mentions)
	// println(res.body)
	return mentions
}

pub fn (m Mastodon) post(msg PostOptions) bool {
	mut request := http.Request{
		url: 'https://' + m.config.instance + '/api/v1/statuses'
		header: http.new_header_from_map({
			http.CommonHeader.authorization: 'Bearer ' + m.config.token
		})
		method: .post
		data: 'status=' + msg.content
	}
	res := request.do() or { return false }
	println(res.body)
	return true
}
