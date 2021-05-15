var mergeJSON = require("merge-json") ; // Библиотека для того, чтобы мерджить JSON-ы
const express = require("express")();
const cors = require("cors"); // Allows communication with server from different port.
const http = require("http").createServer(express);
const io = require("socket.io")(http);

var Enemy = require("./enemySchema");


const { MongoClient } = require("mongodb");
const client = new MongoClient("mongodb://localhost:27017/mydb", { native_parser: true });

const enemyImages = ["blitz", "dreamon", "frosty", "corwus"];


express.use(cors());

var collection;

io.on("connection", (socket) => {

    socket.on("test", (mes) => {
        console.log(mes);
    });

    socket.on("join", async (userInfo) => {
        try {
            let infoParsed = JSON.parse(userInfo); // Parse into object
            let result = await collection.findOne({ "_id": infoParsed["groupId"] });
            console.log("Trying to join");
            if (!result) {
                // await collection.insertOne({"_id": groupId, messages:[]});
                console.log("Failed to join");
                socket.emit("joined", ""); // Return something else 'cause room doesn't exist.
                socket.emit("getCode", {
                    message: "Did not Join",
                    success: false
                });
            } else {
                socket.join(infoParsed["groupId"]);
                socket.emit("joined", infoParsed["groupId"]);
                socket.activeRoom = infoParsed["groupId"];
                console.log("Joined");
                await collection.updateOne({ "_id": socket.activeRoom }, {
                    "$push": {
                        "users": infoParsed
                    }
                });
                let result = await collection.findOne({ "_id": socket.activeRoom }, {messages: 0});

                socket.emit("getCode", {
                    message: "Joined",
                    success: true
                });
                socket.emit("getGame", result);
            }

        } catch (e) {
            console.error(e);
        }

    });

    socket.on("createRoom", async (userInfo) => {
        try {
            console.log(userInfo)
            let infoParsed = JSON.parse(userInfo); // Parse into object
            console.log(infoParsed);
            let result = await collection.findOne({ "_id": infoParsed["groupId"] });
            console.log("Trying to create room")
            // If room with this id doesn't exist
            if (!result) {
                const random = Math.floor(Math.random() * enemyImages.length);

                const enemy = new Enemy({
                    imageName: enemyImages[random],
                    health: 100,
                    maxHealth: 100,
                    damage: 10
                })

                await collection.insertOne({
                    "_id": infoParsed["groupId"],
                    enemy: enemy,
                    users: [infoParsed],
                    messages: []
                });

                socket.join(infoParsed["groupId"]);
                socket.activeRoom = infoParsed["groupId"];

                let result = await collection.findOne({ "_id": socket.activeRoom }, {messages: 0});

                socket.emit("roomCreated", result);
                console.log("Room was created");

                socket.emit("getCode", {
                    message: "Joined and created new",
                    success: true
                });
                socket.emit("getGame", result);

            } else {
                socket.emit("roomCreated", ""); // Return something else if room allready exists.
                socket.emit("getCode", {
                    message: "Did not create",
                    success: false
                });
                console.log("Room wasn't created")
            }

        } catch (e) {
            console.error(e);
        }
    });

    socket.on("oldUser", async (id) => {

        try {
            let result = await collection.findOne({ "_id": id });
            if (result) {
                socket.join(id);
                socket.activeRoom = id;

                console.log("old user joined")
                socket.emit("getCode", {
                    message: "Joined",
                    success: true
                });

                let result = await collection.findOne({ "_id": socket.activeRoom }, {messages: 0});
                console.log(result);
                socket.emit("getGame", result);
            }

        } catch (e) {
            console.error(e);
        }

    });

    socket.on("takeDamage", async (damageInfo) => {
        console.log(damageInfo)
        let infoParsed = JSON.parse(damageInfo); // Parse into object
        console.log(infoParsed);
        socket.activeRoom = infoParsed["_id"];
        socket.join(infoParsed["_id"]);

        let enemy = await collection.findOne({ "_id": socket.activeRoom });
        console.log(enemy);


        collection.updateOne({"_id": socket.activeRoom}, {
           "$set": {
               "enemy.health": enemy.enemy.health - infoParsed["damage"]
           }
        });

        let clientMessage = infoParsed["message"]; // Парсим объект от клиента и получаем JSON
  
        var dateTime = JSON.stringify({date:(new Date()).toISOString()});
        var dateJSON = JSON.parse(dateTime); // Получаем JSON с текущим временем
    
        var resMessage = mergeJSON.merge(clientMessage,dateJSON); // Объединяем JSON с сообщением от клиента с временем
        console.log(resMessage);

        collection.updateOne({ "_id": socket.activeRoom }, {
            "$push": {
                "messages": resMessage
            }
        });


        let result = await collection.findOne({ "_id": socket.activeRoom });
        io.to(socket.activeRoom).emit("getGame", result);

        let oldEnemy = await collection.findOne({ "_id": socket.activeRoom });
        if (oldEnemy.enemy.health < 0 ){
            const random = Math.floor(Math.random() * enemyImages.length);

            const newEnemy = new Enemy({
                 imageName: enemyImages[random],
                health: 100,
                 maxHealth: 100,
                 damage: 10
            })

            collection.updateOne({"_id": socket.activeRoom}, {
                "$set": {
                    "enemy": newEnemy
                }
            });
        }

    });
});

express.get("/messages", async (request, response) => {
    try {
        let result = await collection.findOne({ "_id": request.query.room });
        response.send(result);
    } catch (e) {
        response.status(500).send({ message: e.message });
    }
});

http.listen(3000, async () => {
    try {
        await client.connect();
        collection = client.db("lucidPlan").collection("groups");
        console.log("Listening on port: %s", http.address().port);
    } catch (e) {
        console.error(e);
    }
});