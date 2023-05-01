import { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 8080 });

var socketHost = null;
var socketClient = null;

console.log("server started on port 8080");

wss.on('connection', function connection(ws) {
  ws.on('message', function message(data) {
      const msg = data.toString();
      console.log("=====> "+msg);
        if(msg === "host"){
          socketHost = ws;
          console.log("host connected");
      } else if(msg === "client"){
        socketClient = ws;
        console.log("client connected");
      } else if(msg.startsWith("fromHost")){
        if(socketClient) socketClient.send(msg.substring(8));
      } else if(msg.startsWith("fromClient")){
        if(socketHost) socketHost.send(msg.substring(10));
      }
  });
});