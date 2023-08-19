module main

import json
import mastodon
import regex

fn main() {
	key := $embed_file('auth.key').to_string().trim_space()
	m := mastodon.new(mastodon.Config{
		token: key
		instance: 'c.im'
	})
	show_timeline(m)
	live_events(m)
	// m.post('Hello World', [])
}

fn remove_html_tags(input_str string) string {
	mut re := regex.regex_opt('<[^>]+>') or { return input_str }
	return re.replace(input_str, '')
}

fn show_timeline(m mastodon.Mastodon) {
	messages := m.timeline('home') or { return }
	for post in messages {
		content := remove_html_tags(post.content)
		println('===== ' + content)
	}
}

fn live_events(m mastodon.Mastodon) {
	m.streaming('user', fn (text string) {
		//		os.write_file('p.json', text) or { return }
		stream := json.decode(mastodon.Stream, text) or { return }
		//		os.write_file('q.json', stream.payload) or { return }
		payload := json.decode(mastodon.StreamPayload, stream.payload) or { return }
		content := remove_html_tags(payload.status.content)
		println('>>>>>>> ' + content)
	}) or { println('error streaming' + err.msg()) }
}
