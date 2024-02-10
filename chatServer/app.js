const express = require('express');
const app = express();
const http = require('http').createServer(app);
const io = require('socket.io')(http);


app.route("/").get((req,res) =>{
  res.json("Hey there welcome again on dev stack Channel!!..")
})


io.on('connection', (socket) => {
  console.log('a user connected');
  socket.on('chat_message', (msg) => {
    console.log('message: ' + msg);
    io.emit('chat_message', msg);
  });
  socket.on('disconnect', () => {
    console.log('user disconnected');
  });
});
// io.on("connection", (socket) => {
//   console.log("connetetd");
//   console.log(socket.id, "has joined");
//   socket.on("signin", (id) => {
//     console.log(id);
//     clients[id] = socket;
//     console.log(clients);
//   });
//   socket.on("message", (msg) => {
//     console.log(msg);
//     let targetId = msg.targetId;
//     if (clients[targetId]) clients[targetId].emit("message", msg);
//   });
//   socket.on('chat_message', (msg) => {
//     console.log('message: ' + msg);
//     io.emit('chat_message', msg);
//   });
//   socket.on('disconnect', () => {
//     console.log('user disconnected');
//   });
// });

http.listen(3000, () => {
  console.log('listening on *:3000');
});