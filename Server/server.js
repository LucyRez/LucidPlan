const { measureMemory } = require('vm');

var mergeJSON = require("merge-json") ; // Библиотека для того, чтобы мерджить JSON-ы
var MongoClient = require('mongodb').MongoClient; // Подключаем клиент mongodb
var url = "mongodb://localhost:27017/mydb"; // По данному адресу будет находиться база данных
var app = require('express')(); 
var http = require('http').createServer(app);
var io = require('socket.io')(http); // Подключаем к серверу функционал вебсокетов

http.listen(3000, function(){
  console.log('Listening on *:3000');
});

// Устанавливаем соединение с mongo
MongoClient.connect(url, function(err, db) {
  if (err) throw err;
  console.log("Database created!");
  
  // Ждём подключения клиента
  io.sockets.on('connection', function(socket){

    // Получаем коллекцию со всей историей сообщений из базы данных
    var chat = db.db('chat');
    collection = chat.collection('messageHistory');

    // Массив сообщений будет передан клиенту
    chat.collection('messageHistory').find({}).toArray(function(err,res){
      if(err) throw err;
      console.log(res);
      socket.emit('messageHistory', res); // Тригер для события "messageHistory" клиента
    });

    // Приветствуем нового пользователя
    socket.emit('Client port', 'Welcome to the demo version of the chat!');
  
    // Тригер для ивента у всех клиентов, кроме подсоединившегося
    socket.broadcast.emit('Client port', 'A user has joined the chat just now');
  
    // Сообщение об отключении пользователя присылается всем
    socket.on('disconnect', function(){
      io.emit('Client port', 'A user has just disconnected');
    });
  
    // // Просто пример того, как можно посылать простые сообщения на клиент
    // socket.on('Server Event', function(data) {
    //     console.log(data);
    //     io.sockets.emit('Client port', {msg: 'Hi iOS client!'});
    // });
  
    // Сервер получает сообщение от клиента
    socket.on('chatMessage', function(message){

      let clientMessage = JSON.parse(message); // Парсим объект от клиента и получаем JSON

      var dateTime = JSON.stringify({date:(new Date()).toISOString()});
      var dateJSON = JSON.parse(dateTime); // Получаем JSON с текущим временем
  
      var result = mergeJSON.merge(clientMessage,dateJSON); // Объединяем JSON с сообщением от клиента с временем
      console.log(result);

      chat.collection('messageHistory').insertOne(result,function(){
        // Происходит вставка сообщения в базу с историей сообщений
      });

      io.emit('newMessage', result); // Отправленное одним клиентом сообщение передаётся на все клиенты

    });

    // Вспомогательная команда для очистки базы данных
    socket.on('clear', function(data){
      chat.remove({}, function(){
      });
    });
  
  });

});

