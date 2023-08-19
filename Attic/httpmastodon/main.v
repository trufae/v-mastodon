/*
if text.starts_with('data: ') {
			// parse json and act accordingly
			s := text[6..]
			post := json.decode(mastodon.Mention, s) or {
				println('Invalid json')
				return
			}
			content := remove_html_tags(post.status.content)
			println('-[mention]-> ${content}')
		}
		println('---> ${text}')
*/
