var mergeJSON = require("merge-json") ; // Библиотека для того, чтобы мерджить JSON-ы

var app = require('express')(); 
var http = require('http').createServer(app);
var io = require('socket.io')(http); // Подключаем к серверу функционал вебсокетов

const { MongoClient } = require("mongodb");
const client = new MongoClient("mongodb://localhost:27017/mydb", { native_parser: true });

var collection;

io.on("connection", async (socket) => {

    socket.on("getMessages", async (id) => {
        let result = await collection.findOne({ "_id": id});
        let messages = result.messages;
        socket.activeRoom = id;
        socket.join(socket.activeRoom);

        console.log(messages);
        socket.emit("messageHistory", messages);
    });

     // Сервер получает сообщение от клиента
     socket.on("chatMessage", function(message){

        let clientMessage = JSON.parse(message); // Парсим объект от клиента и получаем JSON
  
        var dateTime = JSON.stringify({date:(new Date()).toISOString()});
        var dateJSON = JSON.parse(dateTime); // Получаем JSON с текущим временем
    
        var result = mergeJSON.merge(clientMessage,dateJSON); // Объединяем JSON с сообщением от клиента с временем
        console.log(result);

        collection.updateOne({ "_id": socket.activeRoom }, {
            "$push": {
                "messages": result
            }
        });
        console.log(socket.activeRoom);
        io.to(socket.activeRoom).emit("newMessage", result);

      });
    
   
});


http.listen(4000, async () => {
    try {
        await client.connect();
        collection = client.db("lucidPlan").collection("groups");
        console.log("Listening on port: %s", http.address().port);

    } catch (e) {
        console.error(e);
    }
});
