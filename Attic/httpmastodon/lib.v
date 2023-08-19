module mastodon

import net.http
import json

pub struct Status {
pub:
	content string
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

// use http connection to stream data
pub fn (m Mastodon) streaming(ecb EventCallback) bool {
	// names can be 'home'
	mut request := http.Request{
		url: 'https://' + m.config.instance + '/api/v1/streaming/user/notification'
		header: http.new_header_from_map({
			http.CommonHeader.authorization: 'Bearer ' + m.config.token
		})
		method: .get
	}
	mut s := ''
	res := request.do_stream(fn [ecb, mut s] (arg string) {
		s += arg
		s.index('\n') or { return }
		lnl := s.ends_with('\n')
		data := s.split('\n')
		if lnl {
			for i := 0; i < data.len; i++ {
				ecb(data[i])
			}
			s = ''
		} else {
			for i := 0; i < data.len - 1; i++ {
				ecb(data[i])
			}
			s = data[data.len - 1]
		}
	}) or { return false }
	println(res.body)
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

/*
mut cmd := 'curl'
	cmd += ' --header "Authorization: Bearer ' + m.config.token + '"'
	cmd += ' --form "status=' + message + '"' // ${MESSAGE}"'
	cmd += ' "https://' + m.config.instance + '/api/v1/statuses"'
	// http.post()
	return os.system(cmd) == 0
*/
pub fn (m Mastodon) post(message string, images []string) bool {
	mut request := http.Request{
		url: 'https://' + m.config.instance + '/api/v1/statuses'
		header: http.new_header_from_map({
			http.CommonHeader.authorization: 'Bearer ' + m.config.token
		})
		method: .post
		data: 'status=' + message
	}
	res := request.do() or { return false }
	println(res.body)
	return true
}
