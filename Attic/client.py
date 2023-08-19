import websocket
websocket.enableTrace(True)

ws = websocket.WebSocket()
k="your-key-goes-here"
def on_message(wsapp, message):
	print(message)
ws.connect("wss://c.im/api/v1/streaming", header={"Authorization":"Bearer "+k})
# ws.connect("wss://c.im/api/v1/streaming/user/notification", header={"Authorization":"Bearer "+k})
ws.send('{ "type": "subscribe", "stream": "user:notification" }\n')
while True:
	print("READING")
	print(ws.recv())
	print("READ")
# ws.run_forever()
